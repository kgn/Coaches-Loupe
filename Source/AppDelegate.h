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

#define frameBottomRightOffset 11.0f

#define AppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

@interface AppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
    
    //TODO: dribbble api
    BOOL canUploadToDribbble;
    
    CLAPIEngine *cloudApp;
    BOOL canUploadToCloudApp;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

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
