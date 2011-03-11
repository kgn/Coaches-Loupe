//
//  PreferencesController.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "Keychain.h"
#import "DBPrefsWindowController.h"

#define CloudAppPasswordChangeNotification @"CloudAppPasswordChangeNotification"
#define DribbblePasswordChangeNotification @"DribbblePasswordChangeNotification"

#define UserDefaultPlaySoundKey @"playSound"
#define UserDefaultPlaySoundValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultPlaySoundKey] boolValue]

#define UserDefaultDoneSoundKey @"doneSound"
#define UserDefaultDoneSoundValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDoneSoundKey]

#define UserDefaultGrowlKey @"useGrowl"
#define UserDefaultGrowlValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultGrowlKey] boolValue]

#define UserDefaultCopyToClipboardKey @"copyToClipboard"
#define UserDefaultCopyToClipboardValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCopyToClipboardKey] boolValue]

#define UserDefaultDribbbleUserKey @"dribbbleUser"
#define UserDefaultDribbbleUserValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDribbbleUserKey]

#define UserDefaultDribbbleAddInfoKey @"dribbbleAddInfo"
#define UserDefaultDribbbleAddInfoValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDribbbleAddInfoKey] boolValue]

#define UserDefaultDribbbleCoachesLoupeTag @"dribbbleCoachesLoupeTag"
#define UserDefaultDribbbleCoachesLoupeTagValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDribbbleCoachesLoupeTag] boolValue]

#define UserDefaultDribbbleDefaultTags @"dribbbleDefaultTags"
#define UserDefaultDribbbleDefaultTagsValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDribbbleDefaultTags]

#define UserDefaultCloudUserKey @"cloudUser"
#define UserDefaultCloudUserValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCloudUserKey]

#define UserDefaultCloudAddInfoKey @"cloudAddInfo"
#define UserDefaultCloudAddInfoValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCloudAddInfoKey] boolValue]

#define UserDefaultTweetShotKey @"tweetShot"
#define UserDefaultTweetShotValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultTweetShotKey] boolValue]

#define UserDefaultTwitterAppIdKey @"twitterAppId"
#define UserDefaultTwitterAppIdValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultTwitterAppIdKey]

@interface PreferencesController : DBPrefsWindowController {
    NSView *cloudView;
    NSView *dribbbleView;
    NSSecureTextField *cloudPassword;
    NSSecureTextField *dribbblePassword;
    NSView *generalView;
    NSView *updatesView;
    NSView *twitterView;
    NSPopUpButton *twitterPopup;
    NSArray *sounds;
}

@property (assign) IBOutlet NSView *cloudView;
@property (assign) IBOutlet NSView *dribbbleView;
@property (assign) IBOutlet NSSecureTextField *cloudPassword;
@property (assign) IBOutlet NSSecureTextField *dribbblePassword;
@property (assign) IBOutlet NSView *generalView;
@property (assign) IBOutlet NSView *updatesView;
@property (assign) IBOutlet NSView *twitterView;
@property (assign) IBOutlet NSPopUpButton *twitterPopup;

@property (nonatomic, retain) NSArray *sounds;

+ (void)registerUserDefaults;

- (IBAction)dribbblePasswordChanged:(id)sender;
- (IBAction)cloudAppPasswordChanged:(id)sender;
- (IBAction)changePlaySound:(id)sender;
- (IBAction)selectTwitterApp:(id)sender;

@end
