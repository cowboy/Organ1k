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


@interface Organ1kView : ScreenSaverView {
  
  float pi;
  float pi_over_180;
  
  float frame_rate;
  int frame_count;
  int fps;
  
  float cycle_speed_adjust;
  
  NSPoint origin;
  
  struct color {
    float r, g, b;
  } colors[8];
  
  struct item {
    float x, y;
  } items[32];
  
  struct blip {
    float x, y, s, d;
    struct color c;
  } blips[300];
  
  int num_colors;
  int num_items;
  int num_blips;
  
  int blip_cur;
  
  float theta;
  float cycle_speed;
  float delay_speed;
  float math_mode;
  float dir;
  
  int last_n;
  
  float blip_min_size;
  float blip_max_size;
  float blip_scale;
  
  float max_radius;
}

@end

static __inline__ float rnd() {
  return (float) random() / (float) RAND_MAX;
}
