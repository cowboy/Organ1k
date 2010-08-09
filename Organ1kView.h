/*
 * Organ1k: Screen Saver
 * http://benalman.com/code/projects/js1k-organ1k/organ1k.html
 * 
 * Organ1kView.h
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

#include <math.h>
#import <ScreenSaver/ScreenSaver.h>
#import <Remnant.h>


@interface Organ1kView : ScreenSaverView {
  
  float pi;
  float pi_over_180;
  
  float framerate;
  int frame_count;
  
  float cycle_speed_adjust;
  
  int num_items;
  int max_remnants;
  int remnant_current;
  
  NSMutableArray *items;
  NSMutableArray *remnants;
  NSMutableArray *remnant_colors;
  
  int num_remnant_colors;
  
  float current;
  float cycle_speed;
  float delay_speed;
  float math_mode;
  float dir;
  
  int last_n;
  
  float remnant_min_size;
  float remnant_max_size;
  
  NSRect viewBounds;
  NSSize viewSize;
  NSPoint viewCenter;
  
  float max_radius;
}

@end

static __inline__ CGFloat minf( CGFloat a, CGFloat b ) {
  return a < b ? a : b;
}
