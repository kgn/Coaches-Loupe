//
//  AppDelegate+Growl.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/15/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (Growl)

- (NSDictionary *)registrationDictionaryForGrowl{
    NSArray *notificationArray = [NSArray arrayWithObject:AppName];
    NSDictionary *notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      notificationArray, GROWL_NOTIFICATIONS_ALL,
                                      notificationArray, GROWL_NOTIFICATIONS_DEFAULT,
                                      nil];
    return notificationDict;
}

-(void)growlNotificationWasClicked:(id)context{
    if([context isKindOfClass:[NSString class]]){
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:context]];
    }
}

@end
