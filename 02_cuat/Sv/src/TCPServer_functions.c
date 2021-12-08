#include "../inc/MyTCPServer.h"

/**
 * \brief Get all ready for TCP but the accept()
 **/
  extern int GlobalSocket;
int TCP_Server_Starts_Socket(int Port)
{
    int s_aux, nbr_fds;
    struct sockaddr_in address;
  
    GlobalSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (GlobalSocket != -1)
    {
        address.sin_family = AF_INET;
        address.sin_port = htons(Port);
        address.sin_addr.s_addr = htonl(INADDR_ANY);

        if (bind(GlobalSocket, (struct sockaddr *)&address, sizeof(address)) != -1)
        {
            printf("Listening at port: %d\n", Port);

            if (listen(GlobalSocket, MAX_CONN) < 0)
            {
                perror("Error en listen");
                return -1;
                exit(1);
            }

            fd_set readfds;
            FD_ZERO(&readfds);
            FD_SET(GlobalSocket, &readfds);

            nbr_fds = select(GlobalSocket + 1, &readfds, NULL, NULL, NULL);

            if ((nbr_fds < 0) && (errno != EINTR))
            {
                perror("select");
                return -1;
            }
            // if (!FD_ISSET(s, &readfds)) // Return true if fd is in the set.
            // {
            //     continue;
            // }
        return nbr_fds;
        }
    }
}


int create_sem(int *sema, key_t key)
{
    int ret = 0;
    *sema = semget(key, 1, 0666 | IPC_CREAT); // semget crea 1 semáforo con permisos rw rw rw
    if (*sema < 0)
    {
        ret = -1;
    }
    union semun u; // Crea la union
    u.val = 1;     // Asigna un 1 al val
    // Inicializo el semáforo para utilizarlo
    if (semctl(*sema, 0, SETVAL, u) < 0)
    {
        ret = -1;
    }

    return ret;
}