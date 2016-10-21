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



////////////////////////////////////////////// Encapsulado ///////////////////////////////////////////
void direccion(int fd_wr, int fd_rd, float p00, float p01, float p10, float p11, float p20, float p21, float *x1, float *y1, float *angulo){

////////////////////////////////////////////// calculoHW //////////////////////////////////////////////

void calculoHW(unsigned char *buf_wr, unsigned char *buf_rd, int datos_in, int datos_rd, int fd_wr, int fd_rd){
// *buf_wr es un puntero a una cadena char donde se almacenan los datos de entrada
// *buf_rd es un puntero a una cadena char donde se almacenan los resultados tras el procesado HW
// datos_in es el número de operandos. Se puede modificar (con los consiguientes cambios en el HW) 
// datos_rd es el número de resultados. Se puede modificar (con los consiguientes cambios en el HW) 
// fd es el identificador del device de escritura (fpga to host)
// fd_rd es el identificador del device de lectura (host to fpga)

////////////////////////////////////////// Funciones internas //////////////////////////////////////////
//    Allwrite se encarga de enviar los datos de SW a HW, escribe en la fifo de entrada en el HW      //
	void allwrite(int fd, unsigned char *buf_wr, int len) {
	  int sent = 0;
	  int rc;	

	  while (sent < len) {
		rc = write(fd, buf_wr + sent, len - sent);
		
		if ((rc < 0) && (errno == EINTR))
		  continue;

		if (rc < 0) {
		  perror("allwrite() failed to write");
		  exit(1);
		}
		
		if (rc == 0) {
		  fprintf(stderr, "Reached write EOF (?!)\n");
		  exit(1);
		}
	 
		sent += rc;
	  }
	} 

/////////////////////////////////////// funcion de calculo en HW ///////////////////////////////////////
	unsigned int rc_rd,i;

	for(i=0;i<(datos_in*4);i=i+4){
		
		allwrite(fd_wr, (buf_wr+i), sizeof(buf_wr));

	}

    // Leemos resultado de la fifo en el HW
gettimeofday(&tv0,NULL);
	rc_rd = read(fd_rd, buf_rd,4); //leemos 12 bytes, 3*4
gettimeofday(&tv1,NULL);
tiempo = (int)(tv1.tv_usec - tv0.tv_usec);
printf("tiempo1 %d us\n",tiempo);

gettimeofday(&tv0,NULL);
	rc_rd = read(fd_rd, buf_rd+4,4);
gettimeofday(&tv1,NULL);
tiempo = (int)(tv1.tv_usec - tv0.tv_usec);
printf("tiempo2 %d us\n",tiempo);

gettimeofday(&tv0,NULL);
	rc_rd = read(fd_rd, buf_rd+8,4);
gettimeofday(&tv1,NULL);
tiempo = (int)(tv1.tv_usec - tv0.tv_usec);
printf("tiempo3 %d us\n",tiempo);
;

	  if (rc_rd < 0) {
	     perror("allread() failed to read");
	     exit(1);
	   }
	    
	   if (rc_rd == 0) {
	     fprintf(stderr, "Reached read EOF.\n");
	     exit(0);

  }
}

// Comienza funcion encapsulado direccion /////////////////////////////////////////////////////////////

	int datos_in=6;
	int datos_rd=3;
	unsigned char buf_wr[256];
	unsigned char buf_rd[256];

// Se copian los datos de entrada al buffer de entrada
	memcpy((buf_wr),&p00,4);
	memcpy((buf_wr+4),&p01,4);
	memcpy((buf_wr+8),&p10,4);
	memcpy((buf_wr+12),&p11,4);
	memcpy((buf_wr+16),&p20,4);
	memcpy((buf_wr+20),&p21,4);

	calculoHW(buf_wr,buf_rd,datos_in,datos_rd, fd_wr, fd_rd); //llamamos a la FPGA

// Se copian los resultados del buffer de salida
	memcpy(x1,(buf_rd),4);
	memcpy(y1,(buf_rd+4),4);
	memcpy(angulo,(buf_rd+8),4);
}

////////////////////////////////////////// Funcion de inicializacion ///////////////////////////////////
//// esta funcion deberá ejecutarse al principio del programa ppal antes de llamar a calculo HW por ////
//                                                primera vez   		                      //

void iniciar(unsigned int *fd_wr, unsigned int *fd_rd, char *dev_out,char *dev_in){
// fd: identificador del dev de escritura (host to fpga) que se obtiene en esta funcion (parámetro de salida)
// fd_rd: identificador del dev de lectura (fpga to host) que se obtiene en esta funcion (parámetro de salida)
// dev_out: ruta de acceso al dev de escritura
// dev_in: ruta de acceso al dev de lectura
// Abrimos dev escritura

  *fd_wr = open(dev_out, O_WRONLY);
  
  if (*fd_wr < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a read-only file?)\n", dev_out);

    perror("Failed to open devfile");
    exit(1);
  }

// Abrimos dev lectura 

 *fd_rd = open(dev_in, O_RDONLY);
  
  if (*fd_rd < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a write-only file?)\n", dev_in);

    perror("Failed to open devfile");
    exit(1);
  }

}

//////////////////////////////////////////// MAIN ////////////////////////////////////////////////
///  Entran datos por teclado, los pasa al HW y recoje el resultado, que imprime por pantalla  ///
// Para una aplicacion real los datos tendrian que llegar de cualquier lugar y ser pasados a la //
// funcion como la direccion de un char donde estan todos para recojer despues el resultado en  //
//  					  otro char 		                                //
//////////////////////////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[]) {

  unsigned int fd_wr,fd_rd;
  float  p00, p01, p10, p11, p20, p21, x1, y1, angulo;

iniciar(&fd_wr,&fd_rd,"/dev/xillybus_host2fpga","/dev/xillybus_fpga2host"); //llamamos a iniciar una vez antes de usar calculo HW
	
    // Leemos data_in operandos por teclado
	//fscanf(stdin, "%f", &p00);	
	//fscanf(stdin, "%f", &p01);	
	//fscanf(stdin, "%f", &p10);	
	//fscanf(stdin, "%f", &p11);	
	//fscanf(stdin, "%f", &p20);	
	//fscanf(stdin, "%f", &p21);	

	p00 = 1.0;
	p01 = 1.0;
	p10 = 3.0;
	p11 = 1.0;
	p20 = 2.0;
	p21 = 3.0;

	direccion(fd_wr, fd_rd, p00, p01, p10, p11, p20, p21, &x1, &y1, &angulo);

	printf("x1 = %f ", x1);
	printf("y1 = %f ", y1);
	printf("angulo = %f\n", angulo);
	
direccion(fd_wr, fd_rd, p00, p01, p10, p11, p20, p21, &x1, &y1, &angulo);
printf("x1 = %f ", x1);
	printf("y1 = %f ", y1);
	printf("angulo = %f\n", angulo);
	
	return(0);
}




