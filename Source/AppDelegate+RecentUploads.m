//
//  AppDelegate+RecentUploads.m
//  Coaches Loupe
//
//  Created by David Keegan on 5/31/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (RecentUploads)

- (void)openRecentUpload:(id)sender{
    NSURL *url = [NSURL URLWithString:[sender title]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)clearRecentUploads:(id)sender{
    [PreferencesController clearRecentUploads];
    [self rebuildRecentUploadMenu];
}

- (void)rebuildRecentUploadMenu{
    [self.recentUploadMenu removeAllItems];
    NSArray *recentUploads = UserDefaultRecentUploadsValue;
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
    for(NSUInteger i = 0; i < [recentUploads count]; ++i){
        NSMenuItem *item = [[NSMenuItem alloc] 
                            initWithTitle:[recentUploads objectAtIndex:i] 
                            action:@selector(openRecentUpload:) 
                            keyEquivalent:@""];
        [item setTarget:self];
        [self.recentUploadMenu addItem:item];
        [item release];
    }
    [pool drain];
    
    if([recentUploads count]){
        [self.recentUploadMenu addItem:[NSMenuItem separatorItem]];
        NSMenuItem *item = [[NSMenuItem alloc] 
                            initWithTitle:@"Clear Menu" 
                            action:@selector(clearRecentUploads:) 
                            keyEquivalent:@""];
        [item setTarget:self];
        [self.recentUploadMenu addItem:item];
        [item release];        
    }else{
        NSMenuItem *item = [[NSMenuItem alloc] 
                            initWithTitle:@"Clear Menu" 
                            action:nil
                            keyEquivalent:@""];
        [self.recentUploadMenu addItem:item];
        [item release];         
    }
}

@end
