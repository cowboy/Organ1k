/*
 * Organ1k: Screen Saver
 * http://benalman.com/code/projects/js1k-organ1k/organ1k.html
 * 
 * Organ1kView.m
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

#import "Organ1kView.h"


@implementation Organ1kView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
  self = [super initWithFrame:frame isPreview:isPreview];
  if (self) {
    framerate = 30.0;
    frame_count = 0;
    
    cycle_speed_adjust = 1.5;
    
    srandomdev();
    
    pi = acosf( -1.0 );
    pi_over_180 = pi / 180.0;
    
    items = [NSMutableArray array];
    remnants = [NSMutableArray array];
    
    // var colors = 'f001fa01ff0107010ff100f14081e8e'.split(1);
    // $.each( colors, function( i, hex ){
    //   var rgb = $.map( hex.split(''), function(c,i){
    //     return ( parseInt( c+c, 16 ) / 255 + '.0' ).replace( /\.(.{1,3}).*/, '.$1' );
    //   });
    //   console.log('[remnant_colors addObject:[NSColor colorWithCalibratedRed:' + rgb[0] + ' green:' + rgb[1] + ' blue:' + rgb[2] + ' alpha:1.0]];');
    // });
    
    remnant_colors = [NSMutableArray array];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:1.0 green:0.666 blue:0.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:0.0 green:0.466 blue:0.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:0.0 green:1.0 blue:1.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:0.266 green:0.0 blue:0.533 alpha:1.0]];
    [remnant_colors addObject:[NSColor colorWithCalibratedRed:0.933 green:0.533 blue:0.933 alpha:1.0]];
    
    num_remnant_colors = [remnant_colors count];
    
    num_items = 32;
    max_remnants = 300;
    
    remnant_current = -1;
    
    current = 0.0;
    
    cycle_speed = 1.0;
    delay_speed = 1.0;
    math_mode = 0.0;
    
    dir = 1.0;
    
    viewBounds = [self bounds];
    viewSize   = [self bounds].size;
    
    viewCenter.x = viewSize.width  / 2.0;
    viewCenter.y = viewSize.height / 2.0;
    
    max_radius = fmin( viewSize.width, viewSize.height ) / 2;
    
    remnant_max_size = 8.0;
    remnant_min_size = 3.0;
    
    max_radius -= remnant_max_size;
    
    int i;
    
    for ( i = 0; i < max_remnants; i++ ) {
      Remnant *remnant = [[Remnant alloc] init];
      remnant.dir = -10000.0;
      [remnants addObject:remnant];
      [remnant release];
    }
    
    for ( i = 0; i <= num_items; i++ ) {
      [items addObject:[NSValue valueWithPoint:viewCenter]];
    }
    
    [self setAnimationTimeInterval:1/framerate];
  }
  
  return self;
}

- (void)startAnimation
{
  [super startAnimation];
}

- (void)stopAnimation
{
  [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
  //NSLog(@"drawRect");
  [super drawRect:rect];
  
  /*
  NSPoint item;
  for ( int i = 0; i < num_items; i++ ) {
    item = [[items objectAtIndex:i] pointValue];
    [[NSColor grayColor] set];
    
    //NSLog(@"remnant %i (%f, %f)", i, remnant.x, remnant.y );
    item_rect = NSMakeRect( item.x - ( size / 2.0 ), item.y - ( size / 2.0 ), size, size );
    //NSRectFill( item_rect );
    
    [[NSBezierPath bezierPathWithOvalInRect:item_rect] fill];
  }
  */
  
  // Draw "circle" remnants.
  int i;
  Remnant *remnant;
  float size;
  NSRect item_rect;
  
  for ( i = 0; i < max_remnants; i++ ) {
    remnant = [remnants objectAtIndex:i];
    
    if ( remnant.dir == -10000.0 ) {
      break;
    }
    
    //NSLog(@"remnant %i (%f, %f)", i, remnant.point.x, remnant.point.y );
    
    // Pulse the circle.
    remnant.size += remnant.dir;
    remnant.dir = remnant.size >= remnant_max_size ? -1.0
                : remnant.size <= remnant_min_size ? 1.0
                : remnant.dir;
    
    // Draw the circle.
    [remnant.color set];
    
    size = remnant.size * max_radius / 300.0;
    item_rect = NSMakeRect( remnant.point.x - ( size / 2.0 ), remnant.point.y - ( size / 2.0 ), size, size );
    
    //NSRectFill( item_rect );
    [[NSBezierPath bezierPathWithOvalInRect:item_rect] fill];
  }
  
}

- (void)animateOneFrame
{
  //[self setNeedsDisplay:YES];return;
  
  frame_count = ( frame_count + 1 ) % (int)( 1000 / framerate );
  //NSLog(@"%i", frame_count);
  if ( frame_count == 0 ) {
    float n;
    float r1 = SSRandomFloatBetween( 0.0, 1.0 );
    
    while ( last_n == (int)( n = SSRandomFloatBetween( 0.0, 6.0 ) ) ) {};
    
    last_n = (int)n;
    
    //n = 1.0;
    
    //NSLog(@"done n: %f, last_n: %i", n, last_n);
    
    if ( n < 0.5 ) {
      dir = -dir;
      //NSLog(@"dir %f", dir);
      
    } else if ( n < 2.0 ) {
      for ( int i = 1; i < num_remnant_colors; i++ ) {
        [remnant_colors exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
      }
      //NSLog(@"color shift");
      
    } else if ( n < 3.0 ) {
      math_mode = r1 * 7.0;
      //NSLog(@"math_mode %f", math_mode);
      
    } else if ( n < 4.0 ) {
      cycle_speed = r1 * 8.0 + 1.0;
      //NSLog(@"cycle_speed %f", cycle_speed);
      
    } else if ( n < 5.0 ) {
      delay_speed = r1 * 3.0;
      //NSLog(@"delay_speed %f", delay_speed);
      
    } else {
      remnant_max_size = r1 * 10.0 + 6.0;
      remnant_min_size = minf( remnant_max_size - 4, SSRandomFloatBetween( 0.0, 1.0 ) * 5 + 2 );
      //NSLog(@"remnant_max_size %f, remnant_min_size %f", remnant_max_size, remnant_min_size);
    }
  }
  
  //NSLog(@"animateOneFrame");
  //NSLog(@"current %f", current);
  
  int i;
  float x;
  float y;
  float r;
  float a;
  
  if ( math_mode < 1.0 ) {
    current -= cycle_speed * dir * 4 * cycle_speed_adjust;
    
    x = sinf( current * pi_over_180 ) * max_radius;
    y = cosf( current * pi_over_180 ) * max_radius;
    
  } else {
    current -= cycle_speed * dir * 2 * cycle_speed_adjust;
    
    x = sinf( current * pi_over_180 ) * max_radius;
    y = 0.0;
    
    r = sqrtf( powf( x, 2.0 ) + powf( y, 2.0 ) );
    a = atan2f( y, x ) + ( current * pi_over_180 / math_mode );
    
    x = r * cosf( a );
    y = r * sinf( a );
  }
  
  // Update "items" array.
  NSPoint item;
  NSPoint this_item;
  NSPoint prev_item;
  
  for ( i = 0; i <= num_items; i++ ) {
    
    if ( i == 0 ) {
      item = NSMakePoint( viewCenter.x + x, viewCenter.y + y );
      
    } else {
      this_item = [[items objectAtIndex:i] pointValue];
      prev_item = [[items objectAtIndex:i-1] pointValue];
      
      item = NSMakePoint(
                         this_item.x + ( prev_item.x - this_item.x ) / ( delay_speed + 1.0 ),
                         this_item.y + ( prev_item.y - this_item.y ) / ( delay_speed + 1.0 ) );
    }
    
    [items replaceObjectAtIndex:i withObject:[NSValue valueWithPoint:item]];
  }
  
  //NSLog(@"%f deg, delta (%f, %f), item0 (%f, %f)", deg, x, y, item0.x, item0.y );
  
  
  Remnant *remnant;
  for ( i = 0; i < num_remnant_colors; i++ ) {
    item = [[items objectAtIndex:i*4] pointValue];
    
    remnant_current = ( remnant_current + 1 ) % max_remnants;
    
    remnant = [remnants objectAtIndex:remnant_current];
    remnant.point = NSMakePoint( item.x, item.y );
    remnant.color = [remnant_colors objectAtIndex:i];
    remnant.size = 1.0;
    remnant.dir = 1.0;
  }
  
  [self setNeedsDisplay:YES];
  
  return;
}

- (BOOL)isFlipped
{
  return YES;
}

- (BOOL)hasConfigureSheet
{
  return NO;
}

- (NSWindow*)configureSheet
{
  return nil;
}

@end
