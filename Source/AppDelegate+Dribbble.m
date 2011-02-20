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
    self.canUploadToDribbble = [self.dribbble isReady];
}

- (void)changeDribbblePassword:(NSNotification *)aNoficication{
    NSString *password = aNoficication.object;
    [Keychain setDribbblePassword:password forUser:self.dribbble.username];
    [self setupDribbble];
}

- (IBAction)shoot:(id)sender{
    self.isUploading = YES;
    dribbbleUploadImage = [NSImage imageNamed:@"dribbble_upload.png"];
    [self showUploadCourtWithAnimationWithImage:dribbbleUploadImage];
	[self.dribbble shootWithFileName:[self shotName] andData:[self shotData] withUserInfo:nil];
}

- (void)dribbbleRequestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self showFailedCourtWithError:error];
    self.isUploading = NO;
}

- (void)dribbbleShotUploadDidSucceedWithResultingItem:(DBWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self screenshotUploadedWithName:item.name toURL:item.URL withShortURL:item.shortURL forAction:@"Screenshot dribbbled"];
    self.isUploading = NO;
}

@end
