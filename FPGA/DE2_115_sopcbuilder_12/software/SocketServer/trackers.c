/*
 * Trackers control functions
 */

#include "system.h"
#include "trackers.h"

// Creates the trackers handlers devices
LOCATOR trackers[TRACKERS];

/* Initializes the trackers handlers. */
void trackers_init()
{
	locator_init(&trackers[0], TRACKER(0));
	locator_init(&trackers[1], TRACKER(1));
	locator_init(&trackers[2], TRACKER(2));
	locator_init(&trackers[3], TRACKER(3));
	locator_init(&trackers[4], TRACKER(4));
	locator_init(&trackers[4], TRACKER(5));
}

/* Gets the number of the tracker resources. */
int trackers_number()
{
	return TRACKERS;
}

/* Frees all tracker handlers. */
int trackers_free(char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		trackers[i].active = 0;
		trackers[i].id = 0;
	}
	return sprintf(char_buffer, "All trackers freed.");
}

/* Activates a tracker device. */
int activate_tracker(int id, char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			trackers[i].active = 1;
			return sprintf(char_buffer, "Id %i activated.", id);
		}
	}
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == 0) {
			trackers[i].id = id;
			trackers[i].active = 1;
			return sprintf(char_buffer, "Id %i activated.", id);
		}
	}
	return sprintf(char_buffer, "Id %i not assigned", id);
}

/* Disables a tracker device. */
int disable_tracker(int id, char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			trackers[i].active = 0;
			return sprintf(char_buffer, "Id %i disabled.", id);
		}
	}
	return sprintf(char_buffer, "Id %i not found.", id);
}

/* Frees a tracker device. */
int free_tracker(int id, char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			trackers[i].active = 0;
			trackers[i].id = 0;
			return sprintf(char_buffer, "Id %i free.", id);
		}
	}
	return sprintf(char_buffer, "Id %i not found.", id);
}

/* Sets the search window of the assigned tracker device. */
int set_search_window_of_tracker(int id, char *char_buffer, int x, int y, int width, int height)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			trackers[i].active = 1;
			return set_search_window(&trackers[i], char_buffer, x, y, width, height);
		}
	}
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == 0) {
			trackers[i].id = id;
			trackers[i].active = 1;
			return set_search_window(&trackers[i], char_buffer, x, y, width, height);
		}
	}
	return sprintf(char_buffer, "Id %i not assigned.", id);
}

/* Gets the search window of the assigned tracker device. */
int get_search_window_of_tracker(int id, char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			return get_search_window(&trackers[i], char_buffer);
		}
	}
	return sprintf(char_buffer, "Id %i not found.", id);
}

/* Gets the corners locations of the assigned tracker device. */
int get_current_corners_of_tracker(int id, char *char_buffer)
{
	int i;
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].id == id) {
			return get_current_corners(&trackers[i], char_buffer);
		}
	}
	return sprintf(char_buffer, "Id %i not found.", id);
}

/* Gets the search windows of all activated tracker devices. */
int get_current_windows_of_activated_trackers(char *char_buffer)
{
	int i;
	int nchars = 0;

	nchars += sprintf(char_buffer, "{");
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].active == 1) {
			nchars += sprintf(char_buffer + nchars, "'%i':", trackers[i].id);
			nchars += get_search_window(&trackers[i], char_buffer + nchars);
			nchars += sprintf(char_buffer + nchars, ",");
		}
	}
	if (nchars > 1) nchars--;
	nchars += sprintf(char_buffer + nchars, "}");

	return nchars;
}

/* Gets the corners locations of all activated tracker devices. */
int get_current_corners_of_activated_trackers(char *char_buffer)
{
	int i;
	int nchars = 0;

	nchars += sprintf(char_buffer, "{");
	for (i = 0; i < TRACKERS; i++) {
		if (trackers[i].active == 1) {
			nchars += sprintf(char_buffer + nchars, "'%i':", trackers[i].id);
			nchars += get_current_corners(&trackers[i], char_buffer + nchars);
			nchars += sprintf(char_buffer + nchars, ",");
		}
	}
	if (nchars > 1) nchars--;
	nchars += sprintf(char_buffer + nchars, "}");

	return nchars;
}
