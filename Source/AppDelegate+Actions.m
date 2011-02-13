//
//  Actions.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Actions)

- (IBAction)save:(id)sender{
    NSData *data = [self shotData];
    NSString *imagePath = [NSString stringWithFormat:@"~/Desktop/%@", [self shotName]];
    [data writeToFile:[imagePath stringByExpandingTildeInPath] atomically:YES];
}

- (IBAction)moveWindow:(id)sender{
    NSInteger tag = [sender tag];
    NSPoint windowPoint = self.window.frame.origin;
    if(tag == 0){
        windowPoint.y += 1.0f;
    }else if(tag == 1){
        windowPoint.y -= 1.0f;
    }else if(tag == 2){
        windowPoint.x -= 1.0f;
    }else if(tag == 3){
        windowPoint.x += 1.0f;
    }
    [self.window setFrameOrigin:windowPoint];
}

- (IBAction)showPreferences:(id)sender{
    //[preferencesWindow makeKeyAndOrderFront:self];
    [[PreferencesController sharedPrefsWindowController] showWindow:nil];
    (void)sender;
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem{
    SEL action = [anItem action];
    if(action == @selector(shoot:)){
        //TODO: if dribbble is authenticated enable this
        return NO;
    }
    return YES;
}

@end
