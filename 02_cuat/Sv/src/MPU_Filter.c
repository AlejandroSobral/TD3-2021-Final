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
#include <sys/sem.h>
#include <sys/stat.h>
#include <sys/select.h>
#include <sys/sendfile.h>

#include "../inc/MyTCPServer.h"

struct MPU6050_REGS_float FilterAvg(struct configValues *ConfigStruct, struct MPU6050_REGS_float *Values)
{
    static struct MPU6050_REGS_float Avg;
    struct MPU6050_REGS_float Aux_struct, dum;
    static int Reads, last_scope, first;
    int Size;

    Size = ConfigStruct->VENTANA_FILTRO;

    if (first == 0)
    { // First time
        first = 11;
        last_scope = Size;
    }

    if (last_scope != Size)
    {
        Reads = 0;
        printf("Scope has been changed, drop measurements\n");
        last_scope = Size;
        Avg.temp_out = 0;
        Avg.gyro_xout = 0;
        Avg.gyro_yout = 0;
        Avg.gyro_zout = 0;
        Avg.accel_xout = 0;
        Avg.accel_yout = 0;
        Avg.accel_zout = 0;
        Reads = 0;
    } //In case scope changes on the fly
    else
    {
        Reads++;
        if (Reads - 1 < Size)
        { // Add & Acc
            Avg.temp_out += Values->temp_out;
            Avg.gyro_xout += Values->gyro_xout;
            Avg.gyro_yout += Values->gyro_yout;
            Avg.gyro_zout += Values->gyro_zout;
            Avg.accel_xout += Values->accel_xout;
            Avg.accel_yout += Values->accel_yout;
            Avg.accel_zout += Values->accel_zout;
        }
        else //Calculate avg
        {
            Avg.temp_out = Avg.temp_out / Size;
            Avg.gyro_xout = Avg.gyro_xout / Size;
            Avg.gyro_yout = Avg.gyro_yout / Size;
            Avg.gyro_zout = Avg.gyro_zout / Size;
            Avg.accel_xout = Avg.accel_xout / Size;
            Avg.accel_yout = Avg.accel_yout / Size;
            Avg.accel_zout = Avg.accel_zout / Size;

            //printf("Average temp: %f\n", Avg.temp_out);

            Aux_struct = Avg;

            Avg.temp_out = 0;
            Avg.gyro_xout = 0;
            Avg.gyro_yout = 0;
            Avg.gyro_zout = 0;
            Avg.accel_xout = 0;
            Avg.accel_yout = 0;
            Avg.accel_zout = 0;

            Reads = 0;
            last_scope = Size;
            return Aux_struct;
        }
    }
}