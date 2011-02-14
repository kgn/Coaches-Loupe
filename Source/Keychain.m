//
//  Keychain.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "Keychain.h"

#define KeychainItem [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
#define DribbbleKeychainKind @"Dribbble Password"
#define CloudAppKeychainKind @"CloudApp Password"

@implementation Keychain

+ (NSString *)passwordForUser:(NSString *)username forItem:(NSString *)item ofKind:(NSString *)kind{
    if([AGKeychain checkForExistanceOfKeychainItem:item withItemKind:kind forUsername:username]){
        return [AGKeychain getPasswordFromKeychainItem:item withItemKind:kind forUsername:username];
    }
    return nil;
}

+ (void)setPassword:(NSString *)password forUser:(NSString *)username forItem:(NSString *)item ofKind:(NSString *)kind{
    if(password && username){
        //if an entry exists remove it
        if([AGKeychain checkForExistanceOfKeychainItem:item withItemKind:kind forUsername:username]){
            [AGKeychain deleteKeychainItem:item withItemKind:kind forUsername:username];
        }
        [AGKeychain addKeychainItem:item withItemKind:kind forUsername:username withPassword:password];
    }    
}

#pragma -
#pragma dribbble

+ (NSString *)dribbblePasswordForUser:(NSString *)username{
    return [Keychain passwordForUser:username forItem:KeychainItem ofKind:DribbbleKeychainKind];
}

+ (void)setDribbblePassword:(NSString *)password forUser:(NSString *)username{
    [Keychain setPassword:password forUser:username forItem:KeychainItem ofKind:DribbbleKeychainKind];
}

#pragma -
#pragma CloudApp

+ (NSString *)cloudPasswordForUser:(NSString *)username{
    return [Keychain passwordForUser:username forItem:KeychainItem ofKind:CloudAppKeychainKind];
}

+ (void)setCloudPassword:(NSString *)password forUser:(NSString *)username{
    [Keychain setPassword:password forUser:username forItem:KeychainItem ofKind:CloudAppKeychainKind];
}

@end
