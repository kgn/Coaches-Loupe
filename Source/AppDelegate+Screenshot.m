//
//  AppDelegate+Shot.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Screenshot)

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

- (NSData *)shotData{
    CGImageRef image = [self shotImage];
    NSBitmapImageRep *bits = [[[NSBitmapImageRep alloc] initWithCGImage:image] autorelease];
    return [bits representationUsingType:NSPNGFileType properties:nil];
}

- (NSString *)shotName{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"'Loupe shot' yyyy-MM-dd 'at' h.mm.s a.'png'"];
    NSString *filename = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return filename;
}

@end
