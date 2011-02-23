//
//  LoupeWindow.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/22/11.
//

#import "LoupeWindow.h"

@implementation LoupeWindow

@synthesize initialLocation;

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if ((self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO])){
        [self setAlphaValue:0.0f];
        [self setLevel:NSScreenSaverWindowLevel];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
        [self setOpaque:NO];
        [self useOptimizedDrawing:YES];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent{
    self.initialLocation = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent{
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
    
    NSPoint currentLocation = [theEvent locationInWindow];
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);
    
    [self setFrameOrigin:newOrigin];
}

@end
