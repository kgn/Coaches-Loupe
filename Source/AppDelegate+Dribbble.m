//
//  AppDelegate+Dribbble.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AppDelegate.h"

static NSImage *dribbbleUploadImage = nil;

@implementation AppDelegate (Dribbble)

- (void)setupDribbble{
    self.dribbble.username = UserDefaultDribbbleUserValue;
    self.dribbble.password = [Keychain dribbblePasswordForUser:self.dribbble.username];
    //self.dribbble.clearsCookies = YES;
    self.canUploadToDribbble = [self.dribbble isReady];
}

- (void)changeDribbblePassword:(NSNotification *)aNoficication{
    NSString *password = aNoficication.object;
    [Keychain setDribbblePassword:password forUser:self.dribbble.username];
    [self setupDribbble];
}

- (IBAction)shoot:(id)sender{
    dribbbleUploadImage = [NSImage imageNamed:@"dribbble_upload.png"];
    [self showUploadCourtWithAnimationWithImage:dribbbleUploadImage];
	[self.dribbble uploadFileWithName:[self shotName] fileData:[self shotData] userInfo:nil];
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self showFailedCourtWithError:error];
}

@end
