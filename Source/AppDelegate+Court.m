//
//  AppDelegate+Court.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/13/11.
//

#import "AppDelegate.h"

#define fadeInDuration 0.25f

@implementation AppDelegate (Court)

- (void)setupCourts{
    [[self.uploadViewLabel cell] setBackgroundStyle:NSBackgroundStyleLowered];    
    [self.uploadView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    [[self.failedViewBigLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [[self.failedViewSmallLabel cell] setBackgroundStyle:NSBackgroundStyleLowered]; 
    [self.failedView setFrameOrigin:NSMakePoint(frameThinOffset, frameThickOffset)];
    [[self.failedViewButton cell] setBackgroundStyle:NSBackgroundStyleLowered];
}

- (void)showUploadCourtWithAnimation:(BOOL)animation{
    self.uploadViewLabel.stringValue = @"Uploading...";
    if(animation){
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:fadeInDuration];
        [(NSView *)[self.uploadView animator] setAlphaValue:1.0f];
        [NSAnimationContext endGrouping];
    }else{
        [self.uploadView setAlphaValue:1.0f];
    }
}

- (void)showUploadCourtWithAnimation{
    [self showUploadCourtWithAnimation:YES];
}

- (void)hideUploadCourtWithAnimation:(BOOL)animation{
    if(animation){
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:fadeInDuration];
        [(NSView *)[self.uploadView animator] setAlphaValue:0.0f];
        [NSAnimationContext endGrouping];  
    }else{
        [self.uploadView setAlphaValue:0.0f];
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
    [self hideUploadCourtWithAnimation:NO];
    self.failedViewSmallLabel.stringValue = [error localizedDescription];
    [self.failedView setAlphaValue:1.0f];
}

- (IBAction)hideFailedCourt:(id)sender{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:fadeInDuration];
    [(NSView *)[self.failedView animator] setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];
}

@end
