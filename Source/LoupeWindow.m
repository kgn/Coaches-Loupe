//
//  LoupeWindow.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/22/11.
//

#import "LoupeWindow.h"
#import "AppDelegate.h"

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
    NSPoint newOrigin = self.frame.origin;
    
    NSPoint currentLocation = [theEvent locationInWindow];
    newOrigin.x += currentLocation.x - initialLocation.x;
    newOrigin.y += currentLocation.y - initialLocation.y;
    
    [self setWindowPosition:newOrigin];
}

- (void)setWindowPosition:(NSPoint)point{
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    
    //y
    if((point.y+frameThickOffset) >= (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)){
        point.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - frameThickOffset);
    }else if(point.y+windowFrame.size.height-frameThinOffset <= 0){
        point.y = -windowFrame.size.height+frameThinOffset;
    }
    
    //x
    if((point.x+frameThinOffset) >= (screenVisibleFrame.origin.x + screenVisibleFrame.size.width)){
        point.x = screenVisibleFrame.origin.x + (screenVisibleFrame.size.width - frameThinOffset);
    }
    NSLog(@"%f", point.x-screenVisibleFrame.origin.x);
    
    [self setFrameOrigin:point];
}

@end
