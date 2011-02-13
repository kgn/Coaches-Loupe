//
//  PreferencesController.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "DBPrefsWindowController.h"

@interface PreferencesController : DBPrefsWindowController {
    NSView *cloudView;
    NSView *dribbbleView;
}

@property (assign) IBOutlet NSView *cloudView;
@property (assign) IBOutlet NSView *dribbbleView;

+ (void)registerUserDefaults;

@end
