//
//  AppDelegate+Shot.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Shot)

- (CGImageRef)shotImage{
    NSRect shotRect = self.window.frame;
    NSRect screenRect = [[NSScreen mainScreen] frame];
    //convert into screen shot space: 0, 0 = top left of main screen
    shotRect.origin.y = screenRect.size.height-NSMaxY(shotRect)+frameBottomRightOffset;
    shotRect.origin.x += frameBottomRightOffset;
    shotRect.size = NSMakeSize(400.0f, 300.0f);
    return CGWindowListCreateImage(NSRectToCGRect(shotRect), 
                                   kCGWindowListOptionOnScreenOnly, 
                                   kCGNullWindowID, kCGWindowImageDefault);
}

@end
