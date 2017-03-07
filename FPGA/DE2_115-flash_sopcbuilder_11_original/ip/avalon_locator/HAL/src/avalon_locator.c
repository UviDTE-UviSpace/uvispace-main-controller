#include <stdio.h>

#include "avalon_locator.h"

void locator_init(LOCATOR *sp, void *base)
{
	sp->base = base;
	sp->id = 0;
	sp->active = 0;
}

/* Gets the current corners list of the identified peripheral. */
int get_current_corners(LOCATOR *sp, char *char_buffer)
{
	int nchars = 0;

	if (sp->active) {
		nchars = sprintf(char_buffer,
		     	         "((%i,%i),(%i,%i),(%i,%i),(%i,%i),(%i,%i),(%i,%i),(%i,%i),(%i,%i))",
		     	         IORD_LOCATION_P1_X(sp->base), IORD_LOCATION_P1_Y(sp->base),
		     	         IORD_LOCATION_P2_X(sp->base), IORD_LOCATION_P2_Y(sp->base),
		     	         IORD_LOCATION_P3_X(sp->base), IORD_LOCATION_P3_Y(sp->base),
		     	         IORD_LOCATION_P4_X(sp->base), IORD_LOCATION_P4_Y(sp->base),
		     	         IORD_LOCATION_P5_X(sp->base), IORD_LOCATION_P5_Y(sp->base),
		     	         IORD_LOCATION_P6_X(sp->base), IORD_LOCATION_P6_Y(sp->base),
		     	         IORD_LOCATION_P7_X(sp->base), IORD_LOCATION_P7_Y(sp->base),
		     	         IORD_LOCATION_P8_X(sp->base), IORD_LOCATION_P8_Y(sp->base));
	}
	else {
		nchars = sprintf(char_buffer, "()");
	}

	return nchars;
}

/* Sets the search window of the locator device. */
int set_search_window(LOCATOR *sp, char *char_buffer, int x, int y, int width, int height)
{
	IOWR_LOCATOR_X(sp->base, x);
	IOWR_LOCATOR_Y(sp->base, y);
	IOWR_LOCATOR_WIDTH(sp->base, width);
	IOWR_LOCATOR_HEIGHT(sp->base, height);
	IOWR_LOCATOR_SW(sp->base, 1);
	IOWR_LOCATOR_SW(sp->base, 0);
	IOWR_LOCATOR_ENABLE(sp->base);

	int nchars = 0;
	nchars = sprintf(char_buffer, "(%i,%i,%i,%i)", x, y, width, height);
	return nchars;
}

/* Gets the search window of the locator device. */
int get_search_window(LOCATOR *sp, char *char_buffer)
{
	int x = IORD_LOCATOR_X(sp->base);
	int y = IORD_LOCATOR_Y(sp->base);
	int width = IORD_LOCATOR_WIDTH(sp->base);
	int height = IORD_LOCATOR_HEIGHT(sp->base);

	int nchars = 0;
	nchars = sprintf(char_buffer, "((%i,%i),(%i,%i))", x, y, width, height);

	return nchars;
}
