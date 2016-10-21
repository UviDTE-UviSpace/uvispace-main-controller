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

void iniciar(unsigned int *fd_wr, unsigned int *fd_rd, char *dev_out,char *dev_in){

  *fd_wr = open(dev_out, O_WRONLY);
  
  if (*fd_wr < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a read-only file?)\n", dev_out);

    perror("Failed to open devfile");
    exit(1);
  }

 *fd_rd = open(dev_in, O_RDONLY);
  
  if (*fd_rd < 0) {
    if (errno == ENODEV)
      fprintf(stderr, "(Maybe %s a write-only file?)\n", dev_in);

    perror("Failed to open devfile");
    exit(1);
  }

}
