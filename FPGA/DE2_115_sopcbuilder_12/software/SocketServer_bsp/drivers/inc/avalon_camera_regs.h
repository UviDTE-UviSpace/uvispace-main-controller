#ifndef __AVALON_CAMERA_REGS_H
#define __AVALON_CAMERA_REGS_H

#include <io.h> //Altera IOWR and IORD

// slave address
#define CAPTURE_START           0x00
#define CAPTURE_CONFIGURE       0x01
#define CAPTURE_SELECT_VGA      0x02
#define CAPTURE_SELECT_SENSOR   0x03
#define CAPTURE_DATA            0x04

#define IOWR_CAMERA_CAPTURE_START(base)                 IOWR(base, CAPTURE_START, 1)
#define IOWR_CAMERA_CAPTURE_STOP(base)                  IOWR(base, CAPTURE_START, 0)
#define IORD_CAMERA_CAPTURE_DONE(base)                  IORD(base, CAPTURE_START)
#define IOWR_CAMERA_CONFIGURE(base, dat)                IOWR(base, CAPTURE_CONFIGURE, dat)
#define IORD_CAMERA_READY(base)                         IORD(base, CAPTURE_CONFIGURE)
#define IOWR_CAMERA_CAPTURE_SELECT_VGA(base, dat)       IOWR(base, CAPTURE_SELECT_VGA, dat)
#define IOWR_CAMERA_CAPTURE_SELECT_SENSOR(base, dat)    IOWR(base, CAPTURE_SELECT_SENSOR, dat)
#define IORD_CAMERA_READ_DATA(base)                     IORD(base, CAPTURE_DATA)

// Registers address
#define ADDR_WIDTH          0x08
#define ADDR_HEIGHT         0x0a
#define ADDR_START_ROW      0x0c
#define ADDR_START_COLUMN	0x0e
#define ADDR_ROW_SIZE       0x10
#define ADDR_COLUMN_SIZE    0x12
#define ADDR_ROW_MODE       0x14
#define ADDR_COLUMN_MODE    0x16
#define ADDR_EXPOSURE       0x18

#define IORD_CAMERA_WIDTH(base)             IORD(base, ADDR_WIDTH)
#define IOWR_CAMERA_WIDTH(base, dat)        IOWR(base, ADDR_WIDTH, dat)
#define IORD_CAMERA_HEIGHT(base)            IORD(base, ADDR_HEIGHT)
#define IOWR_CAMERA_HEIGHT(base, dat)       IOWR(base, ADDR_HEIGHT, dat)

#define IORD_CAMERA_START_ROW(base)		    IORD(base, ADDR_START_ROW)
#define IOWR_CAMERA_START_ROW(base, dat)    IOWR(base, ADDR_START_ROW, dat)
#define IORD_CAMERA_START_COLUMN(base)      IORD(base, ADDR_START_COLUMN)
#define IOWR_CAMERA_START_COLUMN(base, dat)	IOWR(base, ADDR_START_COLUMN, dat)

#define IORD_CAMERA_ROW_SIZE(base)          IORD(base, ADDR_ROW_SIZE)
#define IOWR_CAMERA_ROW_SIZE(base, dat)     IOWR(base, ADDR_ROW_SIZE, dat)
#define IORD_CAMERA_COLUMN_SIZE(base)       IORD(base, ADDR_COLUMN_SIZE)
#define IOWR_CAMERA_COLUMN_SIZE(base, dat)  IOWR(base, ADDR_COLUMN_SIZE, dat)

#define IORD_CAMERA_ROW_MODE(base)          IORD(base, ADDR_ROW_MODE)
#define IOWR_CAMERA_ROW_MODE(base, dat)     IOWR(base, ADDR_ROW_MODE, dat)
#define IORD_CAMERA_COLUMN_MODE(base)       IORD(base, ADDR_COLUMN_MODE)
#define IOWR_CAMERA_COLUMN_MODE(base, dat)  IOWR(base, ADDR_COLUMN_MODE, dat)

#define IORD_CAMERA_EXPOSURE(base)          IORD(base, ADDR_EXPOSURE)
#define IOWR_CAMERA_EXPOSURE(base, dat)     IOWR(base, ADDR_EXPOSURE, dat)

#endif
