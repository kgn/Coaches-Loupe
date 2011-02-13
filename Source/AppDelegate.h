//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "CLAPIEngine.h"
#import "PreferencesController.h"

#define frameBottomRightOffset 11.0f

@interface AppDelegate : NSObject <NSApplicationDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

@end

@interface AppDelegate (Actions)

- (IBAction)save:(id)sender;
- (IBAction)moveWindow:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end

@interface AppDelegate (Dribbble)

- (IBAction)shoot:(id)sender;

@end

@interface AppDelegate (CloudApp)

- (IBAction)precipitate:(id)sender;

@end

@interface AppDelegate (Screenshot)

- (CGImageRef)shotImage;
- (NSData *)shotData;
- (NSString *)shotName;

@end
