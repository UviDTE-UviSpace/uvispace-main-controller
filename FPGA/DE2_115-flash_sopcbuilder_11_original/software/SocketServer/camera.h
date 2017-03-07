#ifndef __CAMERA_H__
#define __CAMERA_H__

#include "avalon_camera_regs.h"

typedef struct camera_struct
{
	void* base; // The base address of the device

	int width, height; // Image size
	int exposure; // Image exposure
	int start_column, start_row; // Start of active image
	int column_size, row_size; // Size of active image
	int column_mode, row_mode; // Skip mode of active image
} CAMERA;

extern CAMERA camera;

void camera_init();

void read_camera_registers(CAMERA *sp);

void write_camera_registers(CAMERA *sp);

int get_image_size(CAMERA *sp, char *char_buffer);

int set_image_size(CAMERA *sp, char *char_buffer, int width, int height);

int get_image_exposure(CAMERA *sp, char *char_buffer);

int set_image_exposure(CAMERA *sp, char *char_buffer, int exposure);

int get_start_image(CAMERA *sp, char *char_buffer);

int set_start_image(CAMERA *sp, char *char_buffer, int start_column, int start_row);

int get_sensor_size(CAMERA *sp, char *char_buffer);

int set_sensor_size(CAMERA *sp, char *char_buffer, int column_size, int row_size);

int get_sensor_mode(CAMERA *sp, char *char_buffer);

int set_sensor_mode(CAMERA *sp, char *char_buffer, int column_mode, int row_mode);

int camera_configure(CAMERA *sp, char *char_buffer);

int select_sensor_output(CAMERA *sp, char *char_buffer, int output);

int select_vga_output(CAMERA *sp, char *char_buffer);

#endif
