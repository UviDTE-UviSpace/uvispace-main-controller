#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: C:\Users\Jorge\workspace\VideoSensor\DE2_115-flash\DE2_115_WEB_SERVER.sof to: "..\flash/DE2_115_WEB_SERVER_ext_flash.flash"
#
bin/sof2flash --input="C:/Users/Jorge/workspace/VideoSensor/DE2_115-flash/DE2_115_WEB_SERVER.sof" --output="../flash/DE2_115_WEB_SERVER_ext_flash.flash" --offset=0x0 

#
# Programming File: "..\flash/DE2_115_WEB_SERVER_ext_flash.flash" To Device: ext_flash
#
bin/nios2-flash-programmer "../flash/DE2_115_WEB_SERVER_ext_flash.flash" --base=0x2800000 --sidp=0x1000640 --id=0x0 --timestamp=1344603788 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-1]' --program 

#
# Converting ELF File: C:\Users\Jorge\workspace\VideoSensor\DE2_115-flash\software\SocketServer\SocketServer.elf to: "..\flash/SocketServer_ext_flash.flash"
#
bin/elf2flash --input="C:/Users/Jorge/workspace/VideoSensor/DE2_115-flash/software/SocketServer/SocketServer.elf" --output="../flash/SocketServer_ext_flash.flash" --boot="components/altera_nios2/boot_loader_cfi.srec" --base=0x2800000 --end=0x3000000 --reset=0x2800000 

#
# Programming File: "..\flash/SocketServer_ext_flash.flash" To Device: ext_flash
#
bin/nios2-flash-programmer "../flash/SocketServer_ext_flash.flash" --base=0x2800000 --sidp=0x1000640 --id=0x0 --timestamp=1344603788 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-1]' --program 

