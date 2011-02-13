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
    
    if(UserDefaultPlaySoundValue){
        [[NSSound soundNamed:UserDefaultDoneSoundValue] play];
    }    
}

//TODO: it's anoying that the menu flashes when you use the hotkeys for this
//TODO: move 10px if shift is down
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
    [[PreferencesController sharedPrefsWindowController] showWindow:nil];
    (void)sender;
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem{
    SEL action = [anItem action];
    if(action == @selector(shoot:)){
        if(!self.canUploadToDribbble){
            return NO;
        }
    }else if(action == @selector(precipitate:)){
        if(!self.canUploadToCloudApp){
            return NO;
        }
    }
    return YES;
}

@end
