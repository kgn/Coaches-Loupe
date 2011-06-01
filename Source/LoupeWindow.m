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

- (void)keyDown:(NSEvent *)theEvent{
    NSString *keys = [theEvent charactersIgnoringModifiers];
    NSUInteger modFlags = [NSEvent modifierFlags];
    
    if(NSNumericPadKeyMask & modFlags){//arrow keys
        if ([keys length] == 1){
            CGFloat move = 1.0f;
            //if the cmd key is down move the loupe by 10
            if(NSCommandKeyMask & modFlags){
                move = 10.0f;
            }
            NSPoint windowPoint = self.frame.origin;
            
            unichar keyChar = [keys characterAtIndex:0];
            if (keyChar == NSLeftArrowFunctionKey){
                windowPoint.x -= move;
            }else if (keyChar == NSRightArrowFunctionKey){
                windowPoint.x += move;
            }else if (keyChar == NSUpArrowFunctionKey){
                windowPoint.y += move;
            }else if (keyChar == NSDownArrowFunctionKey){
                windowPoint.y -= move;
            }
            
            [self setFrameOrigin:windowPoint];
        }
    }else{
        [super keyDown:theEvent];
    }
}

@end
