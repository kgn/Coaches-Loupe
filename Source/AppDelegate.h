//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#import "CLAPIEngine.h"

#define frameBottomRightOffset 11.0f

@interface AppDelegate : NSObject <NSApplicationDelegate, CLAPIEngineDelegate> {
    NSWindow *window;
    NSView *loupe;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

- (IBAction)save:(id)sender;
- (IBAction)shoot:(id)sender;
- (IBAction)moveWindow:(id)sender;

@end

@interface AppDelegate (Screenshot)

- (CGImageRef)shotImage;
- (NSData *)shotData;
- (NSString *)shotName;

@end

@interface AppDelegate (CloudApp)

- (IBAction)precipitate:(id)sender;

@end
