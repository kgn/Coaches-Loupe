//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import <Growl/Growl.h>

#import "Keychain.h"
#import "CLAPIEngine.h"
#import "BBBouncePass.h"
#import "PreferencesController.h"
#import "PassMouseViews.h"

#define frameThinOffset 21.0f
#define frameThickOffset 40.0f

#define AppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define fadeInDuration 0.25f

@interface AppDelegate : NSObject <NSApplicationDelegate, 
                                   GrowlApplicationBridgeDelegate, 
                                   BBBouncePassDelegate, 
                                   CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
    LoupeImageView *loupeImageView;
                                       
    NSMenu *recentUploadMenu;
    
    NSView *uploadView;
    NSTextField *uploadViewLabel;
    NSImageView *uploadViewImage;
    NSView *failedView;
    NSTextField *failedViewBigLabel;
    NSTextField *failedViewSmallLabel;
    NSButton *failedViewButton;
    NSImageView *failedViewImage;
                                       
    NSView *dribbblePublishView;     
    NSTextField *dribbblePublishName;
    NSTextField *dribbblePublishTags;
    NSTextField *dribbblePublishComment;
    NSButton *dribbblePublishButton;
    NSButton *dribbbleCancelButton;
    NSImageView *dribbblePublishPreview;
                                       
    NSView *cloudPublishView;
    NSTextField *cloudPublishName;
    NSButton *cloudPublishButton;
    NSButton *cloudCancelButton;
    NSImageView *cloudPublishPreview;

    BBBouncePass *dribbble;
    BOOL canUploadToDribbble, enableUploadToDribbble;
    
    CLAPIEngine *cloudApp;
    BOOL canUploadToCloudApp, enableUploadToCloudApp;
    NSString *cloudShotName;
                                       
    NSString *currentShotName;
    NSData *currentShotData;
                                       
    //TODO: disable actions when a shot is being uploaded
    BOOL isUploading;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;
@property (assign) IBOutlet LoupeImageView *loupeImageView;

@property (assign) IBOutlet NSMenu *recentUploadMenu;

@property (assign) IBOutlet NSView *uploadView;
@property (assign) IBOutlet NSTextField *uploadViewLabel;
@property (assign) IBOutlet NSImageView *uploadViewImage;

@property (assign) IBOutlet NSView *failedView;
@property (assign) IBOutlet NSTextField *failedViewBigLabel;
@property (assign) IBOutlet NSTextField *failedViewSmallLabel;
@property (assign) IBOutlet NSButton *failedViewButton;
@property (assign) IBOutlet NSImageView *failedViewImage;

@property (assign) IBOutlet NSView *dribbblePublishView;
@property (assign) IBOutlet NSTextField *dribbblePublishName;
@property (assign) IBOutlet NSTextField *dribbblePublishTags;
@property (assign) IBOutlet NSTextField *dribbblePublishComment;
@property (assign) IBOutlet NSButton *dribbblePublishButton;
@property (assign) IBOutlet NSButton *dribbbleCancelButton;
@property (assign) IBOutlet NSImageView *dribbblePublishPreview;

@property (assign) IBOutlet NSView *cloudPublishView;
@property (assign) IBOutlet NSTextField *cloudPublishName;
@property (assign) IBOutlet NSButton *cloudPublishButton;
@property (assign) IBOutlet NSButton *cloudCancelButton;
@property (assign) IBOutlet NSImageView *cloudPublishPreview;

@property (retain, nonatomic) BBBouncePass *dribbble;
@property (nonatomic) BOOL canUploadToDribbble, enableUploadToDribbble;

@property (retain, nonatomic) CLAPIEngine *cloudApp;
@property (nonatomic) BOOL canUploadToCloudApp, enableUploadToCloudApp;
@property (copy, nonatomic) NSString *cloudShotName;

@property (copy, nonatomic) NSString *currentShotName;
@property (retain, nonatomic) NSData *currentShotData;

@property (nonatomic) BOOL isUploading;

@end

@interface AppDelegate (Growl)

@end

@interface AppDelegate (RecentUploads)

- (void)rebuildRecentUploadMenu;

@end

@interface AppDelegate (Actions)

- (IBAction)save:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end

@interface AppDelegate (Screenshot)

- (NSData *)shotData;
- (NSString *)shotName;
- (void)screenshotUploadedWithName:(NSString *)name 
                             toURL:(NSURL *)url 
                      withShortURL:(NSURL*)shortURL 
                         forAction:(NSString *)action;

@end

@interface AppDelegate (Dribbble)

- (void)setupDribbble;
- (IBAction)shoot:(id)sender;
- (IBAction)publishToDribbble:(id)sender;
- (void)changeDribbblePassword:(NSNotification *)aNoficication;

@end

@interface AppDelegate (CloudApp)

- (void)setupCloudApp;
- (IBAction)precipitate:(id)sender;
- (IBAction)publishToCloud:(id)sender;
- (void)changeCloudAppPassword:(NSNotification *)aNoficication;

@end

@interface AppDelegate (Court)

- (void)setupCourts;

- (void)showUploadCourtWithAnimation:(BOOL)animation withImage:(NSImage *)image;
- (void)showUploadCourtWithAnimationWithImage:(NSImage *)image;
- (void)hideUploadCourtWithAnimation:(BOOL)animation;
- (void)hideUploadCourtWithAnimation;
- (void)doneWithUploadCourt;

- (void)showDribbbleInfoCourtWithAnimation:(BOOL)animation withName:(NSString *)name;
- (void)showDribbbleInfoCourtWithAnimationWithName:(NSString *)name;
- (void)hideDribbbleInfoCourtWithDelay:(BOOL)delay;
- (IBAction)cancelDribbbleUpload:(id)sender;

- (void)showCloudInfoCourtWithAnimation:(BOOL)animation withName:(NSString *)name;
- (void)showCloudInfoCourtWithAnimationWithName:(NSString *)name;
- (void)hideCloudInfoCourtWithDelay:(BOOL)delay;
- (IBAction)cancelCloudUpload:(id)sender;

- (void)showFailedCourtWithError:(NSError *)error;
- (IBAction)hideFailedCourt:(id)sender;

@end
