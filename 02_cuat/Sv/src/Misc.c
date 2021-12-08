#include "../inc/MyTCPServer.h"
extern union semun sem_attr;

int create_sem(int *sema, key_t key)
{
    int ret = 0;
    *sema = semget(key, 1, 0666 | IPC_CREAT); // Create sem with rw rw rw permission
    if (*sema < 0)
    {
        ret = -1;
    }
    union semun u; 
    u.val = 1;     
    // Init sem
    if (semctl(*sema, 0, SETVAL, u) < 0)
    {
        ret = -1;
    }
    return ret;
}

 void SemWrapCtl (int sem, int num_sem, int value){
    sem_attr.val = value;
    if (semctl (sem, num_sem, SETVAL, sem_attr) == -1) {
        printf("QUe op %d\n", value);
       perror ("semctl SETVAL"); 
       exit (1);
    }
 }

void print_error (char* e_file, char* e_msg)
{
    char err[255] = "[ERROR] ";
    strcat(err, e_file);
    strcat(err, " | ");
    strcat(err, e_msg);
    perror(err);
}


void print_msg_wValue (char* m_file, char* m_msg, long val)
{
    char msg[255] = "   ", buf[255];
    strcat(msg, m_file);
    strcat(msg, " | ");
    snprintf(buf, 255, m_msg, val);
    strcat(msg, buf);
    printf("%s\n", msg);
}


void print_separate(void)
{
    printf("*****************************\r\n");
}