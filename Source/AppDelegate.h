//
//  AppDelegate.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/11/11.
//

#define frameBottomRightOffset 11.0f

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSView *loupe;
}

@property (retain, nonatomic) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *loupe;

- (IBAction)save:(id)sender;
- (IBAction)shoot:(id)sender;
- (IBAction)precipitate:(id)sender;

@end

@interface AppDelegate (Shot)

- (CGImageRef)shotImage;

@end

