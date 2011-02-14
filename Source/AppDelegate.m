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

@synthesize uploadView;
@synthesize uploadViewLabel;
@synthesize uploadViewImage;
@synthesize failedView;
@synthesize failedViewBigLabel;
@synthesize failedViewSmallLabel;
@synthesize failedViewButton;

@synthesize dribbble;
@synthesize canUploadToDribbble;

@synthesize cloudApp;
@synthesize canUploadToCloudApp;

+ (void)initialize{
    if([self class] == [AppDelegate class]){
        [PreferencesController registerUserDefaults];
    }
}

- (void)awakeFromNib{
    [self setupCourts];    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    self.window = [[NSWindow alloc] initWithContentRect:self.loupe.frame
                                              styleMask:NSBorderlessWindowMask 
                                                backing:NSBackingStoreBuffered 
                                                  defer:NO];
    //TODO: figure out how to allow the window to go over the status bar
    [self.window setLevel:NSMainMenuWindowLevel];
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
    windowPoint.x += frameThinOffset;
    windowPoint.y += frameThinOffset;
    [self.window setFrameOrigin:windowPoint];
    [self.window makeKeyAndOrderFront:self];
    
    //setup growl
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    //dribbble
    self.dribbble = [DribbbleEngine engineWithDelegate:self];
    [self setupDribbble];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeCloudAppPassword:) 
                                                 name:CloudAppPasswordChangeNotification 
                                               object:nil];    
    
    //CloudApp
    self.cloudApp = [CLAPIEngine engineWithDelegate:self];
    [self setupCloudApp];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeDribbblePassword:) 
                                                 name:DribbblePasswordChangeNotification 
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
