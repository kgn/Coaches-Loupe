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
    self.currentShotName = [self shotName];
    self.currentShotData = [self shotData];
    
    if(UserDefaultDribbbleAddInfoValue){
        [self showDribbbleInfoCourtWithAnimationWithName:[self.currentShotName stringByDeletingPathExtension]];
    }else{
        [self publishToDribbble:nil];
    }
}

- (IBAction)publishToDribbble:(id)sender{
    dribbbleUploadImage = [NSImage imageNamed:@"dribbble_upload.png"];
    
    //if sender is not nil then this call was made from the publish button
    [self showUploadCourtWithAnimation:(sender == nil) withImage:dribbbleUploadImage];
    
    NSString *name = [self.currentShotName stringByDeletingPathExtension];
    NSString *tagsString = UserDefaultDribbbleDefaultTagsValue;
    NSString *comment = nil;
    if(sender != nil){
        name = self.dribbblePublishName.stringValue;
        comment = self.dribbblePublishComment.stringValue;
        tagsString = self.dribbblePublishTags.stringValue;
    }
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[tagsString componentsSeparatedByString:@","]];
    if(UserDefaultDribbbleCoachesLoupeTagValue){
        [tags addObject:AppName];
    }
    
    [self.dribbble shootImageNamed:self.currentShotName 
                          withData:self.currentShotData
                              name:name
                              tags:tags
            andIntroductoryComment:comment];
    
    self.currentShotName = nil;
    self.currentShotData = nil;
}

- (void)dribbbleRequestDidFailWithError:(NSError *)error authenticityToken:(NSString *)authenticityToken shotInfo:(NSDictionary *)shotInfo{
    [self showFailedCourtWithError:error];
    self.isUploading = NO;
}

- (void)dribbbleShotUploadDidSucceedWithResultingShot:(BBBPShot *)shot authenticityToken:(NSString *)authenticityToken shotInfo:(NSDictionary *)shotInfo{
    [self screenshotUploadedWithName:shot.name 
                               toURL:shot.URL 
                        withShortURL:shot.shortURL 
                           forAction:@"Screenshot dribbbled"];
    self.isUploading = NO;
}

@end
