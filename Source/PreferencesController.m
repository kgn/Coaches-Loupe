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
@synthesize dribbblePassword;
@synthesize generalView;
@synthesize updatesView;

@synthesize sounds;

- (void)populateSounds{
    self.sounds = nil;
    NSError *error = nil;
    NSArray *dirContents = [[[NSFileManager defaultManager] 
                             contentsOfDirectoryAtPath:@"/System/Library/Sounds" error:&error] 
                            sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if(error){
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
    self.cloudPassword.stringValue = [Keychain cloudPasswordForUser:UserDefaultCloudUserValue] ?: @"";
    self.dribbblePassword.stringValue = [Keychain dribbblePasswordForUser:UserDefaultDribbbleUserValue] ?: @"";    
    
    [self populateSounds];
}

- (void)setupToolbar{
    [self addView:self.generalView label:@"General" image:[NSImage imageNamed:@"switch_toolbar.png"]];
	[self addView:self.cloudView label:@"CloudApp" image:[NSImage imageNamed:@"cloud_toolbar.png"]];
    [self addView:self.dribbbleView label:@"Dribbble" image:[NSImage imageNamed:@"dribbble_toolbar.png"]];
    [self addView:self.updatesView label:@"Updates" image:[NSImage imageNamed:@"updates_toolbar.png"]];
	
	[self setShiftSlowsAnimation:YES];
    [self setCrossFade:YES];
}

- (IBAction)dribbblePasswordChanged:(id)sender{
    NSNotification *notification = [NSNotification notificationWithName:DribbblePasswordChangeNotification 
                                                                 object:[sender stringValue]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
                                            [NSNumber numberWithBool:YES], UserDefaultCopyToClipboardKey,
                                            [NSNumber numberWithBool:YES], UserDefaultDribbbleAddInfoKey,
                                            [NSNumber numberWithBool:YES], UserDefaultCloudAddInfoKey,
                                            nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
}

@end
