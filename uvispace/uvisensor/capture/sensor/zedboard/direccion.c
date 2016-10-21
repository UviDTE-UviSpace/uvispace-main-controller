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

void direccion(int fd_wr, int fd_rd, float p00, float p01, float p10, float p11, float p20, float p21, float *x1, float *y1, float *angulo){

void calculoHW(unsigned char *buf_wr, unsigned char *buf_rd, int datos_in, int datos_rd, int fd_wr, int fd_rd){
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

	unsigned int rc_rd,i;

	for(i=0;i<(datos_in*4);i=i+4){
		
		allwrite(fd_wr, (buf_wr+i), sizeof(buf_wr));

	}


	rc_rd = read(fd_rd, buf_rd, datos_rd*4); 
	  if (rc_rd < 0) {
	     perror("allread() failed to read");
	     exit(1);
	   }
	    
	   if (rc_rd == 0) {
	     fprintf(stderr, "Reached read EOF.\n");
	     exit(0);

  }
}


	int datos_in=6;
	int datos_rd=3;
	unsigned char buf_wr[256];
	unsigned char buf_rd[256];


	memcpy((buf_wr),&p00,4);
	memcpy((buf_wr+4),&p01,4);
	memcpy((buf_wr+8),&p10,4);
	memcpy((buf_wr+12),&p11,4);
	memcpy((buf_wr+16),&p20,4);
	memcpy((buf_wr+20),&p21,4);

	calculoHW(buf_wr,buf_rd,datos_in,datos_rd, fd_wr, fd_rd);


	memcpy(x1,(buf_rd),4);
	memcpy(y1,(buf_rd+4),4);
	memcpy(angulo,(buf_rd+8),4);
}

void iniciar(int *fd_wr, int *fd_rd){

  *fd_wr = open("/dev/xillybus_host2fpga", O_WRONLY);
  
  if (*fd_wr < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a read-only file?)\n", "/dev/xillybus_host2fpga");

    perror("Failed to open devfile");
    exit(1);
  }

 *fd_rd = open("/dev/xillybus_fpga2host", O_RDONLY);
  
  if (*fd_rd < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a write-only file?)\n", "/dev/xillybus_fpga2host");

    perror("Failed to open devfile");
    exit(1);
  }

}


