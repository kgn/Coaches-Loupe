//
//  Keychain.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AGKeychain.h"

@interface Keychain : NSObject {}

+ (NSString *)cloudPasswordForUser:(NSString *)username;
+ (void)setCloudPassword:(NSString *)password forUser:(NSString *)username;

@end
