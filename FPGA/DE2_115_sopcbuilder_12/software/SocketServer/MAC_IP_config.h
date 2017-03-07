#ifndef __MAC_IP_CONFIG__
#define __MAC_IP_CONFIG__

//----------MAC-------------//
//If FIXED_MAC is defined the default MAC in this file is used
//Otherwise the system reads the MAC from Flash Memory.
//If there is no MAC stored in the flash the board asks
//through console the serial number of the board, generates
//an unique MAC address in the world for that board and saves
//it in the flash.
#define FIXED_MAC
//default_MAC (DEFAULT_MAC_0:DEFAULT_MAC_1:...:DEFAULT_MAC_5)
#define DEFAULT_MAC_0  0x00
#define DEFAULT_MAC_1  0x07
#define DEFAULT_MAC_2  0xED
#define DEFAULT_MAC_3  0xFF
#define DEFAULT_MAC_4  0x6B
#define DEFAULT_MAC_5  0xC7

//----------IP-------------//
//If FIXED_IP is defined the boards starts with the default
//IP, mask and gateaway described in this file. If FIXED_IP
//is not defined the board tries to obtain an IP using DHCP.
//If DHCP fails (after 2 minutes aprox.) the board configures
//the default IP.
//#define FIXED_IP
//default IP (DEFAULT_IP_0.DEFAULT_IP_1.DEFAULT_IP_2.DEFAULT_IP_3)
#define DEFAULT_IP_0  172
#define DEFAULT_IP_1  19
#define DEFAULT_IP_2  5
#define DEFAULT_IP_3  213

#define DEFAULT_GATEWAY_0  172
#define DEFAULT_GATEWAY_1  19
#define DEFAULT_GATEWAY_2  5
#define DEFAULT_GATEWAY_3  1

#define DEFAULT_MASK_0  255
#define DEFAULT_MASK_1  255
#define DEFAULT_MASK_2  255
#define DEFAULT_MASK_3  0

#endif /*__MAC_IP_CONFIG__ */
