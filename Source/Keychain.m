//
//  Keychain.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "Keychain.h"

#define DribbbleKeychainItem @"LoupeDribbble"
#define DribbbleKeychainKind @"LoupeDribbblePassword"

#define CloudAppKeychainItem @"LoupeCloudApp"
#define CloudAppKeychainKind @"LoupeCloudAppPassword"

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
        
        if([AGKeychain addKeychainItem:item withItemKind:kind forUsername:username withPassword:password]){
            NSLog(@"Stored password");
        }else{
            NSLog(@"Stored NOT password");
        }
    }    
}

#pragma -
#pragma dribbble

+ (NSString *)dribbblePasswordForUser:(NSString *)username{
    return [Keychain passwordForUser:username forItem:DribbbleKeychainItem ofKind:DribbbleKeychainKind];
}

+ (void)setDribbblePassword:(NSString *)password forUser:(NSString *)username{
    [Keychain setPassword:password forUser:username forItem:DribbbleKeychainItem ofKind:DribbbleKeychainKind];
}

#pragma -
#pragma CloudApp

+ (NSString *)cloudPasswordForUser:(NSString *)username{
    return [Keychain passwordForUser:username forItem:CloudAppKeychainItem ofKind:CloudAppKeychainKind];
}

+ (void)setCloudPassword:(NSString *)password forUser:(NSString *)username{
    [Keychain setPassword:password forUser:username forItem:CloudAppKeychainItem ofKind:CloudAppKeychainKind];
}

@end
