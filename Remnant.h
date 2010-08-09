/*
 * Organ1k: Screen Saver
 * http://benalman.com/code/projects/js1k-organ1k/organ1k.html
 * 
 * Remnant.h
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

#import <Foundation/Foundation.h>


@interface Remnant : NSObject {
  NSPoint point;
  NSColor *color;
  NSBezierPath *path;
  float size;
  float dir;
}

@property NSPoint point;
@property(retain) NSColor *color;
@property(retain) NSBezierPath *path;
@property float size, dir;

@end
