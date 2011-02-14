//
//  AppDelegate+CloudApp.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (CloudApp)

- (void)setupCloudApp{
    self.cloudApp.email = UserDefaultCloudUserValue;
    self.cloudApp.password = [Keychain cloudPasswordForUser:self.cloudApp.email];
    self.cloudApp.clearsCookies = YES;
    self.canUploadToCloudApp = [self.cloudApp isReady];
}

- (void)changeCloudAppPassword:(NSNotification *)aNoficication{
    NSString *password = aNoficication.object;
    [Keychain setCloudPassword:password forUser:self.cloudApp.email];
    [self setupCloudApp];
}

- (IBAction)precipitate:(id)sender{
    [self showUploadCourtWithAnimation];
	[self.cloudApp uploadFileWithName:[self shotName] fileData:[self shotData] userInfo:nil];
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self showFailedCourtWithError:error];
}

- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self doneWithUploadCourt];
    
    //copy to pasteboard
    NSString *urlString = [item.URL absoluteString];
    NSString *htmlString = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", item.URL, item.name];    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSHTMLPboardType, NSPasteboardTypeString, nil] owner:nil];
    [pasteboard setString:htmlString forType:NSHTMLPboardType];
    [pasteboard setString:urlString forType:NSPasteboardTypeString];
    
    if(UserDefaultPlaySoundValue){
        [[NSSound soundNamed:UserDefaultDoneSoundValue] play];
    }
    
    if(UserDefaultGrowlValue){
        [GrowlApplicationBridge notifyWithTitle:@"Screenshot precipitated"
                                    description:urlString 
                               notificationName:AppName
                                       iconData:nil 
                                       priority:0 
                                       isSticky:NO 
                                   clickContext:urlString];
    }
}

@end
