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
    self.isUploading = YES;
    self.currentShotName = [self shotName];
    self.currentShotData = [self shotData];
    
    if(UserDefaultCloudAddInfoValue){
        [self showCloudInfoCourtWithAnimationWithName:self.currentShotName];
    }else{
        [self publishToCloud:nil];
    }
}

- (IBAction)publishToCloud:(id)sender{
    cloupUploadImage = [NSImage imageNamed:@"cloud_upload.png"];
    
    //if sender is not nil then this call was made from the publish button
    [self showUploadCourtWithAnimation:(sender == nil) withImage:cloupUploadImage];
    
    self.cloudShotName = self.currentShotName;
    if(sender != nil){
        self.cloudShotName = self.cloudPublishName.stringValue;
    }   
    
    [self.cloudApp uploadFileWithName:self.currentShotName fileData:self.currentShotData userInfo:nil];
    
    self.currentShotName = nil;
    self.currentShotData = nil;
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    [self showFailedCourtWithError:error];
    self.isUploading = NO;
    self.cloudShotName = nil;
}

- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo{
    //rename the item
    if([self.cloudShotName length] > 0 && ![item.name isEqualToString:self.cloudShotName]){
        NSString *result = [self.cloudApp changeNameOfItem:item toName:self.cloudShotName userInfo:nil];
        if([result length] > 0){
            item.name = self.cloudShotName;
        }
    }
    
    [self screenshotUploadedWithName:item.name 
                               toURL:item.URL 
                        withShortURL:nil 
                           forAction:@"Screenshot precipitated"];
    
    self.isUploading = NO;
    self.cloudShotName = nil;
}

@end
