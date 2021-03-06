//
//  RWStreamingSliderCell.m
//  DoubleSlider
//
//  Created by Rafaël Warnault on 16/10/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "RWStreamingSliderCell.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"


@interface RWStreamingSliderCell (Private)
- (CGFloat)bufferWidth;
@end



@implementation RWStreamingSliderCell

@dynamic bufferValue;


/* This overwrite stop NSSlider superclass drawing */
- (BOOL)_usesCustomTrackImage {
	return YES;
}

/* Returns the rectangle in which the slider knob is drawn */
-(NSRect)knobRectFlipped:(BOOL)flipped {
	return [super knobRectFlipped:NO];
}


/* Draws the slider’s bar—but not its bezel or knob—inside the specified rectangle. */
- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped {
    
    
    NSGradient *backGradient = nil;
    
    if([NSApp isActive]) {
        backGradient = [[[NSGradient alloc] initWithColorsAndLocations:
                         [NSColor colorWithCalibratedWhite:0.3f alpha:1.0f], 0.0f,
                         [NSColor colorWithCalibratedWhite:0.4f alpha:1.0f], 0.8f,
                         [NSColor darkGrayColor], 1.0f, 
                         nil] autorelease];
    } else {
        backGradient = [[[NSGradient alloc] initWithColorsAndLocations:
                         [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 0.0f,
                         [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 0.8f,
                         [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 1.0f, 
                         nil] autorelease];
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    NSRect innerRect = NSMakeRect(aRect.origin.x, aRect.origin.y+5, aRect.size.width, aRect.size.height-10);
    NSBezierPath *barPath = [NSBezierPath bezierPathWithRoundedRect:innerRect cornerRadius:innerRect.size.height];
    
    [backGradient drawInBezierPath:barPath angle:90];
    
    [barPath setClip];
    [NSBezierPath clipRect:innerRect];
    
    [[NSColor darkGrayColor] setStroke];
    [barPath stroke];
    
    [NSGraphicsContext restoreGraphicsState];
}


/* Draws the slider knob in the given rectangle */
- (void)drawKnob:(NSRect)aRect {
    
    NSGradient *backGradient = nil;
    NSGradient *bufferGradient = nil;
    
    if([NSApp isActive]) {
        NSColor *topColor = [NSColor colorWithCalibratedRed:0.3452 green:0.6284 blue:0.8694 alpha:1.0000];
        NSColor *endColor = [NSColor colorWithCalibratedRed:0.1701 green:0.4463 blue:0.7877 alpha:1.0000];
        backGradient = [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
        
        bufferGradient = [[[NSGradient alloc] initWithStartingColor:[NSColor grayColor]
                                                        endingColor:[NSColor grayColor]] autorelease];
        
    } else {
        NSColor *topColor = [NSColor colorWithCalibratedRed:0.6850 green:0.7288 blue:0.8332 alpha:1.0000];
        NSColor *endColor = [NSColor colorWithCalibratedRed:0.5441 green:0.5949 blue:0.7257 alpha:1.0000];
        backGradient = [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
 
        bufferGradient = [[[NSGradient alloc] initWithStartingColor:[NSColor lightGrayColor]
                                                        endingColor:[NSColor lightGrayColor]] autorelease];
    }
    
    [NSGraphicsContext saveGraphicsState];
    
    NSBezierPath *knobPath = nil;
    NSBezierPath *bufferPath = nil;
        
    CGFloat knobWidth = [self floatValue] * [self trackRect].size.width / 100;
    CGFloat bufferWidth = [self bufferWidth];
    
    if(knobWidth < aRect.size.height-14)
        knobWidth = aRect.size.height-14;
    
    NSRect knobRect = NSMakeRect(1, aRect.origin.y+6, knobWidth-2, aRect.size.height-12);
    NSRect bufferRect = NSMakeRect(knobRect.origin.x, knobRect.origin.y, bufferWidth-2, knobRect.size.height);
    
    //BOOL atStart = (knobWidth < 100) ? YES : NO;
    BOOL atEnd = ([self trackRect].size.width - knobWidth < knobRect.size.height) ? YES : NO;
    
    if(!atEnd) {
        knobPath = [NSBezierPath bezierPathWithRoundedRect:knobRect 
                                              cornerRadius:knobRect.size.height 
                                                 inCorners:(OSTopLeftCorner | OSBottomLeftCorner)];
        
        bufferPath = [NSBezierPath bezierPathWithRoundedRect:bufferRect 
                                                cornerRadius:bufferRect.size.height 
                                                   inCorners:(OSTopLeftCorner | OSBottomLeftCorner)];
        
    } else {
        knobPath = [NSBezierPath bezierPathWithRoundedRect:knobRect 
                                              cornerRadius:knobRect.size.height];
        
        bufferPath = [NSBezierPath bezierPathWithRoundedRect:bufferRect 
                                                cornerRadius:bufferRect.size.height];
    }
        
    //[bufferPath setClip];
    [NSBezierPath clipRect:bufferRect];
        
    if([self bufferWidth] > 0.0f) {
        
        //[bufferPath setClip];
        [NSBezierPath clipRect:bufferRect];
        
        [bufferGradient drawInBezierPath:bufferPath angle:90];
    }
    
    if([self floatValue] > 0.0f) {
        
        //[knobPath setClip];
        [NSBezierPath clipRect:knobRect];
        
        [backGradient drawInBezierPath:knobPath angle:90];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}


- (CGFloat)bufferWidth {
    return [self bufferValue] / 100.0f * [self trackRect].size.width;
}


- (void)setBufferValue:(CGFloat)newValue {
    bufferValue = newValue;
}

- (CGFloat)bufferValue {
    return bufferValue;
}

@end
