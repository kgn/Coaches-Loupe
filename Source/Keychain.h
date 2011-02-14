//
//  Keychain.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AGKeychain.h"

@interface Keychain : NSObject {}

+ (NSString *)passwordForUser:(NSString *)username forItem:(NSString *)item ofKind:(NSString *)kind;
+ (void)setPassword:(NSString *)password forUser:(NSString *)username forItem:(NSString *)item ofKind:(NSString *)kind;

+ (NSString *)dribbblePasswordForUser:(NSString *)username;
+ (void)setDribbblePassword:(NSString *)password forUser:(NSString *)username;

+ (NSString *)cloudPasswordForUser:(NSString *)username;
+ (void)setCloudPassword:(NSString *)password forUser:(NSString *)username;

@end
