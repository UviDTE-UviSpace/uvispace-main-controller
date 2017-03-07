#ifndef __AVALON_LOCATOR_H__
#define __AVALON_LOCATOR_H__

#include "avalon_locator_regs.h"

typedef struct locator_struct
{
	void* base; // The base address of the device

	int id; // Identification of the robot
	int active; // Status of the locator block
} LOCATOR;

void locator_init(LOCATOR *sp, void *base);

int get_current_corners(LOCATOR *sp, char *char_buffer);

int set_search_window(LOCATOR *sp, char *char_buffer, int x, int y, int width, int height);

int get_search_window(LOCATOR *sp, char *char_buffer);

#endif
