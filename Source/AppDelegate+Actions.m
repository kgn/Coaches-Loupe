//
//  AppDelegate+Actions.m
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

- (IBAction)moveWindow:(id)sender{
    NSInteger mode = 10;
    NSInteger tag = [sender tag];
    NSInteger modeTag = tag%mode;
    
    CGFloat move = 1.0f;
    if(tag >= mode){
        move = 10.0f;
    }
    
    NSPoint windowPoint = self.window.frame.origin;
    if(modeTag == 0){
        windowPoint.y += move;
    }else if(modeTag == 1){
        windowPoint.y -= move;
    }else if(modeTag == 2){
        windowPoint.x -= move;
    }else if(modeTag == 3){
        windowPoint.x += move;
    }
    
    windowPoint = [AppDelegate clampLoupePointToScreen:windowPoint];
    [self.window setFrameOrigin:windowPoint];
}

- (IBAction)showPreferences:(id)sender{
    [[PreferencesController sharedPrefsWindowController] showWindow:nil];
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem{
    SEL action = [anItem action];
    if(action == @selector(shoot:)){
        return self.canUploadToDribbble;
    }else if(action == @selector(precipitate:)){
        return self.canUploadToCloudApp;
    }
    return YES;
}

@end
