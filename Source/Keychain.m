//
//  Keychain.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "Keychain.h"

#define CloudAppKeychainItem @"LoupeCloudApp"
#define CloudAppKeychainKind @"LoupeCloudAppPassword"

@implementation Keychain

+ (NSString *)cloudPasswordForUser:(NSString *)username{
    BOOL doesItemExisit = [AGKeychain checkForExistanceOfKeychainItem:CloudAppKeychainItem
                                                         withItemKind:CloudAppKeychainKind
                                                          forUsername:username];
    if(doesItemExisit){
        return [AGKeychain getPasswordFromKeychainItem:CloudAppKeychainItem
                                          withItemKind:CloudAppKeychainKind
                                           forUsername:username];
    }
    return nil;
}

+ (void)setCloudPassword:(NSString *)password forUser:(NSString *)username{
    if(password && username){
        BOOL doesItemExisit = [AGKeychain checkForExistanceOfKeychainItem:CloudAppKeychainItem
                                                             withItemKind:CloudAppKeychainKind
                                                              forUsername:username];
        if(doesItemExisit){
            [AGKeychain deleteKeychainItem:CloudAppKeychainItem
                              withItemKind:CloudAppKeychainKind
                               forUsername:username];
        }
        
        BOOL result = [AGKeychain addKeychainItem:CloudAppKeychainItem
                                     withItemKind:CloudAppKeychainKind
                                      forUsername:username
                                     withPassword:password];
        if(result){
            NSLog(@"Stored password");
        }else{
            NSLog(@"Stored NOT password");
        }
    }    
}

@end
