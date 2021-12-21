
1) Furfaro
- TLB. Que es? Que guarda internamente? Como hacer para que al cambiar de CR3 no se flushee la linea en la TLB? 
- Excepción #DF. Como se generan? que es? 
- Tomasulo: que pasa cuando al tener en la RS 2 registros READY para ejecutarse, justo se produce una excepcion? que pasa con el pipeline?
- Que se colocó para almacenar resultados y evaluar si son o no validos? (Reorder Buffer). Esto soluciona el problema planteado en la pregunta anterior?
- Como se crea un proceso en Linux? (fork, explicar el BCP). Que sucede en ese momento con las páginas? Que es COW? 
2) Montenegro
- Cuales son las funciones que hay que llamar para crear un servidor, en principio no concurrente? Explicar los argumentos que reciben y que hace cada una.
- Y si quiero hacer un servidor concurrente? que pasa con el fd que devuelve accept? Le sirve al ppid? 
- Como se atienden las n conexiones entrantes? (haciendo fork o thread luego de accept) . Le sirve el fd del socket del servidor a los hijos? 
3) Alpern
Codigo con una sola tarea. Con CPL=11. Se necesita una TSS? Que campos contiene? Que guarda? Que pasa cuando se produce una excepción o interrupción?