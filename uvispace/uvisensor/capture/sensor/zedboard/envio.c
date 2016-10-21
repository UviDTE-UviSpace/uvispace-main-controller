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
void direccion(int fd_wr, float p00, float p01, float p10, float p11, float p20, float p21){

////////////////////////////////////////////// calculoHW //////////////////////////////////////////////

void calculoHW(unsigned char *buf_wr, int datos_in, int fd_wr){
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
	unsigned int i;

	for(i=0;i<(datos_in*4);i=i+4){
		
		allwrite(fd_wr, (buf_wr+i), sizeof(buf_wr));

	}

  }


// Comienza funcion encapsulado direccion /////////////////////////////////////////////////////////////

	int datos_in=6;
	unsigned char buf_wr[256];

// Se copian los datos de entrada al buffer de entrada
	memcpy((buf_wr),&p00,4);
	memcpy((buf_wr+4),&p01,4);
	memcpy((buf_wr+8),&p10,4);
	memcpy((buf_wr+12),&p11,4);
	memcpy((buf_wr+16),&p20,4);
	memcpy((buf_wr+20),&p21,4);

	calculoHW(buf_wr,datos_in, fd_wr); //llamamos a la FPGA
}


////////////////////////////////////////// Funcion de inicializacion ///////////////////////////////////
//// esta funcion deberá ejecutarse al principio del programa ppal antes de llamar a calculo HW por ////
//                                                primera vez   		                      //

void iniciar(unsigned int *fd_wr, char *dev_out){
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

}

//////////////////////////////////////////// MAIN ////////////////////////////////////////////////
///  Entran datos por teclado, los pasa al HW y recoje el resultado, que imprime por pantalla  ///
// Para una aplicacion real los datos tendrian que llegar de cualquier lugar y ser pasados a la //
// funcion como la direccion de un char donde estan todos para recojer despues el resultado en  //
//  					  otro char 		                                //
//////////////////////////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[]) {

  unsigned int fd_wr,i=0;
  float  p00, p01, p10, p11, p20, p21;

iniciar(&fd_wr,"/dev/xillybus_host2fpga"); //llamamos a iniciar una vez antes de usar calculo HW
	
 while(i<4000000){
i++;
	p00 = 1.0;
	p01 = 1.0;
	p10 = 3.0;
	p11 = 1.0;
	p20 = 2.0;
	p21 = 3.0;

	direccion(fd_wr, p00, p01, p10, p11, p20, p21);

	
	//printf("envio %d\n",i);	
	i++;

	p00 = 1.5;
	p01 = 1.0;
	p10 = 3.0;
	p11 = 0.5;
	p20 = 0.2;
	p21 = 0.3;

	direccion(fd_wr, p00, p01, p10, p11, p20, p21);
//printf("envio %d\n",i);	
	i++;

	p00 = 1.21;
	p01 = 2.34;
	p10 = -2.314;
	p11 = 1.89;
	p20 = 7.65;
	p21 = 2.37;

	direccion(fd_wr, p00, p01, p10, p11, p20, p21);
//printf("envio %d\n",i);
	i++;	

	p00 = 7.532;
	p01 = -1.718;
	p10 = -7.2;
	p11 = 1.52173;
	p20 = 12.3718;
	p21 = -1.2727;

	direccion(fd_wr, p00, p01, p10, p11, p20, p21);
//printf("envio %d\n",i);
	if (i >= 3999995) {printf("FIN\n");}

}

   
return(0);
}




