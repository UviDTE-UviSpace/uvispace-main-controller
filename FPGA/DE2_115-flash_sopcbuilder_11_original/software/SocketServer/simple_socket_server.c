/*
 * Simple Socket Server (SSS) example.
 */
 
#include <stdio.h>
#include <string.h>
#include <ctype.h> 

/* MicroC/OS-II definitions */
#include "includes.h"

/* Simple Socket Server definitions */
#include "simple_socket_server.h"                                                                    
#include "alt_error_handler.h"

/* Nichestack definitions */
#include "ipport.h"
#include "tcpport.h"

/* Peripheral incluedes */
#include <altera_avalon_pio_regs.h>

#include "camera.h"
#include "apio_sensor_regs.h" // TODO: Group in functions like camera
#include "trackers.h"

/*
 * Global handles (pointers) to our MicroC/OS-II resources. All of resources 
 * beginning with "SSS" are declared and created in this file.
 */

/*
 * sss_reset_connection()
 * 
 * This routine will, when called, reset our SSSConn struct's members 
 * to a reliable initial state. Note that we set our socket (FD) number to
 * -1 to easily determine whether the connection is in a "reset, ready to go" 
 * state.
 */
void sss_reset_connection(SSSConn* conn) {
	memset(conn, 0, sizeof(SSSConn));

	conn->fd = -1;
	conn->state = READY;
	conn->rx_wr_pos = conn->rx_buffer;
	conn->rx_rd_pos = conn->rx_buffer;
}

/*
 * sss_send_menu()
 * 
 * This routine will transmit the menu out to the telnet client.
 */
void sss_send_menu(SSSConn* conn) {
	alt_u8  tx_buf[SSS_TX_BUF_SIZE];
	alt_u8 *tx_wr_pos = tx_buf;

	tx_wr_pos += sprintf(tx_wr_pos, "===========================================\n");
	tx_wr_pos += sprintf(tx_wr_pos, "Nios II Camera Commands Menu               \n");
	tx_wr_pos += sprintf(tx_wr_pos, "===========================================\n");
	tx_wr_pos += sprintf(tx_wr_pos, "                                           \n");
	tx_wr_pos += sprintf(tx_wr_pos, "r,xx: Read value of register (xx)          \n");
	tx_wr_pos += sprintf(tx_wr_pos, "w,xx,yy: Write value (yy) in register (xx) \n");
	tx_wr_pos += sprintf(tx_wr_pos, "                                           \n");
	tx_wr_pos += sprintf(tx_wr_pos, "C: Configure camera sensor                 \n");
	tx_wr_pos += sprintf(tx_wr_pos, "S: Start/Stop capture                      \n");
	tx_wr_pos += sprintf(tx_wr_pos, "D: Send RGB image data                     \n");
	tx_wr_pos += sprintf(tx_wr_pos, "G: Send gray image data                    \n");
	tx_wr_pos += sprintf(tx_wr_pos, "V: VGA (live video mode)                   \n");
	tx_wr_pos += sprintf(tx_wr_pos, "                                           \n");
	tx_wr_pos += sprintf(tx_wr_pos, "Q: Terminate session                       \n");
	tx_wr_pos += sprintf(tx_wr_pos, "===========================================\n");
	tx_wr_pos += sprintf(tx_wr_pos, "Enter your choice & press return:>\n");

	send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
}

/*
 * sss_exec_command()
 * 
 * This routine is called whenever we have new, valid receive data from our 
 * sss connection. It will parse through the data simply looking for valid
 * commands to the sss server.
 * 
 * Incoming commands to talk to the board LEDs are handled by sending the 
 * MicroC/OS-II SSSLedCommandQ a pointer to the value we received.
 * 
 * If the user wishes to quit, we set the "close" member of our SSSConn
 * struct, which will be looked at back in sss_handle_receive() when it 
 * comes time to see whether to close the connection or not.
 */

void sss_exec_command(SSSConn* conn) {
	int bytes_to_process = conn->rx_wr_pos - conn->rx_rd_pos;
	INT8U tx_buf[SSS_TX_BUF_SIZE];
	INT8U *tx_wr_pos = tx_buf;

    INT8U error_code;
    
    /*
     * "SSSCommand" is declared static so that the data will reside
     * in the BSS segment. This is done because a pointer to the data in
     * SSSCommand will be passed via SSSLedCommandQ to the LEDManagementTask.
     * Therefore SSSCommand cannot be placed on the stack of the
     * SSSSimpleSocketServerTask, since the LEDManagementTask does not
     * have access to the stack of the SSSSimpleSocketServerTask.
     */
    static INT32U SSSCommand;

    INT8U send_data = 0;

    // Command parser
    char cmd;
    char reg[2];
    int data0, data1, data2, data3, data4;
    int captured = 0;
    int _captured = 0;

    //printf("(%i) %s", strlen(conn->rx_rd_pos), conn->rx_rd_pos);
    sscanf(conn->rx_rd_pos, "%c,%c%c,%i,%i,%i,%i,%i", &cmd, &reg[0], &reg[1],
    	   &data0, &data1, &data2, &data3, &data4);

	bytes_to_process--;
    SSSCommand = toupper(*(conn->rx_rd_pos++));
    while (bytes_to_process--) {
    	*(conn->rx_rd_pos++);
    }

    switch(SSSCommand) {
		case CMD_READ:
			/* Reads camera image registers */
			if (reg[0] == 'i' && reg[1] == 's') { // image size (width, height)
				tx_wr_pos += get_image_size(&camera, tx_wr_pos);
			}
			else if (reg[0] == 'i' && reg[1] == 'e') { // image exposure (exposure)
				tx_wr_pos += get_image_exposure(&camera, tx_wr_pos);
			}
			else if (reg[0] == 's' && reg[1] == 'i') { // start image (start_column, start_row)
				tx_wr_pos += get_start_image(&camera, tx_wr_pos);
			}
			else if (reg[0] == 's' && reg[1] == 's') { // sensor size (column_size, row_size)
				tx_wr_pos += get_sensor_size(&camera, tx_wr_pos);
			}
			else if (reg[0] == 's' && reg[1] == 'm') { // sensor mode (column_mode, row_mode)
				tx_wr_pos += get_sensor_mode(&camera, tx_wr_pos);
			}
			/* Reads thresholds (min, max) */
			else if (reg[0] == 'r' && reg[1] == 't') {
				data0 = IORD_SENSOR_RED_THRESHOLD_MIN(SENSOR_BASE);
				data1 = IORD_SENSOR_RED_THRESHOLD_MAX(SENSOR_BASE);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			else if (reg[0] == 'g' && reg[1] == 't') {
				data0 = IORD_SENSOR_GREEN_THRESHOLD_MIN(SENSOR_BASE);
				data1 = IORD_SENSOR_GREEN_THRESHOLD_MAX(SENSOR_BASE);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			else if (reg[0] == 'b' && reg[1] == 't') {
				data0 = IORD_SENSOR_BLUE_THRESHOLD_MIN(SENSOR_BASE);
				data1 = IORD_SENSOR_BLUE_THRESHOLD_MAX(SENSOR_BASE);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			/* Reads the number of tracker resources */
			else if (reg[0] == 't' && reg[1] == 'r') {
				tx_wr_pos += sprintf(tx_wr_pos, "%i", trackers_number());
			}
			/* Reads the search window of the assigned tracker (left, top, right, bottom) */
			else if (reg[0] == 's' && reg[1] == 'w') {
				tx_wr_pos += get_search_window_of_tracker(data0, tx_wr_pos);
			}
			/* Reads the corners locations of the assigned tracker ((x0, y0),...,(x7,y7)) */
			else if (reg[0] == 'c' && reg[1] == 'l') {
				while (!IORD_CAMERA_CAPTURE_DONE(CAMERA_BASE)) OSTimeDly(1);
				tx_wr_pos += get_current_corners_of_tracker(data0, tx_wr_pos);
			}
			/* Reads all search windows of activated trackers */
			else if (reg[0] == 'a' && reg[1] == 'w') {
				//while (!IORD_CAMERA_CAPTURE_DONE(CAMERA_BASE));
				// Reads all search windows
				tx_wr_pos += get_current_windows_of_activated_trackers(tx_wr_pos);
			}
			/* Reads all corners locations and captures a new frame */
			else if (reg[0] == 'a' && reg[1] == 'l') {
				while (!IORD_CAMERA_CAPTURE_DONE(CAMERA_BASE)) OSTimeDly(1);
				// Captures a new frame
				IOWR_CAMERA_CAPTURE_START(CAMERA_BASE);
				IOWR_CAMERA_CAPTURE_STOP(CAMERA_BASE);
				// Reads all corners locations
				tx_wr_pos += get_current_corners_of_activated_trackers(tx_wr_pos);
			}
			else {
				tx_wr_pos += sprintf(tx_wr_pos, "Wrong command!");
			}
			tx_wr_pos += sprintf(tx_wr_pos, "\n");
			break;
		case CMD_WRITE:
			/* Writes camera image registers */
			if (reg[0] == 'i' && reg[1] == 's') { // image size (width, height)
				tx_wr_pos += set_image_size(&camera, tx_wr_pos, data0, data1);
			}
			else if (reg[0] == 'i' && reg[1] == 'e') { // image exposure (exposure)
				tx_wr_pos += set_image_exposure(&camera, tx_wr_pos, data0);
			}
			else if (reg[0] == 's' && reg[1] == 'i') { // start image (start_column, start_row)
				tx_wr_pos += set_start_image(&camera, tx_wr_pos, data0, data1);
			}
			else if (reg[0] == 's' && reg[1] == 's'){ // sensor size (column_size, row_size)
				tx_wr_pos += set_sensor_size(&camera, tx_wr_pos, data0, data1);
			}
			else if (reg[0] == 's' && reg[1] == 'm'){ // sensor mode (column_mode, row_mode)
				tx_wr_pos += set_sensor_mode(&camera, tx_wr_pos, data0, data1);
			}
			/* Writes the selected sensor output */
			else if (reg[0] == 's' && reg[1] == 'o') { //  select output
				tx_wr_pos += select_sensor_output(&camera, tx_wr_pos, data0);
			}
			// TODO: Group sensor configuration functions
			/* Writes thresholds (min, max) */
			else if (reg[0] == 'r' && reg[1] == 't'){
				IOWR_SENSOR_RED_THRESHOLD_MIN(SENSOR_BASE, data0);
				IOWR_SENSOR_RED_THRESHOLD_MAX(SENSOR_BASE, data1);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			else if (reg[0] == 'g' && reg[1] == 't'){
				IOWR_SENSOR_GREEN_THRESHOLD_MIN(SENSOR_BASE, data0);
				IOWR_SENSOR_GREEN_THRESHOLD_MAX(SENSOR_BASE, data1);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			else if (reg[0] == 'b' && reg[1] == 't'){
				IOWR_SENSOR_BLUE_THRESHOLD_MIN(SENSOR_BASE, data0);
				IOWR_SENSOR_BLUE_THRESHOLD_MAX(SENSOR_BASE, data1);
				tx_wr_pos += sprintf(tx_wr_pos, "(%i,%i)", data0, data1);
			}
			/* Frees all tracker devices */
			else if (reg[0] == 'f' && reg[1] == 'a') {
				tx_wr_pos += trackers_free(tx_wr_pos);
			}
			/* Activates a tracker device. */
			else if (reg[0] == 'a' && reg[1] == 't') {
				tx_wr_pos += activate_tracker(data0, tx_wr_pos);
			}
			/* Disables a tracker device. */
			else if (reg[0] == 'd' && reg[1] == 't') {
				tx_wr_pos += disable_tracker(data0, tx_wr_pos);
			}
			/* Frees a tracker device. */
			else if (reg[0] == 'f' && reg[1] == 't') {
				tx_wr_pos += free_tracker(data0, tx_wr_pos);
			}
			/* Sets a search window for the assigned tracker device (x, y, width, height) */
			else if (reg[0] == 's' && reg[1] == 'w') {
				tx_wr_pos += set_search_window_of_tracker(data0, tx_wr_pos, data1, data2, data3, data4);
			}
			else {
				tx_wr_pos += sprintf(tx_wr_pos, "Wrong command!");
			}
			tx_wr_pos += sprintf(tx_wr_pos, "\n");
			break;
		case CMD_CONFIGURE: // Reconfigures the camera sensor
			tx_wr_pos += camera_configure(&camera, tx_wr_pos);
			tx_wr_pos += sprintf(tx_wr_pos, "\n");
			break;
		case CMD_CAPTURE: // Captures the image data (Start/Stop)
			printf("Capturing image...\n");
			IOWR_CAMERA_CAPTURE_START(CAMERA_BASE);
			IOWR_CAMERA_CAPTURE_STOP(CAMERA_BASE);
			//OSTimeDly(1);
			printf("Image captured\n");
			tx_wr_pos += sprintf(tx_wr_pos, "Image captured.\n");
			break;
		case CMD_DATA:
			// Send image data
			send_data = 1;
			printf("RGB image data sending...\n");
			tx_wr_pos = tx_buf;
			break;
		case CMD_GRAY:
			// Send gray image data
			send_data = 2;
			printf("Gray image data sending...\n");
			tx_wr_pos = tx_buf;
			break;
		case CMD_VGA: // Selects the VGA output
			tx_wr_pos += select_vga_output(&camera, tx_wr_pos);
			tx_wr_pos += sprintf(tx_wr_pos, "\n");
			break;
		default:
			if(SSSCommand >= ' ' && SSSCommand <= '~') {
					tx_wr_pos += sprintf(tx_wr_pos,
							"--> Simple Socket Server Command %c.\n",
							(char)SSSCommand);
			}
			if (SSSCommand == CMD_QUIT) {
					tx_wr_pos += sprintf(tx_wr_pos, "Terminating connection.\n\n\r");
					conn->close = 1;
			}
			else {
					alt_SSSErrorHandler(error_code, 0);
			}
			break;
    }

	// Send image data
    if (send_data) {
    	// Waits to end of capture
		while (!IORD_CAMERA_CAPTURE_DONE(CAMERA_BASE)) OSTimeDly(1);

    	alt_u32 data;
		alt_u8  r, g, b;

		int WIDTH = IORD_CAMERA_WIDTH(CAMERA_BASE);
		int HEIGHT = IORD_CAMERA_HEIGHT(CAMERA_BASE);

		//typedef struct{
		//	alt_u8 b;
		//	alt_u8 g;
		//	alt_u8 r;
		//} volatile color;

		//color *col = (color *)(&data);
		if (send_data == 1) {
			// Send RGB image

			int S = (WIDTH / 600) + 1;
			int Y = HEIGHT * S;
			int X = WIDTH / S;

			register int i;
			register int j;
			for(j = 0; j < Y; j++) {
				for(i = 0; i < X; i++) {
					data = IORD_CAMERA_READ_DATA(CAMERA_BASE);
					r = data >> 16;
					g = data >> 8;
					b = data;
					//tx_wr_pos += sprintf(tx_wr_pos, "%c%c%c", col->r, col->g, col->b);
					tx_wr_pos += sprintf(tx_wr_pos, "%c%c%c", (char) r, (char) g, (char) b);
				}
				send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
				tx_wr_pos = tx_buf;
				OSTimeDly(1);
			}
		}
		else if (send_data == 2) {
			// Send gray image
			register int i;
			register int j;
			for(j = 0; j < HEIGHT; j++) {
				for(i = 0; i < WIDTH; i++) {
					data = IORD_CAMERA_READ_DATA(CAMERA_BASE);
					g = data >> 24;
					tx_wr_pos += sprintf(tx_wr_pos, "%c", (char) g);
				}
				send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
				tx_wr_pos = tx_buf;
				OSTimeDly(1);
			}
		}
		send_data = 0;
    }
    else {
        // Send buffer
        send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);
        tx_wr_pos = tx_buf;
    }
}

/*
 * sss_handle_accept()
 *
 * This routine is called when ever our listening socket has an incoming
 * connection request.
 *
 * We look at it to see whether its in use... if so, we accept the
 * connection request and call the telent_send_menu() routine to transmit
 * instructions to the user, and print out the client's IP address. Otherwise,
 * the connection is already in use, reject the incoming request by
 * immediately closing the new socket.
 */
void sss_handle_accept(int listen_socket, SSSConn* conn) {
	int	socket, len;
	struct sockaddr_in  incoming_addr;

	len = sizeof(incoming_addr);

	if ((conn)->fd == -1) {
		if((socket=accept(listen_socket, (struct sockaddr*) &incoming_addr, &len)) <0) {
			alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
					"[sss_handle_accept] accept failed");
		}
		else {
			(conn)->fd = socket;
			sss_send_menu(conn);
			printf("[sss_handle_accept] accepted connection request from %s\n",
					inet_ntoa(incoming_addr.sin_addr));
		}
	}
	else {
		printf("[sss_handle_accept] rejected connection request from %s\n",
				inet_ntoa(incoming_addr.sin_addr));
	}
}

/*
 * sss_handle_receive()
 * 
 * This routine is called whenever there is a sss connection established and
 * the socket associated with that connection has incoming data. We will first
 * look for a newline "\n" character to see if the user has entered something 
 * and pressed 'return'. If there is no newline in the buffer, we'll attempt
 * to receive data from the listening socket until there is.
 * 
 * The connection will remain open until the user enters "Q\n" or "q\n", as
 * determined by repeatedly calling recv(), and once a newline is found,
 * calling sss_exec_command(), which will determine whether the quit 
 * command was received.
 * 
 * Finally, each time we receive data we must manage our receive-side buffer.
 * New data is received from the sss socket onto the head of the buffer,
 * and popped off from the beginning of the buffer with the 
 * sss_exec_command() routine. Aside from these, we must move incoming
 * (un-processed) data to buffer start as appropriate and keep track of 
 * associated pointers.
 */
void sss_handle_receive(SSSConn* conn) {
	int data_used = 0, rx_code = 0;
	INT8U *lf_addr;

	conn->rx_rd_pos = conn->rx_buffer;
	conn->rx_wr_pos = conn->rx_buffer;

	printf("[sss_handle_receive] processing RX data\n");

	while(conn->state != CLOSE) {
		/* Find the Carriage return which marks the end of the header
		 * and go do whatever the user wanted us to do.
		 * Or, if no newline received, then ask the socket for data.
		 */
		lf_addr = strchr(conn->rx_buffer, '\n');

		if(lf_addr) {
			sss_exec_command(conn);
		}
		else {
			rx_code = recv(conn->fd, conn->rx_wr_pos,
					SSS_RX_BUF_SIZE - (conn->rx_wr_pos - conn->rx_buffer) - 1, 0);

			if(rx_code > 0) {
				conn->rx_wr_pos += rx_code;

				/* Zero terminate so we can use string functions */
				*(conn->rx_wr_pos + 1) = 0;
			}
		}

		/*
		 * When the quit command is received, update our connection state so that
		 * we can exit the while() loop and close the connection
		 */
		conn->state = conn->close ? CLOSE : READY;

		/* Manage buffer */
		data_used = conn->rx_rd_pos - conn->rx_buffer;
		memmove(conn->rx_buffer, conn->rx_rd_pos,
				conn->rx_wr_pos - conn->rx_rd_pos);
		conn->rx_rd_pos = conn->rx_buffer;
		conn->rx_wr_pos -= data_used;
		memset(conn->rx_wr_pos, 0, data_used);
	}

	printf("[sss_handle_receive] closing connection\n");
	close(conn->fd);
	sss_reset_connection(conn);
}

/*
 * SSSSimpleSocketServerTask()
 * 
 * This MicroC/OS-II thread spins forever after first establishing a listening
 * socket for our sss connection, binding it, and listening. Once setup,
 * it perpetually waits for incoming data to either the listening socket, or
 * (if a connection is active), the sss data socket. When data arrives, 
 * the approrpriate routine is called to either accept/reject a connection 
 * request, or process incoming data.
 */
void SSSSimpleSocketServerTask() {
	int fd_listen, max_socket;
	struct sockaddr_in addr;
	static SSSConn conn;
	fd_set readfds;

	/*
	 * Sockets primer...
	 * The socket() call creates an end point for TCP of UDP communication. It
	 * returns a descriptor (similar to a file descriptor) that we call fd_listen,
	 * or, "the socket we're listening on for connection requests" in our sss
	 * server example.
	 *
	 * Calling bind() associates a socket created with socket() to a particular IP
	 * port and incoming address. In this case we're binding to SSS_PORT and to
	 * INADDR_ANY address (allowing anyone to connect to us. Bind may fail for
	 * various reasons, but the most common is that some other socket is bound to
	 * the port we're requesting.
	 *
	 * The listen socket is a socket which is waiting for incoming connections.
	 * This call to listen will block (i.e. not return) until someone tries to
	 * connect to this port.
	 */
	if ((fd_listen = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE, "[sss_task] Socket creation failed");
	}

	addr.sin_family = AF_INET;
	addr.sin_port = htons(SSS_PORT);
	addr.sin_addr.s_addr = INADDR_ANY;
  
	if ((bind(fd_listen, (struct sockaddr *) & addr, sizeof(addr))) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE, "[sss_task] Bind failed");
	}

	if ((listen(fd_listen, 1)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE, "[sss_task] Listen failed");
	}

	/* At this point we have successfully created a socket which is listening
	 * on SSS_PORT for connection requests from any remote address.
	 */
	sss_reset_connection(&conn);
	printf("[sss_task] Simple Socket Server listening on port %d\n", SSS_PORT);
   
	/* Main server loop to handle TCP */
	while(1) {
		/*
		 * For those not familiar with sockets programming...
		 * The select() call below basically tells the TCPIP stack to return
		 * from this call when any of the events I have expressed an interest
		 * in happen (it blocks until our call to select() is satisfied).
		 *
		 * In the call below we're only interested in either someone trying to
		 * connect to us, or data being available to read on a socket, both of
		 * these are a read event as far as select is called.
		 *
		 * Hence there are standard MACROs for setting/reading the values:
		 *
		 *   FD_ZERO  - Zero's out the sockets we're interested in
		 *   FD_SET   - Adds a socket to those we're interested in
		 *   FD_ISSET - Tests whether the chosen socket is set
		 */
		FD_ZERO(&readfds);
		FD_SET(fd_listen, &readfds);
		max_socket = fd_listen + 1;

		if (conn.fd != -1) {
			FD_SET(conn.fd, &readfds);
			if (max_socket <= conn.fd) {
				max_socket = conn.fd + 1;
			}
		}

		select(max_socket, &readfds, NULL, NULL, NULL);

		/*
		 * If fd_listen (the listening socket we originally created in this thread
		 * is "set" in readfs, then we have an incoming connection request. We'll
		 * call a routine to explicitly accept or deny the incoming connection
		 * request (in this example, we accept a single connection and reject any
		 * others that come in while the connection is open).
		 *
		 * If sss_handle_accept() accepts the connection, it creates *another*
		 * socket for sending/receiving data over sss. Note that this socket is
		 * independent of the listening socket we created above. This socket's
		 * descriptor is stored in conn.fd. If conn.fs is set in readfs... we have
		 * incoming data for our sss server, and we call our receiver routine
		 * to process it.
		 */
		if (FD_ISSET(fd_listen, &readfds)) {
			sss_handle_accept(fd_listen, &conn);
		}
		else {
			if ((conn.fd != -1) && FD_ISSET(conn.fd, &readfds)) {
				sss_handle_receive(&conn);
			}
		}
	}
}

