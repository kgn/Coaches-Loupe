//
//  PreferencesController.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "PreferencesController.h"

@implementation PreferencesController

@synthesize cloudView;
@synthesize dribbbleView;

- (void)setupToolbar{
	[self addView:self.cloudView label:@"CloudApp" image:[NSImage imageNamed:@"cloud_toolbar.png"]];
    [self addView:self.dribbbleView label:@"Dribbble" image:[NSImage imageNamed:@"dribbble_toolbar.png"]];
	
	[self setShiftSlowsAnimation:YES];
    [self setCrossFade:YES];
}

+ (void)registerUserDefaults{
//    NSDictionary *userDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: 
//                                            nil];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
}

@end
