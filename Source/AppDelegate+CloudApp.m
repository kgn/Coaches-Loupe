//
//  AppDelegate+CloudApp.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AppDelegate.h"

static NSImage *cloupUploadImage = nil;

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
    cloupUploadImage = [NSImage imageNamed:@"cloud_upload.png"];
    [self showUploadCourtWithAnimationWithImage:cloupUploadImage];
	[self.cloudApp uploadFileWithName:[self shotName] fileData:[self shotData] userInfo:nil];
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self showFailedCourtWithError:error];
}

- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self screenshotUploadedWithName:item.name toURL:item.URL forAction:@"Screenshot precipitated"];
}

@end
