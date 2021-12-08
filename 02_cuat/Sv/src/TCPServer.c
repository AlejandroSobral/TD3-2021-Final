#include "../inc/MyTCPServer.h"
#include "../commons/config.h"

int s_aux; //Socket
int Port;
int GlobalSocket; //Global Socket

/**SHM MMY***/
int SemaShmdMemry, SemaCfgUpdate, SemaCtlStruct;
void *sharedMemPtr = (void *)0;
void *sharedMemCfgPtr = (void *)0;
struct MPU6050_REGS_float *SensorData;
struct configValues *ConfigCtlStruct;

/*SEM DEF*/
union semun sem_attr;

struct sembuf Allocate = {0, -1, SEM_UNDO}; // Allocate resource
struct sembuf Release = {0, +1, SEM_UNDO};  // Release resource

int main(int argc, char *argv[])
{

  struct sockaddr_in address;
  t_config *config; //Cfg file pointing
  socklen_t addrlen;
  pid_t sensor_query_pid, cfg_query_pid;

  int sharedMemId, sharedMemCfgId;

  struct sigaction Sa_SigChild, Sa_SigInt;

  if (create_sem(&SemaCtlStruct, SEM_KEY_STRUCT) == -1)
  {
    perror("Error creating a sempahore\n");
    exit(1);
  }

  if (create_sem(&SemaCfgUpdate, SEM_KEY_CFG) == -1)
  {
    perror("Error creating a sempahore\n");
    exit(1);
  }

  if (create_sem(&SemaShmdMemry, SEM_KEY_SHDMEMY) == -1)
  {
    perror("Error creating a sempahore\n");
    exit(1);
  }

  sigemptyset(&Sa_SigChild.sa_mask);
  Sa_SigChild.sa_handler = (void *)sig_handler_SIGCHILD;
  Sa_SigChild.sa_flags = 0; // or SA_RESTART

  if (sigaction(SIGCHLD, &Sa_SigChild, NULL) == -1)
  {
    perror("sigaction\n");
    exit(1);
  }

  sigemptyset(&Sa_SigInt.sa_mask);
  Sa_SigInt.sa_handler = (void *)sig_handler_SIGINT;
  Sa_SigInt.sa_flags = 0; // or SA_RESTART

  if (sigaction(SIGINT, &Sa_SigInt, NULL) == -1)
  {
    perror("sigaction\n");
    exit(1);
  }
  Port = atoi(argv[1]);

  if (argc == 2) //Check parameters
  {
    int Config_file_result;

    if (Config_file_result == -1)
    {
      perror("Error during config file strep\n");
      exit(1);
    }

    /****************************************SHARED MEMRY FOR DATA****************************************/
    sharedMemId = shmget((key_t)0x1234, SHARED_SIZE, 0666 | IPC_CREAT);
    if (sharedMemId == -1)
    {
      print_error(__FILE__, "shmget failed");

      return -1;
    }
    // Attach shmem
    sharedMemPtr = shmat(sharedMemId, (void *)0, 0);
    if (sharedMemPtr == (void *)-1)
    {
      print_error(__FILE__, "shmat failed");
      return -1;
    }
    print_msg_wValue(__FILE__, "Shared memory attached at: %p", (long)sharedMemPtr);

    // Point the struct to the corresponding shared memory.
    SensorData = (struct MPU6050_REGS_float *)sharedMemPtr;
    /********************************************************************************************/

    /********************************************SHARED MEMRY FOR CFG/****************************************/
    sharedMemCfgId = shmget((key_t)0x4567, SHARED_SIZE, 0666 | IPC_CREAT);
    if (sharedMemCfgId == -1)
    {
      print_error(__FILE__, "shmget failed");

      return -1;
    }
    // Attach shmem
    sharedMemCfgPtr = shmat(sharedMemCfgId, (void *)0, 0);
    if (sharedMemCfgPtr == (void *)-1)
    {
      print_error(__FILE__, "shmat failed");
      return -1;
    }
    print_msg_wValue(__FILE__, "Shared memory attached at: %p", (long)sharedMemCfgPtr);

    // Point the struct to the corresponding shared memory.
    ConfigCtlStruct = (struct configValues *)sharedMemCfgPtr;

    semop(SemaCfgUpdate, &Allocate, 1); //Allocate
    Config_file_result = SetConfig(ConfigCtlStruct);
    semop(SemaCfgUpdate, &Release, 1); //Release

    print_separate();
    printf("Cantidad maxima de conexiones: %d\n", ConfigCtlStruct->max_connections);
    printf("Backlog: %d\n", ConfigCtlStruct->backlog);
    printf("Ventana del filtro: %d\n", ConfigCtlStruct->VENTANA_FILTRO);

    semop(SemaCtlStruct, &Allocate, 1); //Allocate
    ConfigCtlStruct->current_connections = 0;
    ConfigCtlStruct->childs = 0;
    ConfigCtlStruct->exit_server_flag = 1;
    semop(SemaCtlStruct, &Release, 1); //Release
                                       /********************************************************************************************/
    print_separate();
    printf("Parent Process (PP): PID %d\n", getpid());

    /*****************************************Child Query Sensor****************************/
    sensor_query_pid = fork();
    if (sensor_query_pid == 0) // Child Query Sensor
    {
      float auxAx = 0, auxAy = 0, auxAz = 0, auxGx = 0, auxGy = 0, auxGz = 0, auxT = 0;
      int16_t auxTem = 0, auxAcel = 0, auxGyr = 0;
      uint8_t i2CRawData[14];
      static int Reads = 0;
      struct MPU6050_REGS_float Avg;

      ConfigCtlStruct->childs++;
      print_separate();
      printf("Sensor child (SC): PID %d \n", getpid());
      struct MPU6050_REGS_float struct_aux;
      int device_fd;
      device_fd = open("/dev/My_i2c_TD3", O_RDWR);
      if (device_fd < 0)
      {
        perror("Error while reading a device.\n");

        semop(SemaCtlStruct, &Allocate, 1); //Allocate
        ConfigCtlStruct->childs--;
        semop(SemaCtlStruct, &Release, 1); //Release
        exit(1);
      }

      while (ConfigCtlStruct->exit_server_flag)
      {

        ssize_t DevSizeRead = read(device_fd, &i2CRawData, sizeof(struct MPU6050_REGS));
        Reads++;
        auxAcel = (int16_t)((i2CRawData[0] << 8) | i2CRawData[1]);
        struct_aux.accel_xout = (float)auxAcel * ARES_2G;
        auxAcel = (int16_t)((i2CRawData[2] << 8) | i2CRawData[3]);
        struct_aux.accel_yout = (float)auxAcel * ARES_2G;
        auxAcel = (int16_t)((i2CRawData[4] << 8) | i2CRawData[5]);
        struct_aux.accel_zout = (float)auxAcel * ARES_2G;

        auxTem = (int16_t)((i2CRawData[6] << 8) | i2CRawData[7]);
        struct_aux.temp_out = ((float)auxTem / 340) + 36.53;

        auxGyr = (int16_t)((i2CRawData[8] << 8) | i2CRawData[9]);
        struct_aux.gyro_xout = (float)auxGyr * GYRO_250;
        auxGyr = (int16_t)((i2CRawData[10] << 8) | i2CRawData[11]);
        struct_aux.gyro_yout = (float)auxGyr * GYRO_250 - 2;
        auxGyr = (int16_t)((i2CRawData[12] << 8) | i2CRawData[13]);
        struct_aux.gyro_zout = (float)auxGyr * GYRO_250 - 0.3;

        Avg = FilterAvg(ConfigCtlStruct, &struct_aux);
        //SemWrapCtl(SemaShmdMemry, 0, 0);
        //It is acceptable to perform this atomic operation as long as all sem are different sets with 1 sem on it.
        semop(SemaCtlStruct, &Allocate, 1);
        *SensorData = Avg;
        semop(SemaCtlStruct, &Release, 1);
        //SemWrapCtl(SemaShmdMemry, 0, 1);

        usleep(5000);
      }
      close(device_fd);
      print_separate();
      printf("SC: %d about to die\n", getpid());
      semop(SemaCtlStruct, &Allocate, 1);
      ConfigCtlStruct->childs--;
      semop(SemaCtlStruct, &Release, 1);
      exit(1);
    }
    /************************************************************************************************/

    /*****************************************Configuration Update Sensor****************************/
    cfg_query_pid = fork(); //This child will attend the SIGUS2 signal to update cfg

    if (cfg_query_pid == 0)
    {
      semop(SemaCtlStruct, &Allocate, 1);
      ConfigCtlStruct->childs++;
      semop(SemaCtlStruct, &Release, 1);
      print_separate();
      printf("Configuration child PID: %d \n", getpid());
      struct sigaction sa2;
      sigemptyset(&sa2.sa_mask);
      sa2.sa_handler = (void *)sig_handler_USR2;
      sa2.sa_flags = 0; // or SA_RESTART

      if (sigaction(SIGUSR2, &sa2, NULL) == -1)
      {
        perror("sigaction\n");
        exit(1);
      }
      while (ConfigCtlStruct->exit_server_flag)
      {
        usleep(5000);
      }
      print_separate();
      printf("Config child about to die\n");
      semop(SemaCtlStruct, &Allocate, 1);
      ConfigCtlStruct->childs--;
      semop(SemaCtlStruct, &Release, 1);
      exit(1);
    }
    /*************************************************************************/
    pthread_t thread_id;
    addrlen = sizeof(address);
    pid_t PyClient_pid;

    GlobalSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (GlobalSocket == -1)
    {
      perror("Socket failure\n");
      exit(1); //A la verga todo hermano
    }
    address.sin_family = AF_INET;
    address.sin_port = htons(Port);
    address.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(GlobalSocket, (struct sockaddr *)&address, sizeof(address)) == -1)
    {
      perror("Bind failure\n");
      exit(1);
    }
    printf("Listening at port: %d\n", Port);

    if (listen(GlobalSocket, ConfigCtlStruct->backlog) < 0)
    {
      perror("Error en listen");
      return -1;
      exit(1);
    }

    while (ConfigCtlStruct->exit_server_flag) //Accept fork
    {
      fd_set readfds;
      int nbr_fds;
      struct timeval timeout;
      static bool max_connected;

      // Waits here is there are too many at backlog
      while (max_connected)
      {
        print_separate();
        printf("Server: Nºcurrent clients %d\n", ConfigCtlStruct->current_connections);
        printf("Server: Max allowed %d\n", ConfigCtlStruct->max_connections);
        sleep(1);
        if (ConfigCtlStruct->current_connections < ConfigCtlStruct->max_connections)
        {
          max_connected = false;
        }
        else
        {
          max_connected = true;
          print_separate();
          printf("Server: Too many connections at backloog, wait dude\n");
        }
      }

      if (ConfigCtlStruct->current_connections < ConfigCtlStruct->max_connections) //Only if the current is less than the max
      {
        FD_ZERO(&readfds);
        FD_SET(GlobalSocket, &readfds);

        timeout.tv_sec = 1;
        timeout.tv_usec = 0;
        nbr_fds = select(GlobalSocket + 1, &readfds, NULL, NULL, &timeout); // Execution will stop here for <timeout> time

        if (nbr_fds > 0)
        {
          if ((s_aux = accept(GlobalSocket, (struct sockaddr *)&address, &addrlen)) < 0)
          {
            if (ConfigCtlStruct->exit_server_flag == 1)
            {
              perror("Accept error");
              exit(1);
            }
          }

          if (ConfigCtlStruct->exit_server_flag)
          {
            semop(SemaCtlStruct, &Allocate, 1); //Allocate
            ConfigCtlStruct->current_connections++;
            semop(SemaCtlStruct, &Release, 1); //Release

            PyClient_pid = fork();

            if (PyClient_pid == 0) // Child
            {
              char DataPyIn[255];
              char ipAddr[20];
              char DataPyOut[1024];
              print_separate();
              printf("New Connection Child (CC) PID: %d\n", getpid());
              semop(SemaCtlStruct, &Allocate, 1); //Allocate
              ConfigCtlStruct->childs++;
              semop(SemaCtlStruct, &Release, 1); //Allocate
              print_separate();
              printf("CC %d: says Current connections: %d\n", getpid(), ConfigCtlStruct->current_connections);
              strcpy(ipAddr, inet_ntoa(address.sin_addr));
              Port = ntohs(address.sin_port);

              sprintf(DataPyOut, "OK");
              print_separate();
              printf("CC %d: Send OK to %s:%d \n", getpid(), ipAddr, Port);

              if (send(s_aux, DataPyOut, strlen(DataPyOut), 0) == -1)
              {
                perror("CC Send error");
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }
              if (recv(s_aux, DataPyIn, sizeof(DataPyIn), 0) == -1)
              {

                perror("CC Recv error");
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }

              if (!memcmp(DataPyIn, "AKN", 3))
              {
                print_separate();
                printf("CC %d got: from %s:%d > AKN\n", getpid(), ipAddr, Port);
              }
              else
              {
                print_separate();
                printf("CC %d : Wrong answer from client. Close child\n", getpid());
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }

              sprintf(DataPyOut, "OK");
              print_separate();
              printf("CC %d : SEND to %s:%d OK\n", getpid(), ipAddr, Port);

              if (send(s_aux, DataPyOut, strlen(DataPyOut), 0) == -1)
              {
                perror("CC Send error");
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }
              if (recv(s_aux, DataPyIn, sizeof(DataPyIn), 0) == -1)
              {
                perror("CC Recv error");
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }

              if (!memcmp(DataPyIn, "KA", 2))
              {
                print_separate();
                printf("CC %d : got from %s:%d > KA\n", getpid(), ipAddr, Port);
              }
              else
              {
                print_separate();
                printf("CC %d : Wrong answer from client. Close child\n", getpid());
                semop(SemaCtlStruct, &Allocate, 1); //Allocate
                ConfigCtlStruct->childs--;
                ConfigCtlStruct->current_connections--;
                semop(SemaCtlStruct, &Release, 1); //Release
                exit(1);
              }

              do
              { //Ends after geting...an END...

                semop(SemaShmdMemry, &Allocate, 1);
                sprintf(DataPyOut, "%.1f\n%.1f\n%.1f\n%.1f\n%.1f\n%.1f\n%.2f\n",
                        SensorData->accel_xout,
                        SensorData->accel_yout,
                        SensorData->accel_zout,
                        SensorData->gyro_xout,
                        SensorData->gyro_yout,
                        SensorData->gyro_zout,
                        SensorData->temp_out);
                semop(SemaShmdMemry, &Release, 1);

                if (send(s_aux, DataPyOut, strlen(DataPyOut), 0) == -1)
                {
                  perror("CC Send error");
                  semop(SemaCtlStruct, &Allocate, 1); //Allocate
                  ConfigCtlStruct->childs--;
                  ConfigCtlStruct->current_connections--;
                  semop(SemaCtlStruct, &Release, 1); //Release
                  exit(1);
                }

                if (recv(s_aux, DataPyIn, sizeof(DataPyIn), 0) == -1)
                {
                  print_separate();
                  printf("CC %d : Wrong answer from client. Close child\n", getpid());
                  semop(SemaCtlStruct, &Allocate, 1); //Allocate
                  ConfigCtlStruct->childs--;
                  ConfigCtlStruct->current_connections--;
                  semop(SemaCtlStruct, &Release, 1); //Release
                  exit(1);
                }
                if (!memcmp(DataPyIn, "END", 3))
                {
                  print_separate();
                  printf("CC %d : closed the connection %s:%d \n", getpid(), ipAddr, Port);
                }
                sleep(0.05);
              } while (memcmp(DataPyIn, "END", 3));

              semop(SemaCtlStruct, &Allocate, 1); //Allocate
              ConfigCtlStruct->current_connections--;
              print_separate();
              printf("CC about to die\n");
              ConfigCtlStruct->childs--;
              semop(SemaCtlStruct, &Release, 1); //Release
              exit(1);
            }
            //End child
          }
          close(s_aux);
        }
      }
      else
      {
        max_connected = true;
        print_separate();
        printf("Server: Max connections reached\n");
        sleep(1);
      }
      usleep(5000);
    }

    if (semctl(SemaCtlStruct, 0, IPC_RMID) < 0)
      perror("Sema Ctl Struct didn't close properly\n");
    if (semctl(SemaCfgUpdate, 0, IPC_RMID) < 0)
      perror("Sema Cfg Update didn't close properly\n");
    if (semctl(SemaShmdMemry, 0, IPC_RMID) < 0)
      perror("SemaShmdMem didn't close properly\n");

    while (ConfigCtlStruct->childs > 0)
    {
      print_separate();
      printf("Waiting childs to end\n");
      printf("Nº of active childs %d\n", ConfigCtlStruct->childs);
      sleep(1);
    }
    print_separate();
    printf("All childs are gone\n");
    if (shmdt(sharedMemPtr) < 0)
      perror("ShmMemPtr didn't close properly");
    if (shmctl(sharedMemId, IPC_RMID, NULL) < 0)
      perror("SharedMemId did't remove properly\n");
    if (shmdt(sharedMemCfgPtr) < 0)
      perror("ShmMemCfgPtr didn't close properly");
    if (shmctl(sharedMemCfgId, IPC_RMID, NULL) < 0)
      perror("SharedMeCfgId did't remove properly\n");

    int close_result;
    close_result = close(GlobalSocket);
    print_separate();
    printf("*******End of server*******\n");
    printf("Server has been closed with exit code %d\n", close_result);
  }
  return 0; // Parent byebye
}

void sig_handler_SIGINT(void)
{
  print_separate();
  printf("----SIGINT HANDLER-------\n");
  printf("I'm %d at SIGINT\n", getpid());
  ConfigCtlStruct->exit_server_flag = 0;
  printf("----SIGINT HANDLER EXIT-------\r\n");
}

void sig_handler_SIGCHILD(int sig)
{
  pid_t deadchild = 1;
  while (deadchild > 0)
  {
    deadchild = waitpid(-1, NULL, WNOHANG);
    if (deadchild > 0)
    {
      print_separate();
      printf("----SIGCHILD HANDLER-------\n");
      printf("Child Nº ID=%d have died\r\n", deadchild);
      printf("Number of active childs %d\n", ConfigCtlStruct->childs);
      printf("----SIGCHILD HANDLER END-------\r\n");
    }
  }
}

void sig_handler_USR2(void)
{
  semop(SemaCfgUpdate, &Allocate, 1); //Allocate
  if (SetConfig(ConfigCtlStruct) < 0)
  {
    perror("Error during config file step\n");
    exit(1);
  }
  printf("\r\n----SIGUSR2 HANDLER-------\n");
  printf("Server cfg has been updated\n");
  printf("Cantidad maxima de conexiones: %d\n", ConfigCtlStruct->max_connections);
  printf("Backlog: %d\n", ConfigCtlStruct->backlog);
  printf("Ventana del filtro: %d\n", ConfigCtlStruct->VENTANA_FILTRO);
  printf("\r\n----SIGUSR2 HANDLER END-----\n");
  semop(SemaCfgUpdate, &Release, 1); //Release
}
