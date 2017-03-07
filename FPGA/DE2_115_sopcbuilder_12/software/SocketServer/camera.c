/*
 * Camera control functions
 */

#include "system.h"
#include "camera.h"

// Creates the camera handler device
CAMERA camera = {CAMERA_BASE};

void camera_init()
{
	IOWR_CAMERA_CONFIGURE(camera.base, 1); // Initialization
	while (!IORD_CAMERA_READY(camera.base));
	read_camera_registers(&camera);
}

/* Reads values of camera registers. */
void read_camera_registers(CAMERA *sp)
{
	sp->width = IORD_CAMERA_WIDTH(sp->base);
	sp->height = IORD_CAMERA_HEIGHT(sp->base);
	sp->exposure = IORD_CAMERA_EXPOSURE(sp->base);
	sp->start_column = IORD_CAMERA_START_COLUMN(sp->base);
	sp->start_row = IORD_CAMERA_START_ROW(sp->base);
	sp->column_size = IORD_CAMERA_COLUMN_SIZE(sp->base);
	sp->row_size = IORD_CAMERA_ROW_SIZE(sp->base);
	sp->column_mode = IORD_CAMERA_COLUMN_MODE(sp->base);
	sp->row_mode = IORD_CAMERA_ROW_MODE(sp->base);
}

/* Writes values of camera registers. */
void write_camera_registers(CAMERA *sp)
{
	IOWR_CAMERA_WIDTH(sp->base, sp->width);
	IOWR_CAMERA_HEIGHT(sp->base, sp->height);
	IOWR_CAMERA_EXPOSURE(sp->base, sp->exposure);
	IOWR_CAMERA_START_COLUMN(sp->base, sp->start_column);
	IOWR_CAMERA_START_ROW(sp->base, sp->start_row);
	IOWR_CAMERA_COLUMN_SIZE(sp->base, sp->column_size);
	IOWR_CAMERA_ROW_SIZE(sp->base, sp->row_size);
	IOWR_CAMERA_COLUMN_MODE(sp->base, sp->column_mode);
	IOWR_CAMERA_ROW_MODE(sp->base, sp->row_mode);
}

int get_image_size(CAMERA *sp, char *char_buffer)
{
	int nchars = 0;
	nchars = sprintf(char_buffer, "(%i,%i)", sp->width, sp->height);
	return nchars;
}

int set_image_size(CAMERA *sp, char *char_buffer, int width, int height)
{
	sp->width = width;
	sp->height = height;
	return get_image_size(sp, char_buffer);
}

int get_image_exposure(CAMERA *sp, char *char_buffer)
{
	int nchars = 0;
	nchars = sprintf(char_buffer, "%i", sp->exposure);
	return nchars;
}

int set_image_exposure(CAMERA *sp, char *char_buffer, int exposure)
{
	sp->exposure = exposure;
	return get_image_exposure(sp, char_buffer);
}

int get_start_image(CAMERA *sp, char *char_buffer)
{
	int nchars = 0;
	nchars = sprintf(char_buffer, "(%i,%i)", sp->start_column, sp->start_row);
	return nchars;
}

int set_start_image(CAMERA *sp, char *char_buffer, int start_column, int start_row)
{
	sp->start_column = start_column;
	sp->start_row = start_row;
	return get_start_image(sp, char_buffer);
}

int get_sensor_size(CAMERA *sp, char *char_buffer)
{
	int nchars = 0;
	nchars = sprintf(char_buffer, "(%i,%i)", sp->column_size, sp->row_size);
	return nchars;
}

int set_sensor_size(CAMERA *sp, char *char_buffer, int column_size, int row_size)
{
	sp->column_size = column_size;
	sp->row_size = row_size;
	return get_sensor_size(sp, char_buffer);
}

int get_sensor_mode(CAMERA *sp, char *char_buffer)
{
	int nchars = 0;
	nchars = sprintf(char_buffer, "(%i,%i)", sp->column_mode, sp->row_mode);
	return nchars;
}

int set_sensor_mode(CAMERA *sp, char *char_buffer, int column_mode, int row_mode)
{
	sp->column_mode = column_mode;
	sp->row_mode = row_mode;
	return get_sensor_mode(sp, char_buffer);
}

/* Configures the camera sensor. */
int camera_configure(CAMERA *sp, char *char_buffer)
{
	printf("Configuring camera sensor...\n");
	write_camera_registers(sp);
	IOWR_CAMERA_CONFIGURE(sp->base, 0);
	IOWR_CAMERA_CONFIGURE(sp->base, 1);
	while (!IORD_CAMERA_READY(sp->base));
	printf("Camera sensor configured.\n");

	int nchars = 0;
	nchars = sprintf(char_buffer, "Camera sensor configured.");
	return nchars;
}

/* Selects the sensor output. */
int select_sensor_output(CAMERA *sp, char *char_buffer, int output)
{
	int nchars = 0;
	if ((output < 7) && (output != 3)) {
		IOWR_CAMERA_CAPTURE_SELECT_SENSOR(sp->base, output);
		nchars = sprintf(char_buffer, "%i", output);
	}
	else {
		nchars = sprintf(char_buffer, "Wrong sensor output.");
	}
	return nchars;
}

/* Selects the vga output. */
int select_vga_output(CAMERA *sp, char *char_buffer)
{
	static int vga = 0;

	printf("Configuring VGA...\n");
	vga = ~vga;
	IOWR_CAMERA_CAPTURE_SELECT_VGA(sp->base, vga);
	IOWR_CAMERA_CONFIGURE(sp->base, 0);
	IOWR_CAMERA_CONFIGURE(sp->base, 1);
	while (!IORD_CAMERA_READY(sp->base));
	if (vga) IOWR_CAMERA_CAPTURE_START(sp->base);
	else IOWR_CAMERA_CAPTURE_STOP(sp->base);
	printf("VGA output configured.\n");

	int nchars = 0;
	nchars = sprintf(char_buffer, "VGA output configured.");
	return nchars;
}
