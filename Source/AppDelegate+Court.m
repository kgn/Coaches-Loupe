//
//  AppDelegate+Court.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/13/11.
//

#import "AppDelegate.h"

#define fadeInDuration 0.25f

@implementation AppDelegate (Court)

- (void)removeCourt:(NSView *)court{
    [court removeFromSuperview];
}

- (void)setupCourts{
    [[self.uploadViewLabel cell] setBackgroundStyle:NSBackgroundStyleLowered];    
    [self.uploadView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    [[self.failedViewBigLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.failedViewSmallLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [self.failedView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    [[self.failedViewButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
}

- (void)fadeInUploadCourt{        
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSView *)[self.uploadView animator] setAlphaValue:1.0f];
    [NSAnimationContext endGrouping];
}

- (void)showUploadCourtWithAnimation:(BOOL)animation withImage:(NSImage *)image{
    [self.uploadView setAlphaValue:0.0f];
    self.uploadViewLabel.stringValue = @"Uploading...";
    self.uploadViewImage.image = image;
    [self.loupe addSubview:self.uploadView];
    if(animation){
        [self performSelector:@selector(fadeInUploadCourt) 
                   withObject:nil
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
        [self.uploadView setAlphaValue:0.0f];
        [self.uploadView removeFromSuperview];
    }    
}

- (void)hideUploadCourtWithAnimation{
    [self hideUploadCourtWithAnimation:YES];
}

- (void)doneWithUploadCourt{
    self.uploadViewLabel.stringValue = @"Done!";
    [self performSelector:@selector(hideUploadCourtWithAnimation) 
               withObject:nil 
               afterDelay:1.0f];
}

- (void)showFailedCourtWithError:(NSError *)error{
    [self.failedView setAlphaValue:1.0f];
    self.failedViewSmallLabel.stringValue = [error localizedDescription];
    [self.loupe addSubview:self.failedView];
    [self hideUploadCourtWithAnimation:NO];
}

- (IBAction)hideFailedCourt:(id)sender{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSView *)[self.failedView animator] setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];
    [self performSelector:@selector(removeCourt:) 
               withObject:self.failedView 
               afterDelay:fadeInDuration];
}

@end
