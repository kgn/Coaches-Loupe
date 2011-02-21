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
    NSString *imageName = [self shotName];
    //TODO: get values from fields
    [self.dribbble shootImageNamed:imageName 
                          withData:[self shotData] 
                              name:[imageName stringByDeletingPathExtension] 
                              tags:nil 
            andIntroductoryComment:nil];
}

- (void)dribbbleRequestDidFailWithError:(NSError *)error authenticationToken:(NSString *)authenticationToken shotInfo:(NSDictionary *)shotInfo{
    [self showFailedCourtWithError:error];
    self.isUploading = NO;
}

- (void)dribbbleShotUploadDidSucceedWithResultingShot:(BBBPShot *)shot authenticationToken:(NSString *)authenticationToken shotInfo:(NSDictionary *)shotInfo{
    [self screenshotUploadedWithName:shot.name toURL:shot.URL withShortURL:shot.shortURL forAction:@"Screenshot dribbbled"];
    self.isUploading = NO;
}

@end
