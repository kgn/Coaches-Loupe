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
#define UserDefaultGrowlValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultGrowlKey]

#define UserDefaultCopyToClipboardKey @"copyToClipboard"
#define UserDefaultCopyToClipboardValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCopyToClipboardKey]

#define UserDefaultDribbbleUserKey @"dribbbleUser"
#define UserDefaultDribbbleUserValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDribbbleUserKey]

#define UserDefaultCloudUserKey @"cloudUser"
#define UserDefaultCloudUserValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCloudUserKey]

@interface PreferencesController : DBPrefsWindowController {
    NSView *cloudView;
    NSView *dribbbleView;
    NSSecureTextField *cloudPassword;
    NSSecureTextField *dribbblePassword;
    NSView *generalView;
    NSView *updatesView;
    NSArray *sounds;
}

@property (assign) IBOutlet NSView *cloudView;
@property (assign) IBOutlet NSView *dribbbleView;
@property (assign) IBOutlet NSSecureTextField *cloudPassword;
@property (assign) IBOutlet NSSecureTextField *dribbblePassword;
@property (assign) IBOutlet NSView *generalView;
@property (assign) IBOutlet NSView *updatesView;

@property (nonatomic, retain) NSArray *sounds;

+ (void)registerUserDefaults;

- (IBAction)dribbblePasswordChanged:(id)sender;
- (IBAction)cloudAppPasswordChanged:(id)sender;
- (IBAction)changePlaySound:(id)sender;

@end
