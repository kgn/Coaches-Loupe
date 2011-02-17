//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import <Growl/Growl.h>

#import "Keychain.h"
#import "CLAPIEngine.h"
#import "DribbbleEngine.h"
#import "PreferencesController.h"

#define frameThinOffset 21.0f
#define frameThickOffset 40.0f

#define AppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

@interface AppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate, DribbbleEngineDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
    
    NSView *uploadView;
    NSTextField *uploadViewLabel;
    NSImageView *uploadViewImage;
    NSView *failedView;
    NSTextField *failedViewBigLabel;
    NSTextField *failedViewSmallLabel;
    NSButton *failedViewButton;
    
    DribbbleEngine *dribbble;
    BOOL canUploadToDribbble;
    
    CLAPIEngine *cloudApp;
    BOOL canUploadToCloudApp;
    
    
    //TODO: disable actions when a shot is being uploaded
    BOOL isUploading;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

@property (assign) IBOutlet NSView *uploadView;
@property (assign) IBOutlet NSTextField *uploadViewLabel;
@property (assign) IBOutlet NSImageView *uploadViewImage;

@property (assign) IBOutlet NSView *failedView;
@property (assign) IBOutlet NSTextField *failedViewBigLabel;
@property (assign) IBOutlet NSTextField *failedViewSmallLabel;
@property (assign) IBOutlet NSButton *failedViewButton;

@property (retain, nonatomic) DribbbleEngine *dribbble;
@property (nonatomic) BOOL canUploadToDribbble;

@property (retain, nonatomic) CLAPIEngine *cloudApp;
@property (nonatomic) BOOL canUploadToCloudApp;

@property (nonatomic) BOOL isUploading;

@end

@interface AppDelegate (Growl)

@end

@interface AppDelegate (Actions)

- (IBAction)save:(id)sender;
- (IBAction)moveWindow:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end

@interface AppDelegate (Screenshot)

- (CGImageRef)shotImageRef;
- (NSData *)shotData;
- (NSString *)shotName;
- (void)screenshotUploadedWithName:(NSString *)name toURL:(NSURL *)url forAction:(NSString *)action;

@end

@interface AppDelegate (Dribbble)

- (void)setupDribbble;
- (IBAction)shoot:(id)sender;
- (void)changeDribbblePassword:(NSNotification *)aNoficication;

@end

@interface AppDelegate (CloudApp)

- (void)setupCloudApp;
- (IBAction)precipitate:(id)sender;
- (void)changeCloudAppPassword:(NSNotification *)aNoficication;

@end

@interface AppDelegate (Court)

- (void)setupCourts;

- (void)showUploadCourtWithAnimation:(BOOL)animation withImage:(NSImage *)image;
- (void)showUploadCourtWithAnimationWithImage:(NSImage *)image;
- (void)hideUploadCourtWithAnimation:(BOOL)animation;
- (void)hideUploadCourtWithAnimation;
- (void)doneWithUploadCourt;

- (void)showFailedCourtWithError:(NSError *)error;
- (IBAction)hideFailedCourt:(id)sender;

@end
