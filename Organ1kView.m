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
    frame_rate = 30.0;
    frame_count = 0;
    fps = 1000 / frame_rate;
    
    cycle_speed_adjust = 1.5;
    
    srandomdev();
    
    pi = acosf( -1.0 );
    pi_over_180 = pi / 180.0;
    
    // Some JS to generate the color values:
    // 
    // var colors = 'f001fa01ff0107010ff100f14081e8e'.split(1);
    // $.each( colors, function( i, hex ){
    //   var rgb = $.map( hex.split(''), function(c,i){
    //     return ( parseInt( c+c, 16 ) / 255 + '.0' ).replace( /\.(.{1,3}).*/, '.$1' );
    //   });
    //   console.log('colors['+i+'].r = '+rgb[0]+';colors['+i+'].g = '+rgb[1]+';colors['+i+'].b = '+rgb[2]+';');
    // });
    
    colors[0].r = 1.0;   colors[0].g = 0.0;   colors[0].b = 0.0;
    colors[1].r = 1.0;   colors[1].g = 0.666; colors[1].b = 0.0;
    colors[2].r = 1.0;   colors[2].g = 1.0;   colors[2].b = 0.0;
    colors[3].r = 0.0;   colors[3].g = 0.466; colors[3].b = 0.0;
    colors[4].r = 0.0;   colors[4].g = 1.0;   colors[4].b = 1.0;
    colors[5].r = 0.0;   colors[5].g = 0.0;   colors[5].b = 1.0;
    colors[6].r = 0.266; colors[6].g = 0.0;   colors[6].b = 0.533;
    colors[7].r = 0.933; colors[7].g = 0.533; colors[7].b = 0.933;
    
    num_colors = 8;
    num_items  = 32;
    num_blips  = 300;
    
    blip_cur = -1;
    
    theta = rnd() * 360.0;
    
    cycle_speed = 1.0;
    delay_speed = 1.0;
    math_mode = 0.0;
    
    dir = rnd() < 0.5 ? -1.0 : 1.0;
    
    NSSize view_size = [self bounds].size;
    
    origin.x = view_size.width  / 2.0;
    origin.y = view_size.height / 2.0;
    
    max_radius = fmin( origin.x, origin.y );
    
    blip_max_size = 8.0;
    blip_min_size = 3.0;
    
    blip_scale = max_radius / 600.0;
    
    max_radius -= 20 * blip_scale;
    
    for ( int i = 0; i < num_blips; i++ ) {
      blips[i].d = -10000.0;
    }
    
    for ( int i = 0; i < num_items; i++ ) {
      items[i].x = 0.0;
      items[i].y = 0.0;
    }
    
    [self setAnimationTimeInterval: 1 / frame_rate ];
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
  [super drawRect:rect];
  
  CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
  CGContextSetFlatness( context, 2.0 );
  
  // Draw items.
  /*
  for ( int i = 0; i < num_items; i++ ) {
    CGContextSetRGBFillColor( context, 1.0, 1.0, 1.0, 0.9 );
    CGContextBeginPath( context );
    CGContextAddArc( context, origin.x + items[i].x, origin.y + items[i].y, 3.0, 0.0, 2 * pi, 0 );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
  }
  */
  
  // Draw blips.
  for ( int i = 0; i < num_blips; i++ ) {
    
    if ( blips[i].d == -10000.0 ) {
      break;
    }
    
    // Pulse the blip.
    blips[i].s += blips[i].d;
    blips[i].d = blips[i].s >= blip_max_size ? -1.0
               : blips[i].s <= blip_min_size ? 1.0
               : blips[i].d;
    
    // Draw the blip.
    CGContextSetRGBFillColor( context, blips[i].c.r, blips[i].c.g, blips[i].c.b, 1.0 );
    CGContextBeginPath( context );
    CGContextAddArc( context, origin.x + blips[i].x, origin.y + blips[i].y, blips[i].s * blip_scale, 0.0, 2 * pi, 0 );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
  }
  
  //CGContextFlush( context );
}

- (void)animateOneFrame
{
  //[self setNeedsDisplay:YES];return;
  
  frame_count = ( frame_count + 1 ) % fps;
  
  //NSLog(@"%i %i", frame_count, fps);
  if ( frame_count == 0 ) {
    float n;
    float r1 = rnd();
    
    while ( last_n == (int)( n = rnd() * 6.0 ) ) {};
    
    last_n = (int)n;
    
    //n = 1.0;
    
    //NSLog(@"done n: %f, last_n: %i", n, last_n);
    
    if ( n < 0.5 ) {
      dir = -dir;
      //NSLog(@"dir %f", dir);
      
    } else if ( n < 2.0 ) {
      struct color color = colors[0];
      for ( int i = 1; i < num_colors; i++ ) {
        colors[i-1] = colors[i];
      }
      colors[num_colors-1] = color;
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
      blip_max_size = r1 * 10.0 + 6.0;
      blip_min_size = fmin( blip_max_size - 4.0, rnd() * 5.0 + 2.0 );
      //NSLog(@"blip_max_size %f, blip_min_size %f", blip_max_size, blip_min_size);
    }
  }
  
  //NSLog(@"animateOneFrame");
  //NSLog(@"theta %f", theta);
  
  // Do some math!
  float x, y, r, a, n;
  
  if ( math_mode < 1.0 ) {
    // Circle.
    theta -= cycle_speed * dir * 4 * cycle_speed_adjust;
    
    n = theta * pi_over_180;
    
    x = sinf( n ) * max_radius;
    y = cosf( n ) * max_radius;
    
  } else {
    // Spiro.
    theta -= cycle_speed * dir * 2 * cycle_speed_adjust;
    
    n = theta * pi_over_180;
    
    x = sinf( n ) * max_radius;
    y = 0.0;
    
    r = sqrtf( powf( x, 2.0 ) + powf( y, 2.0 ) );
    a = atan2f( y, x ) + ( n / math_mode );
    
    x = r * cosf( a );
    y = r * sinf( a );
  }
  
  // Update items.
  for ( int i = 0; i < num_items; i++ ) {
    if ( i == 0 ) {
      items[i].x = x;
      items[i].y = y;
    } else {
      items[i].x += ( items[i-1].x - items[i].x ) / ( delay_speed + 1.0 );
      items[i].y += ( items[i-1].y - items[i].y ) / ( delay_speed + 1.0 );
    }
  }
  
  // Add (or replace) new blips.
  for ( int i = 0, j; i < num_colors; i++ ) {
    j = (float)( i * ( num_items - 1 ) ) / (float)( num_colors - 1 );
    
    blip_cur = ( blip_cur + 1 ) % num_blips;
    
    blips[blip_cur].x = items[j].x;
    blips[blip_cur].y = items[j].y;
    blips[blip_cur].c = colors[i];
    blips[blip_cur].s = 1.0;
    blips[blip_cur].d = 1.0;
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
