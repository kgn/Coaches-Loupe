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
@synthesize loupeImageView;

@synthesize uploadView;
@synthesize uploadViewLabel;
@synthesize uploadViewImage;
@synthesize failedView;
@synthesize failedViewBigLabel;
@synthesize failedViewSmallLabel;
@synthesize failedViewButton;
@synthesize failedViewImage;
@synthesize dribbblePublishView;
@synthesize dribbblePublishName;
@synthesize dribbblePublishTags;
@synthesize dribbblePublishComment;
@synthesize dribbblePublishButton;
@synthesize dribbblePublishPreview;
@synthesize cloudPublishView;
@synthesize cloudPublishName;
@synthesize cloudPublishButton;
@synthesize cloudPublishPreview;

@synthesize dribbble;
@synthesize canUploadToDribbble;

@synthesize cloudApp;
@synthesize canUploadToCloudApp;
@synthesize cloudShotName;

@synthesize currentShotName;
@synthesize currentShotData;

@synthesize isUploading;

+ (void)initialize{
    if([self class] == [AppDelegate class]){
        [PreferencesController registerUserDefaults];
    }
}

- (void)setLoupeTransperency{
    [self.loupeImageView setAlphaValue:UserDefaultWindowTransparencyValue/100.0f];
}

- (void)awakeFromNib{
    [self setupCourts];
}

- (void)userDefaultsChanged:(NSNotification *)aNoficication{
    [self setLoupeTransperency];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    //center the window
    [self.window center];
    
    //move the window to accomidate the bottom right corner style
    NSPoint windowPoint = self.window.frame.origin;
    windowPoint.x += frameThinOffset;
    windowPoint.y += frameThinOffset;
    [self.window setFrameOrigin:windowPoint];
    [self.window makeKeyAndOrderFront:self];
    
    [self setLoupeTransperency];
    
    //fade in window
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSWindow *)[self.window animator] setAlphaValue:1.0f];
    [NSAnimationContext endGrouping];    
    
    //setup growl
    [GrowlApplicationBridge setGrowlDelegate:self];
    
    //dribbble
    self.dribbble = [BBBouncePass passWithDelegate:self];
    [self setupDribbble];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeDribbblePassword:) 
                                                 name:DribbblePasswordChangeNotification 
                                               object:nil];
    
    //CloudApp
    self.cloudApp = [CLAPIEngine engineWithDelegate:self];
    [self setupCloudApp];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeCloudAppPassword:) 
                                                 name:CloudAppPasswordChangeNotification 
                                               object:nil];
    
    //watch user defaults
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(userDefaultsChanged:) 
                                                 name:NSUserDefaultsDidChangeNotification 
                                               object:nil];     
}

@end
