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

@synthesize canUploadToDribbble;

@synthesize cloudApp;
@synthesize canUploadToCloudApp;

+ (void)initialize{
    if([self class] == [AppDelegate class]){
        [PreferencesController registerUserDefaults];
    }
}

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
    
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    //CloudApp
    self.cloudApp = [CLAPIEngine engineWithDelegate:self];
    [self setupCloudApp];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeCloudAppPassword:) 
                                                 name:CloudAppPasswordChangeNotification 
                                               object:nil];
}

#pragma -
#pragma Growl

- (NSDictionary *)registrationDictionaryForGrowl{
    NSArray *notificationArray = [NSArray arrayWithObject:AppName];
    NSDictionary *notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      notificationArray, GROWL_NOTIFICATIONS_ALL,
                                      notificationArray, GROWL_NOTIFICATIONS_DEFAULT,
                                      nil];
    return notificationDict;
}

-(void)growlNotificationWasClicked:(id)context{
    if([context isKindOfClass:[NSString class]]){
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:context]];
    }
}

@end
