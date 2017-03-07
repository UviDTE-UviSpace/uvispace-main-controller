#ifndef __TRACKERS_H__
#define __TRACKERS_H__

#include "avalon_locator.h"
#include "avalon_locator_regs.h"

#define TRACKERS 6

#define TRACKER(i) TRACKER_##i##_BASE

extern LOCATOR trackers[TRACKERS];

void trackers_init();

int trackers_number();

int trackers_free(char *char_buffer);

int activate_tracker(int id, char *char_buffer);

int disable_tracker(int id, char *char_buffer);

int free_tracker(int id, char *char_buffer);

int set_search_window_of_tracker(int id, char *char_buffer, int x, int y, int width, int height);

int get_search_window_of_tracker(int id, char *char_buffer);

int get_current_corners_of_tracker(int id, char *char_buffer);

int get_current_windows_of_activated_trackers(char *char_buffer);

int get_current_corners_of_activated_trackers(char *char_buffer);

#endif
