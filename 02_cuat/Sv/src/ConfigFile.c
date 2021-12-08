#include "../commons/config.h"
#include "../inc/MyTCPServer.h"

#define CONFIG_PATH "./cfg/config_file.cfg"

int SetConfig(struct configValues* configStruct)
{
    t_config* config;
    config = config_create(CONFIG_PATH);
    if (config != NULL)
    {
        
        //El archivo existe, lo leo.
        if (config_has_property(config, "CANTIDAD_CONEXIONES") == true)
            configStruct->max_connections = config_get_int_value(config, "CANTIDAD_CONEXIONES");
        else
            configStruct->max_connections = CANT_CONEX_MAX_DEFAULT;

        if (config_has_property(config, "BACKLOG") == true)
            configStruct->backlog = config_get_int_value(config, "BACKLOG");
        else
            configStruct->backlog = BACKLOG_DEFAULT;

        if (config_has_property(config, "VENTANA_FILTRO") == true)
            configStruct->VENTANA_FILTRO = config_get_int_value(config, "VENTANA_FILTRO");
            
        else
            configStruct->VENTANA_FILTRO = VENTANA_FILTRO_DEFAULT;
    }
    else
    {
        //No existe el archivo de configuracion, utilizo valores por default
        printf("File doesn't exist!\n");
        configStruct->backlog = BACKLOG_DEFAULT;
        configStruct->max_connections = CANT_CONEX_MAX_DEFAULT;
        configStruct->VENTANA_FILTRO = VENTANA_FILTRO_DEFAULT;
        return -1;
    }
    return 0;
}
