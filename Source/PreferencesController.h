//
//  PreferencesController.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "Keychain.h"
#import "DBPrefsWindowController.h"

#define CloudAppPasswordChangeNotification @"CloudAppPasswordChangeNotification"

#define UserDefaultPlaySoundKey @"playSound"
#define UserDefaultPlaySoundValue [[[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultPlaySoundKey] boolValue]

#define UserDefaultDoneSoundKey @"doneSound"
#define UserDefaultDoneSoundValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultDoneSoundKey]

#define UserDefaultCloudUserKey @"cloudUser"
#define UserDefaultCloudUserValue [[NSUserDefaults standardUserDefaults] valueForKey:UserDefaultCloudUserKey]

@interface PreferencesController : DBPrefsWindowController {
    NSView *cloudView;
    NSView *dribbbleView;
    NSSecureTextField *cloudPassword;
    NSView *generalView;
    NSArray *sounds;
}

@property (assign) IBOutlet NSView *cloudView;
@property (assign) IBOutlet NSView *dribbbleView;
@property (assign) IBOutlet NSSecureTextField *cloudPassword;
@property (assign) IBOutlet NSView *generalView;

@property (nonatomic, retain) NSArray *sounds;

+ (void)registerUserDefaults;

- (IBAction)cloudAppPasswordChanged:(id)sender;
- (IBAction)changePlaySound:(id)sender;

@end
