//
//  AppDelegate+Court.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/13/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Court)

- (void)removeCourt:(NSView *)court{
    [court setAlphaValue:0.0f];
    [court removeFromSuperview];
}

- (void)setupCourts{
    [[self.uploadViewLabel cell] setBackgroundStyle:NSBackgroundStyleLowered];    
    [self.uploadView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    
    [[self.dribbblePublishName cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.dribbblePublishTags cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.dribbblePublishComment cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.dribbblePublishButton cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.dribbbleCancelButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
    [self.dribbblePublishView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    
    [[self.cloudPublishName cell] setBackgroundStyle:NSBackgroundStyleLowered];
    [[self.cloudPublishButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
    [[self.cloudCancelButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
    [self.cloudPublishView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    
    [[self.failedViewBigLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.failedViewSmallLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [self.failedView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    [[self.failedViewButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
}

- (void)fadeInCourt:(NSView *)court{        
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSView *)[court animator] setAlphaValue:1.0f];
    [NSAnimationContext endGrouping];
}

- (void)fadeOutCourt:(NSView *)court{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSView *)[court animator] setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];
}

#pragma -
#pragma Upload

- (void)showUploadCourtWithAnimation:(BOOL)animation withImage:(NSImage *)image{
    [self hideDribbbleInfoCourtWithDelay:animation];
    [self hideCloudInfoCourtWithDelay:animation];
    
    self.uploadViewLabel.stringValue = @"Drivin' to the net...";
    self.uploadViewImage.image = image;
    self.failedViewImage.image = image;
    [self.loupe addSubview:self.uploadView];
    if(animation){
        //This is required for the animation to happen
        [self performSelector:@selector(fadeInCourt:) 
                   withObject:self.uploadView
                   afterDelay:0.0f];
    }else{
        [self.uploadView setAlphaValue:1.0f];
    }
}

- (void)showUploadCourtWithAnimationWithImage:(NSImage *)image{
    [self showUploadCourtWithAnimation:YES withImage:image];
}

- (void)hideUploadCourtWithAnimation:(BOOL)animation{
    if(animation){
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:fadeInDuration];
        [(NSView *)[self.uploadView animator] setAlphaValue:0.0f];
        [NSAnimationContext endGrouping];
        [self performSelector:@selector(removeCourt:) 
                   withObject:self.uploadView 
                   afterDelay:fadeInDuration];        
    }else{
        [self removeCourt:self.uploadView];
    }    
}

- (void)hideUploadCourtWithAnimation{
    [self hideUploadCourtWithAnimation:YES];
}

- (void)doneWithUploadCourt{
    self.uploadViewLabel.stringValue = @"Slam dunk!";
    [self performSelector:@selector(hideUploadCourtWithAnimation)
               withObject:nil 
               afterDelay:1.0f];
}

#pragma -
#pragma Dribbble

- (void)showDribbbleInfoCourtWithAnimation:(BOOL)animation withName:(NSString *)name{
    [self.dribbblePublishView setAlphaValue:0.0f];
    self.dribbblePublishName.stringValue = name;
    self.dribbblePublishTags.stringValue = UserDefaultDribbbleDefaultTagsValue ?: @"";
    self.dribbblePublishComment.stringValue = @"";
    self.dribbblePublishPreview.image = [[[NSImage alloc] initWithData:self.currentShotData] autorelease];
    [self.loupe addSubview:self.dribbblePublishView];
    if(animation){
        //This is required for the animation to happen
        [self performSelector:@selector(fadeInCourt:) 
                   withObject:self.dribbblePublishView
                   afterDelay:0.0f];
    }else{
        [self.dribbblePublishView setAlphaValue:1.0f];
    }
}

- (void)showDribbbleInfoCourtWithAnimationWithName:(NSString *)name{
    [self showDribbbleInfoCourtWithAnimation:YES withName:(NSString *)name];
}

- (void)hideDribbbleInfoCourtWithDelay:(BOOL)delay{
    if(delay){
        [self performSelector:@selector(removeCourt:) 
                   withObject:self.dribbblePublishView 
                   afterDelay:fadeInDuration];
    }else{
        [self removeCourt:self.dribbblePublishView];
    }
}

- (IBAction)cancelDribbbleUpload:(id)sender{
    [self fadeOutCourt:self.dribbblePublishView];
    [self performSelector:@selector(removeCourt:) 
               withObject:self.dribbblePublishView 
               afterDelay:fadeInDuration];
    self.isUploading = NO;
}

#pragma -
#pragma Cloud

- (void)showCloudInfoCourtWithAnimation:(BOOL)animation withName:(NSString *)name{
    [self.cloudPublishView setAlphaValue:0.0f];
    self.cloudPublishName.stringValue = name;
    self.cloudPublishPreview.image = [[[NSImage alloc] initWithData:self.currentShotData] autorelease];
    [self.loupe addSubview:self.cloudPublishView];
    if(animation){
        //This is required for the animation to happen
        [self performSelector:@selector(fadeInCourt:) 
                   withObject:self.cloudPublishView
                   afterDelay:0.0f];
    }else{
        [self.cloudPublishView setAlphaValue:1.0f];
    }
}

- (void)showCloudInfoCourtWithAnimationWithName:(NSString *)name{
    [self showCloudInfoCourtWithAnimation:YES withName:(NSString *)name];
}

- (void)hideCloudInfoCourtWithDelay:(BOOL)delay{
    if(delay){
        [self performSelector:@selector(removeCourt:) 
                   withObject:self.cloudPublishView 
                   afterDelay:fadeInDuration];
    }else{
        [self removeCourt:self.cloudPublishView];
    }
}

- (IBAction)cancelCloudUpload:(id)sender{
    [self fadeOutCourt:self.cloudPublishView];
    [self performSelector:@selector(removeCourt:) 
               withObject:self.cloudPublishView 
               afterDelay:fadeInDuration];
    self.isUploading = NO;
}

#pragma -
#pragma Failed

- (void)showFailedCourtWithError:(NSError *)error{
    [self.failedView setAlphaValue:1.0f];
    if(error && [error respondsToSelector:@selector(localizedDescription)]){
        self.failedViewSmallLabel.stringValue = [error localizedDescription];
    }else{
        self.failedViewSmallLabel.stringValue = @"An unknown error occured.";
    }
    [self.loupe addSubview:self.failedView];
    [self hideUploadCourtWithAnimation:NO];
}

- (IBAction)hideFailedCourt:(id)sender{
    [self fadeOutCourt:self.failedView];
    [self performSelector:@selector(removeCourt:) 
               withObject:self.failedView 
               afterDelay:fadeInDuration];
    self.isUploading = NO;
}

@end
