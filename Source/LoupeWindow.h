//
//  LoupeWindow.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/22/11.
//

#define frameThinOffset 21.0f
#define frameThickOffset 40.0f

@interface LoupeWindow : NSWindow {
    NSPoint initialLocation;
}

@property (assign) NSPoint initialLocation;

- (void)setWindowPosition:(NSPoint)point;

@end
