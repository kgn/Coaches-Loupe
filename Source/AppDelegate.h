//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import <Growl/Growl.h>

#import "Keychain.h"
#import "CLAPIEngine.h"
#import "PreferencesController.h"

#define frameThinOffset 11.0f
#define frameThickOffset 30.0f

#define AppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

@interface AppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
    
    NSView *uploadView;
    NSTextField *uploadViewLabel;
    NSView *failedView;
    NSTextField *failedViewBigLabel;
    NSTextField *failedViewSmallLabel;
    NSButton *failedViewButton;
    
    //TODO: dribbble api
    BOOL canUploadToDribbble;
    
    CLAPIEngine *cloudApp;
    BOOL canUploadToCloudApp;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

@property (assign) IBOutlet NSView *uploadView;
@property (assign) IBOutlet NSTextField *uploadViewLabel;
@property (assign) IBOutlet NSView *failedView;
@property (assign) IBOutlet NSTextField *failedViewBigLabel;
@property (assign) IBOutlet NSTextField *failedViewSmallLabel;
@property (assign) IBOutlet NSButton *failedViewButton;

@property (nonatomic) BOOL canUploadToDribbble;

@property (retain, nonatomic) CLAPIEngine *cloudApp;
@property (nonatomic) BOOL canUploadToCloudApp;

@end

@interface AppDelegate (Actions)

- (IBAction)save:(id)sender;
- (IBAction)moveWindow:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end

@interface AppDelegate (Screenshot)

- (CGImageRef)shotImage;
- (NSData *)shotData;
- (NSString *)shotName;

@end

@interface AppDelegate (Dribbble)

- (IBAction)shoot:(id)sender;

@end

@interface AppDelegate (CloudApp)

- (void)setupCloudApp;
- (IBAction)precipitate:(id)sender;
- (void)changeCloudAppPassword:(NSNotification *)aNoficication;

@end

@interface AppDelegate (Court)

- (void)setupCourts;

- (void)showUploadCourtWithAnimation:(BOOL)animation;
- (void)showUploadCourtWithAnimation;
- (void)hideUploadCourtWithAnimation:(BOOL)animation;
- (void)hideUploadCourtWithAnimation;
- (void)doneWithUploadCourt;

- (void)showFailedCourtWithError:(NSError *)error;
- (IBAction)hideFailedCourt:(id)sender;

@end
