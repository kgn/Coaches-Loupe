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

- (IBAction)showPreferences:(id)sender{
    [[PreferencesController sharedPrefsWindowController] showWindow:nil];
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem{
    SEL action = [anItem action];
    if(action == @selector(shoot:)){
        return self.canUploadToDribbble && !self.isUploading;
    }else if(action == @selector(precipitate:)){
        return self.canUploadToCloudApp && !self.isUploading;
    }else if(action == @selector(save:)){
        return !self.isUploading;
    }
    return YES;
}

@end
