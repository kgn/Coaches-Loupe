//
//  BBBPDribbble.h
//  BBBouncePass
//
//  Created by David Keegan on 2/20/11.
//

#import "BBBPShot.h"

@interface BBBPDribbble : NSObject {}

//Get the authenticity token required for all actions.
+ (NSString *)authenticityToken;

//Log a user into dribbble, if NO is returned the login failed.
+ (BOOL)loginWithUsername:(NSString *)username 
                 password:(NSString *)password 
     andAuthenticityToken:(NSString *)authenticityToken;

//Upload an image to dribbble, the image is not published.
//Returns the shot path, if nil is returned the upload failed.
+ (NSString *)uploadImageWithName:(NSString *)imageName 
                          andData:(NSData *)imageData 
            withAuthenticityToken:(NSString *)authenticityToken;

//Publish a shot with a name, tags and introductory comment.
//Pass nil to any field you do not wish to set.
//Return an object that contains information about the shot,
//if nil is returned the publish failed.
+ (BBBPShot *)publishShotAtPath:(NSString *)shotPath 
                           name:(NSString *)name 
                           tags:(NSArray *)tags 
            introductoryComment:(NSString *)introductoryComment 
          withAuthenticityToken:(NSString *)authenticityToken;


//Shorthand function that uploads an image and publishes it.
+ (BBBPShot *)shootImageWithName:(NSString *)imageName 
                         andData:(NSData *)imageData 
                            name:(NSString *)name 
                            tags:(NSArray *)tags 
             introductoryComment:(NSString *)introductoryComment 
           withAuthenticityToken:(NSString *)authenticityToken;

@end
