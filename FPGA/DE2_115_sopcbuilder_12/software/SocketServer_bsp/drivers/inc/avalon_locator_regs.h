#ifndef __AVALON_LOCATOR_REGS_H
#define __AVALON_LOCATOR_REGS_H

#include <io.h> //Altera IOWR and IORD

#define ADDR_CTRL      0x00

#define IOWR_LOCATOR_ENABLE(base)        IOWR(base, ADDR_CTRL, 1)
#define IOWR_LOCATOR_DISABLE(base)       IOWR(base, ADDR_CTRL, 0)

// Search window

#define ADDR_WRT       0x03
#define ADDR_X         0x04
#define ADDR_Y         0x06
#define ADDR_WIDTH     0x08
#define ADDR_HEIGHT    0x0a

#define IOWR_LOCATOR_SW(base, dat)        IOWR(base, ADDR_WRT, dat)
#define IORD_LOCATOR_X(base)              IORD(base, ADDR_X)
#define IOWR_LOCATOR_X(base, dat)         IOWR(base, ADDR_X, dat)
#define IORD_LOCATOR_Y(base)              IORD(base, ADDR_Y)
#define IOWR_LOCATOR_Y(base, dat)         IOWR(base, ADDR_Y, dat)
#define IORD_LOCATOR_WIDTH(base)          IORD(base, ADDR_WIDTH)
#define IOWR_LOCATOR_WIDTH(base, dat)     IOWR(base, ADDR_WIDTH, dat)
#define IORD_LOCATOR_HEIGHT(base)         IORD(base, ADDR_HEIGHT)
#define IOWR_LOCATOR_HEIGHT(base, dat)    IOWR(base, ADDR_HEIGHT, dat)

// Corners location

#define ADDR_LOCATION_P1_X      0x0c
#define ADDR_LOCATION_P1_Y      0x0e
#define ADDR_LOCATION_P2_X      0x10
#define ADDR_LOCATION_P2_Y      0x12
#define ADDR_LOCATION_P3_X      0x14
#define ADDR_LOCATION_P3_Y      0x16
#define ADDR_LOCATION_P4_X      0x18
#define ADDR_LOCATION_P4_Y      0x1a
#define ADDR_LOCATION_P5_X      0x1c
#define ADDR_LOCATION_P5_Y      0x1e
#define ADDR_LOCATION_P6_X      0x20
#define ADDR_LOCATION_P6_Y      0x22
#define ADDR_LOCATION_P7_X      0x24
#define ADDR_LOCATION_P7_Y      0x26
#define ADDR_LOCATION_P8_X      0x28
#define ADDR_LOCATION_P8_Y      0x2a

#define IORD_LOCATION_P1_X(base)      IORD(base, ADDR_LOCATION_P1_X)
#define IORD_LOCATION_P1_Y(base)      IORD(base, ADDR_LOCATION_P1_Y)
#define IORD_LOCATION_P2_X(base)      IORD(base, ADDR_LOCATION_P2_X)
#define IORD_LOCATION_P2_Y(base)      IORD(base, ADDR_LOCATION_P2_Y)
#define IORD_LOCATION_P3_X(base)      IORD(base, ADDR_LOCATION_P3_X)
#define IORD_LOCATION_P3_Y(base)      IORD(base, ADDR_LOCATION_P3_Y)
#define IORD_LOCATION_P4_X(base)      IORD(base, ADDR_LOCATION_P4_X)
#define IORD_LOCATION_P4_Y(base)      IORD(base, ADDR_LOCATION_P4_Y)
#define IORD_LOCATION_P5_X(base)      IORD(base, ADDR_LOCATION_P5_X)
#define IORD_LOCATION_P5_Y(base)      IORD(base, ADDR_LOCATION_P5_Y)
#define IORD_LOCATION_P6_X(base)      IORD(base, ADDR_LOCATION_P6_X)
#define IORD_LOCATION_P6_Y(base)      IORD(base, ADDR_LOCATION_P6_Y)
#define IORD_LOCATION_P7_X(base)      IORD(base, ADDR_LOCATION_P7_X)
#define IORD_LOCATION_P7_Y(base)      IORD(base, ADDR_LOCATION_P7_Y)
#define IORD_LOCATION_P8_X(base)      IORD(base, ADDR_LOCATION_P8_X)
#define IORD_LOCATION_P8_Y(base)      IORD(base, ADDR_LOCATION_P8_Y)

#endif
