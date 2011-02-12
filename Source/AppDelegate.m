//
//  AppDelegate.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize loupe;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    self.window = [[NSWindow alloc] initWithContentRect:self.loupe.frame
                                              styleMask:NSBorderlessWindowMask 
                                                backing:NSBackingStoreBuffered 
                                                  defer:NO];
    
    [self.window setLevel:NSMainMenuWindowLevel+1];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setMovableByWindowBackground:YES];
    [self.window setOpaque:NO];
    [self.window setHasShadow:NO];
    [self.window useOptimizedDrawing:YES];
    [[self.window contentView] addSubview:self.loupe];
    
    //center the window
    [self.window center];
    //move the window to accomidate the bottom right corner style
    NSPoint windowPoint = self.window.frame.origin;
    windowPoint.x += frameBottomRightOffset;
    windowPoint.y += frameBottomRightOffset;
    [self.window setFrameOrigin:windowPoint];
    [self.window makeKeyAndOrderFront:self];
}

- (IBAction)save:(id)sender{
    CGImageRef image = [self shotImage];
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc] initWithCGImage:image];
    NSData *data = [bits representationUsingType:NSPNGFileType properties:nil];
    [data writeToFile:[@"~/Desktop/shot.png" stringByExpandingTildeInPath] atomically:YES];
    [bits release];
}


- (IBAction)shoot:(id)sender{ 
    //call save for now
    [self save:sender];
}

- (IBAction)precipitate:(id)sender{
    //call save for now
    [self save:sender];
}

- (IBAction)moveWindow:(id)sender{
    NSInteger tag = [sender tag];
    NSPoint windowPoint = self.window.frame.origin;
    if(tag == 0){
        windowPoint.y += 1.0f;
    }else if(tag == 1){
        windowPoint.y -= 1.0f;
    }else if(tag == 2){
        windowPoint.x -= 1.0f;
    }else if(tag == 3){
        windowPoint.x += 1.0f;
    }
    [self.window setFrameOrigin:windowPoint];
}

@end
