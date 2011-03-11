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
                                   kCGWindowListOptionOnScreenBelowWindow, 
                                   [self.window windowNumber], 
                                   kCGWindowImageDefault);
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

- (void)screenshotUploadedWithName:(NSString *)name toURL:(NSURL *)url withShortURL:(NSURL*)shortURL forAction:(NSString *)action{
    [self doneWithUploadCourt];
    
    if(shortURL == nil){
        shortURL = url;
    }
    
    NSString *urlString = [url absoluteString];
    NSString *shortUrlString = [shortURL absoluteString];    
    
    //copy to pasteboard
    if(UserDefaultCopyToClipboardValue){
        NSString *htmlString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", shortUrlString, name];
        
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard declareTypes:[NSArray arrayWithObjects:NSHTMLPboardType, NSPasteboardTypeString, nil] owner:nil];
        [pasteboard setString:htmlString forType:NSHTMLPboardType];
        [pasteboard setString:shortUrlString forType:NSPasteboardTypeString];
    }
    
    //play sound
    if(UserDefaultPlaySoundValue){
        [[NSSound soundNamed:UserDefaultDoneSoundValue] play];
    }
    
    //display growl notification
    if(UserDefaultGrowlValue){
        [GrowlApplicationBridge notifyWithTitle:action
                                    description:name 
                               notificationName:AppName
                                       iconData:nil 
                                       priority:0 
                                       isSticky:NO 
                                   clickContext:urlString];
    }
    
    //tweet shot
    if(UserDefaultTweetShotKey){
//        [[NSWorkspace sharedWorkspace] openFile:@"tweet tweet" withApplication:@"Twitter"];        
        
//        [[NSWorkspace sharedWorkspace] openURLs:[NSArray arrayWithObject:@"tweet"]
//                        withAppBundleIdentifier:UserDefaultTwitterAppIdValue
//                                        options:NSWorkspaceLaunchDefault | NSWorkspaceLaunchWithoutAddingToRecents
//                 additionalEventParamDescriptor:nil
//                              launchIdentifiers:nil];
    }
}

@end
