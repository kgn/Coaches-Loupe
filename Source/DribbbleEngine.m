//
//  DribbbleEngine.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/14/11.
//

#import "DribbbleEngine.h"

@implementation DribbbleEngine

@synthesize username, password;
@synthesize authenticationToken;
@synthesize delegate;

- (id)initWithDelegate:(id<DribbbleEngineDelegate>)aDelegate{
    if((self = [super init])){
        self.delegate = aDelegate;
        self.authenticationToken = nil;
    }
    return self;
}

+ (id)engine{
	return [[[[self class] alloc] init] autorelease];
}

+ (id)engineWithDelegate:(id<DribbbleEngineDelegate>)aDelegate{
	return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (BOOL)isReady{
	return self.username != nil && [self.username length] > 0 && self.password != nil && [self.password length] > 0;
}

//STUB: artificial wait to simulate uploading with an error
- (void)placeholderFailWithUserInfo:(id)userInfo{
    if([self.delegate respondsToSelector:@selector(requestDidFailWithError:connectionIdentifier:userInfo:)]){
        NSError *error = [NSError errorWithDomain:@"DribbbleEngine" 
                                             code:100 
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"Uploading to dribbble is not yet supported.", 
                                                   NSLocalizedDescriptionKey,
                                                   nil]];
        [self.delegate requestDidFailWithError:error connectionIdentifier:self.authenticationToken userInfo:userInfo];
    }
}

-(void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo{
    if([self isReady]){
        [self performSelector:@selector(placeholderFailWithUserInfo:) 
                   withObject:userInfo 
                   afterDelay:1.0f];
    }
}

- (void)dealloc{
    delegate = nil;
    [super dealloc];
}

@end
