#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termio.h>
#include <signal.h>
#include <sys/time.h>

struct timeval tv0, tv1;
int tiempo;
float total=0;
int k=0;
int j=0;
float bytes_totales = 0;

//////////////////////////////////////////// MAIN ////////////////////////////////////////////////
///  Entran datos por teclado, los pasa al HW y recoje el resultado, que imprime por pantalla  ///
// Para una aplicacion real los datos tendrian que llegar de cualquier lugar y ser pasados a la //
// funcion como la direccion de un char donde estan todos para recojer despues el resultado en  //
//  					  otro char 		                                //
//////////////////////////////////////////////////////////////////////////////////////////////////

int main() {
void iniciar(unsigned int *fd_rd, char *dev_in);
void direccion(int fd_rd, float *x1, float *y1, float *angulo);


  unsigned int fd_rd;
  float x1, y1, angulo;

iniciar(&fd_rd,"/dev/xillybus_fpga2host"); //llamamos a iniciar una vez antes de usar calculo HW
printf("id = %d\n",fd_rd);	

while(1){

gettimeofday(&tv0,NULL);
	direccion(fd_rd, &x1, &y1, &angulo);
gettimeofday(&tv1,NULL);
k++;
tiempo = (int)(tv1.tv_usec - tv0.tv_usec);
if (tiempo > 0){
	total = total + tiempo;
	//printf("tiempo de esta iteración %d us\n",tiempo);
	if ((k % 1000)==0) printf("tiempo medio por calculo %f us\n",total/(bytes_totales/12));
}
//else{
	//j++;
	//printf("van %d negativos!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n",j);
//}

	//printf("x1 = %f ", x1);
	//printf("y1 = %f ", y1);
	if ((k % 1000)==0) printf("angulo = %f\n", angulo);

	}
	return(0);
}

////////////////////////////////////////////// Encapsulado ///////////////////////////////////////////
void direccion(int fd_rd, float *x1, float *y1, float *angulo){

////////////////////////////////////////////// calculoHW //////////////////////////////////////////////

void calculoHW(unsigned char *buf_rd, int datos_rd, int fd_rd, int *leidos){
// *buf_wr es un puntero a una cadena char donde se almacenan los datos de entrada
// *buf_rd es un puntero a una cadena char donde se almacenan los resultados tras el procesado HW
// datos_in es el número de operandos. Se puede modificar (con los consiguientes cambios en el HW) 
// datos_rd es el número de resultados. Se puede modificar (con los consiguientes cambios en el HW) 
// fd es el identificador del device de escritura (fpga to host)
// fd_rd es el identificador del device de lectura (host to fpga)


    // Leemos resultado de la fifo en el HW
	*leidos = read(fd_rd, buf_rd,4092); //leemos 12 bytes, 3*4
	//printf("leidos %d bytes\n",*leidos);

	  if (leidos < 0) {
	     perror("allread() failed to read");
	     exit(1);
	   }
	    
	   if (leidos == 0) {
	     fprintf(stderr, "Reached read EOF.\n");
	     exit(0);

  }
}

// Comienza funcion encapsulado direccion /////////////////////////////////////////////////////////////

	int datos_rd=3;
	unsigned char buf_rd[4096];
int leidos;


	calculoHW(buf_rd,datos_rd,fd_rd, &leidos); //llamamos a la FPGA

	bytes_totales = bytes_totales + leidos;

// Se copian los resultados del buffer de salida
	memcpy(x1,(buf_rd+leidos-12),4);
	memcpy(y1,(buf_rd+leidos-8),4);
	memcpy(angulo,(buf_rd+leidos-4),4);
}

////////////////////////////////////////// Funcion de inicializacion ///////////////////////////////////
//// esta funcion deberá ejecutarse al principio del programa ppal antes de llamar a calculo HW por ////
//                                                primera vez   		                      //

void iniciar(unsigned int *fd_rd, char *dev_in){
// fd: identificador del dev de escritura (host to fpga) que se obtiene en esta funcion (parámetro de salida)
// fd_rd: identificador del dev de lectura (fpga to host) que se obtiene en esta funcion (parámetro de salida)
// dev_out: ruta de acceso al dev de escritura
// dev_in: ruta de acceso al dev de lectura

// Abrimos dev lectura 

 *fd_rd = open(dev_in, O_RDONLY);
  
  if (*fd_rd < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a write-only file?)\n", dev_in);

    perror("Failed to open devfile");
    exit(1);
  }

}



