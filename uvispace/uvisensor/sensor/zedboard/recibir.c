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

//////////////////////////////////////////// MAIN ////////////////////////////////////////////////
///  Entran datos por teclado, los pasa al HW y recoje el resultado, que imprime por pantalla  ///
// Para una aplicacion real los datos tendrian que llegar de cualquier lugar y ser pasados a la //
// funcion como la direccion de un char donde estan todos para recojer despues el resultado en  //
//  					  otro char 		                                //
//////////////////////////////////////////////////////////////////////////////////////////////////

int main() {
void direccion(int fd_rd, float *x1, float *y1, float *angulo);


  unsigned int fd_rd,leidos;
  float x1, y1, angulo;
unsigned char buf_rd[1024];

fd_rd = open("/dev/xillybus_fpga2host", O_RDONLY);
printf("id = %d\n",fd_rd);	

while(1){
printf("while ");
gettimeofday(&tv0,NULL);


printf("antes -> ");
	leidos = read(fd_rd, buf_rd,1020); //leemos 12 bytes, 3*4
	printf("leidos %d bytes\n",leidos);

	memcpy(&x1,(buf_rd+leidos-12),4);
	memcpy(&y1,(buf_rd+leidos-8),4);
	memcpy(&angulo,(buf_rd+leidos-4),4);

gettimeofday(&tv1,NULL);
tiempo = (int)(tv1.tv_usec - tv0.tv_usec);
printf("tiempo %d us\n",tiempo);

	printf("x1 = %f ", x1);
	printf("y1 = %f ", y1);
	printf("angulo = %f\n", angulo);

	}
	return(0);
}


