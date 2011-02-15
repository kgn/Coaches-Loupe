//
//  AppDelegate+Screenshot.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Screenshot)

- (CGImageRef)shotImageRef{
    NSRect shotRect = self.window.frame;
    NSRect screenRect = [[NSScreen mainScreen] frame];
    //convert into screen shot space: 0, 0 = top left of main screen
    shotRect.origin.y = screenRect.size.height-NSMaxY(shotRect)+frameThinOffset;
    shotRect.origin.x += frameThinOffset;
    shotRect.size = NSMakeSize(400.0f, 300.0f);
    return CGWindowListCreateImage(NSRectToCGRect(shotRect), 
                                   kCGWindowListOptionOnScreenOnly, 
                                   kCGNullWindowID, kCGWindowImageDefault);
}

- (NSData *)shotData{
    CGImageRef image = [self shotImageRef];
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

- (void)screenshotUploadedWithName:(NSString *)name toURL:(NSURL *)url forAction:(NSString *)action{
    [self doneWithUploadCourt];
    
    //copy to pasteboard
    NSString *urlString = [url absoluteString];
    NSString *htmlString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", urlString, name];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSHTMLPboardType, NSPasteboardTypeString, nil] owner:nil];
    [pasteboard setString:htmlString forType:NSHTMLPboardType];
    [pasteboard setString:urlString forType:NSPasteboardTypeString];
    
    if(UserDefaultPlaySoundValue){
        [[NSSound soundNamed:UserDefaultDoneSoundValue] play];
    }
    
    if(UserDefaultGrowlValue){
        [GrowlApplicationBridge notifyWithTitle:action
                                    description:urlString 
                               notificationName:AppName
                                       iconData:nil 
                                       priority:0 
                                       isSticky:NO 
                                   clickContext:urlString];
    }
}

@end
