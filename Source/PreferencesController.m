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
@synthesize cloudPassword;
@synthesize generalView;

@synthesize sounds;

- (void)populateSounds{
    self.sounds = nil;
    NSError *error = nil;
    NSArray *dirContents = [[[NSFileManager defaultManager] 
                             contentsOfDirectoryAtPath:@"/System/Library/Sounds" error:&error] 
                            sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if(error != nil){
        [[NSAlert alertWithError:error] runModal];
    }else{
        NSMutableArray *soundList = [[NSMutableArray alloc] init];
        NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
        for(NSString *fileItem in dirContents){
            if([[fileItem pathExtension] isEqualTo:@"aiff"]){
                [soundList addObject:[fileItem stringByDeletingPathExtension]];
            }
        }
        [pool drain];
        
        self.sounds = soundList;
        [soundList release];
    }
}

- (void)awakeFromNib{
    NSString *username = UserDefaultCloudUserValue;
    self.cloudPassword.stringValue = [Keychain cloudPasswordForUser:username];
    
    [self populateSounds];
}

- (void)setupToolbar{
    [self addView:self.generalView label:@"General" image:[NSImage imageNamed:@"switch_toolbar.png"]];
	[self addView:self.cloudView label:@"CloudApp" image:[NSImage imageNamed:@"cloud_toolbar.png"]];
    [self addView:self.dribbbleView label:@"Dribbble" image:[NSImage imageNamed:@"dribbble_toolbar.png"]];
	
	[self setShiftSlowsAnimation:YES];
    [self setCrossFade:YES];
}

- (IBAction)cloudAppPasswordChanged:(id)sender{
    NSNotification *notification = [NSNotification notificationWithName:CloudAppPasswordChangeNotification 
                                                                 object:[sender stringValue]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)changePlaySound:(id)sender{
    [[NSSound soundNamed:UserDefaultDoneSoundValue] play];
}

+ (void)registerUserDefaults{
    NSDictionary *userDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"Glass", UserDefaultDoneSoundKey, 
                                            [NSNumber numberWithBool:YES], UserDefaultPlaySoundKey,
                                            [NSNumber numberWithBool:YES], UserDefaultGrowlKey,
                                            nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
}

@end
