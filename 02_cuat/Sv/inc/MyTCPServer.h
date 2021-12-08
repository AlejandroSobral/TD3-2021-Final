#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <math.h>
#include <signal.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <semaphore.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <pthread.h>
#include <sys/select.h>
#include <sys/sendfile.h>
#include <sys/ipc.h>
#include "../commons/config.h"

#define SEM_KEY_STRUCT 0x546
#define SEM_KEY_CFG 0x556
#define SEM_KEY_SHDMEMY 0x355

#define ARES_2G 2.0f / 32768.0f
#define GYRO_250 250.0f / 32768.0f

#define BACKLOG_DEFAULT 20
#define CANT_CONEX_MAX_DEFAULT 100
#define VENTANA_FILTRO_DEFAULT 2

#define MAX_CONN 10 //This will be set from a file then
#define SHARED_SIZE 4096

#define READING_PIPE 0
#define WRITING_PIPE 1
#define CLOSE_SERVER 1


struct MPU6050_REGS
{
    int16_t accel_xout;
    int16_t accel_yout;
    int16_t accel_zout;
    int16_t temp_out;
    int16_t gyro_xout;
    int16_t gyro_yout;
    int16_t gyro_zout;
};

struct MPU6050_REGS_float
{
    float accel_xout;
    float accel_yout;
    float accel_zout;
    float temp_out;
    float gyro_xout;
    float gyro_yout;
    float gyro_zout;
};

union semun //Beej Guide to UNIX IPC P32
{
    int val;
    struct semid_ds *buf;
    unsigned short *array;
};

struct configValues
{
    uint16_t backlog;
    uint16_t current_connections;
    uint16_t max_connections;
    uint16_t VENTANA_FILTRO;
    uint16_t childs;
    uint16_t exit_server_flag;
};

// Miscelaneous functions.
void print_error(char *e_file, char *e_msg);
void print_msg(char *m_file, char *m_msg);
void print_msg_wValue(char *m_file, char *m_msg, long val);
void print_msg_wFloatValue(char *m_file, char *m_msg, float val);
void print_separate(void);

void ClientThread(void);
void sig_handler_SIGINT(void);
void sig_handler_USR2(void);
void sig_handler_SIGCHILD(int);

// Cfg file functions
int ConfigFile(t_config *, int *, int *, int *);
int SetConfig(struct configValues *);

//Sema
int create_sem(int *, key_t);
void SemWrapCtl(int sem, int num_sem, int value);

//MPU
struct MPU6050_REGS_float FilterAvg(struct configValues *, struct MPU6050_REGS_float *);
