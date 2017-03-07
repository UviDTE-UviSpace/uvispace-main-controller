/* 
 * Simple Socket Server (SSS) example. 
 * 
 * Please refer to the Altera Nichestack Tutorial documentation for details on this 
 * software example, as well as details on how to configure the TCP/IP 
 * networking stack and MicroC/OS-II Real-Time Operating System.  The Altera
 * Nichestack Tutorial, along with the rest of the Nios II documentation is published 
 * on the Altera web-site.  See: 
 * Start Menu -> Programs -> Nios II Development Kit -> Nios II Documentation.
 * In particular, chapter 9 of the Nios II Software Developer's Handbook 
 * describes Ethernet & Network stack.
 * 
 * Software Design Methodology Note:
 * 
 * The naming convention used in the Simple Socket Server Tutorial employs
 * capitalized software module references as prefixes to variables to identify
 * public resources for each software module, while lower-case 
 * variables with underscores indicate a private resource used strictly 
 * internally to a software module.
 * 
 * The software modules are named and have capitalized variable identifiers as
 * follows:
 * 
 * SSS      Simple Socket Server software module  
 * NETUTILS Network Utilities software module
 * 
 * OS       Micrium MicroC/OS-II Real-Time Operating System software component
 */
 
 /* Validate supported Software components specified on system library properties page.
  */
#ifndef __SIMPLE_SOCKET_SERVER_H__
#define __SIMPLE_SOCKET_SERVER_H__
#include "MAC_IP_config.h"

/*
 * Task Prototypes:
 * 
 *    SSSSimpleSocketServerTask() - Manages the socket server connection and 
 * calls relevant subroutines to manage the socket connection.
 * 
 */
void SSSSimpleSocketServerTask();

/*
 *  Task Priorities:
 * 
 *  MicroC/OS-II only allows one task (thread) per priority number.   
 */
#define SSS_SIMPLE_SOCKET_SERVER_TASK_PRIORITY  7

/* 
 * The IP, gateway, and subnet mask address below are used as a last resort
 * if no network settings can be found, and DHCP (if enabled) fails. You can
 * edit these as a quick-and-dirty way of changing network settings if desired.
 * 
 * Default IP addresses are set to all zeros so that DHCP server packets will
 * penetrate secure routers. They are NOT intended to be valid static IPs, 
 * these values are only a valid default on networks with DHCP server. 
 * 
 * If DHCP will not be used, select valid static IP addresses here, for example:
 *           IP: 192.168.1.234
 *      Gateway: 192.168.1.1
 *  Subnet Mask: 255.255.255.0
 */
/*
// NCSU
#define IPADDR0   152
#define IPADDR1   14
#define IPADDR2   97
#define IPADDR3   5

#define GWADDR0   152
#define GWADDR1   14
#define GWADDR2   96
#define GWADDR3   1

#define MSKADDR0  255
#define MSKADDR1  255
#define MSKADDR2  254
#define MSKADDR3  0
*/
/*
// VIGO
#define IPADDR0   172
#define IPADDR1   19
#define IPADDR2   5
#define IPADDR3   213

#define GWADDR0   172
#define GWADDR1   19
#define GWADDR2   5
#define GWADDR3   1

#define MSKADDR0  255
#define MSKADDR1  255
#define MSKADDR2  255
#define MSKADDR3  0
*/

#define IPADDR0   DEFAULT_IP_0
#define IPADDR1   DEFAULT_IP_1
#define IPADDR2   DEFAULT_IP_2
#define IPADDR3   DEFAULT_IP_3

#define GWADDR0   DEFAULT_GATEWAY_0
#define GWADDR1   DEFAULT_GATEWAY_1
#define GWADDR2   DEFAULT_GATEWAY_2
#define GWADDR3   DEFAULT_GATEWAY_3

#define MSKADDR0  DEFAULT_MASK_0
#define MSKADDR1  DEFAULT_MASK_1
#define MSKADDR2  DEFAULT_MASK_2
#define MSKADDR3  DEFAULT_MASK_3

/*
 * IP Port(s) for our application(s)
 */
#define SSS_PORT 5005

/* Definition of Task Stack size for tasks not using Nichestack */
#define   TASK_STACKSIZE       2048

/* 
 * Defined commands for the sss server to interpret
 */
#define CMD_READ                'R'
#define CMD_WRITE               'W'

#define CMD_CONFIGURE           'C'
#define CMD_CAPTURE             'S'
#define CMD_DATA                'D'
#define CMD_GRAY                'G'
#define CMD_VGA                 'V'

#define CMD_QUIT                'Q'
  
/* 
 * TX & RX buffer sizes for all socket sends & receives in our sss app
 */
#define SSS_RX_BUF_SIZE  2048
#define SSS_TX_BUF_SIZE  2048

/* 
 * Here we structure to manage sss communication for a single connection
 */
typedef struct SSS_SOCKET {
  enum { READY, COMPLETE, CLOSE } state; 
  int       fd;
  int       close;
  INT8U     rx_buffer[SSS_RX_BUF_SIZE];
  INT8U     *rx_rd_pos; /* position we've read up to */
  INT8U     *rx_wr_pos; /* position we've written up to */
} SSSConn;

#endif
