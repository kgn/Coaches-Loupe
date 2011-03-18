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
@synthesize twitterView;
@synthesize twitterPopup;

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

- (NSArray *)supportedTwitterClients{
    static NSArray *kSupportedTwitterClients = nil;
    if(!kSupportedTwitterClients){
        NSString *path = [[NSBundle mainBundle] pathForResource: @"TwitterClients" ofType: @"plist"];
        kSupportedTwitterClients = [[NSArray arrayWithContentsOfFile:path] retain];
    }
    return kSupportedTwitterClients;
}

- (void)awakeFromNib{
    self.cloudPassword.stringValue = [Keychain cloudPasswordForUser:UserDefaultCloudUserValue] ?: @"";
    self.dribbblePassword.stringValue = [Keychain dribbblePasswordForUser:UserDefaultDribbbleUserValue] ?: @"";    
    
    [self populateSounds];
    
    // update twitter popup
    // modified from Murky https://bitbucket.org/snej/murky/wiki/Home
    [self.twitterPopup removeAllItems];
    [self.twitterPopup addItemsWithTitles:[[self supportedTwitterClients] valueForKeyPath:@"@unionOfObjects.name"]];
    [self.twitterPopup setAutoenablesItems:NO];
    
    NSArray *twitterAppIds = [[self supportedTwitterClients] valueForKeyPath:@"@unionOfObjects.id"];
    for(NSString *appId in twitterAppIds){
        NSString *path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:appId];
        NSMenuItem *menuItem = [self.twitterPopup itemAtIndex:[twitterAppIds indexOfObject:appId]];
        NSImage *icon;
        if(path){
            icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
        }else{
            icon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericApplicationIcon)];
            [menuItem setEnabled:NO];
        }
        [icon setSize:NSMakeSize(16, 16)];
        [menuItem setImage:icon];
    }
    
    NSArray *twitterAppURLs = [[self supportedTwitterClients] valueForKeyPath:@"@unionOfObjects.url"];
    NSInteger selectedItemIndex = [twitterAppURLs indexOfObject:UserDefaultTwitterAppURLValue];
    if(selectedItemIndex == NSNotFound){
        selectedItemIndex = 0;       
    }
    [self.twitterPopup selectItemAtIndex:selectedItemIndex];
}

- (void)setupToolbar{
    [self addView:self.generalView label:@"General" image:[NSImage imageNamed:@"switch_toolbar.png"]];
	[self addView:self.cloudView label:@"CloudApp" image:[NSImage imageNamed:@"cloud_toolbar.png"]];
    [self addView:self.dribbbleView label:@"Dribbble" image:[NSImage imageNamed:@"dribbble_toolbar.png"]];
    [self addView:self.twitterView label:@"Twitter" image:[NSImage imageNamed:@"twitter_toolbar.png"]];
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

- (IBAction)selectTwitterApp:(id)sender{
    NSInteger selectedIndex = [self.twitterPopup indexOfSelectedItem];
    NSString *appUrl = [[[self supportedTwitterClients] valueForKeyPath:@"@unionOfObjects.url"] objectAtIndex:selectedIndex];
    [[NSUserDefaults standardUserDefaults] setObject:appUrl forKey:UserDefaultTwitterAppURLKey];
}

+ (void)registerUserDefaults{
    NSString *defaultTwitterAppURL = UserDefaultTwitterAppURLValue;
    //find the first twitter app that's installed
    if(!UserDefaultTwitterAppURLValue){
        NSString *path = [[NSBundle mainBundle] pathForResource: @"TwitterClients" ofType: @"plist"];
        for(NSDictionary *appDict in [NSArray arrayWithContentsOfFile:path]){
            NSString *appId = [appDict objectForKey:@"id"];
            if([[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:appId]){
                defaultTwitterAppURL =  [appDict objectForKey:@"url"];
                break;
            }        
        }       
    }  
    
    NSDictionary *userDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"Glass", UserDefaultDoneSoundKey, 
                                            [NSNumber numberWithBool:YES], UserDefaultPlaySoundKey,
                                            [NSNumber numberWithBool:YES], UserDefaultGrowlKey,
                                            [NSNumber numberWithBool:YES], UserDefaultCopyToClipboardKey,
                                            [NSNumber numberWithBool:YES], UserDefaultDribbbleAddInfoKey,
                                            [NSNumber numberWithBool:YES], UserDefaultCloudAddInfoKey,
                                            [NSNumber numberWithBool:YES], UserDefaultDribbbleCoachesLoupeTag,
                                            defaultTwitterAppURL, UserDefaultTwitterAppURLKey,
                                            [NSNumber numberWithFloat:100.0f], UserDefaultWindowTransparencyKey,
                                            nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
}

@end
