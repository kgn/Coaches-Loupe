//
//  DribbbleEngine.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/14/11.
//

#import "DribbbleEngine.h"
#import "TFHpple.h"

@implementation DBWebItem

@synthesize name;
@synthesize URL;

@end

@implementation DribbbleEngine

@synthesize username, password;
@synthesize _authenticationToken;
@synthesize delegate;

//find the authenticity_token from the login page
- (NSString *)authenticationToken{
    NSError *error;
    NSURLResponse *response;    
    NSString *token = nil;
    NSURL *loginURL = [NSURL URLWithString:@"http://dribbble.com/session/new"];
    NSURLRequest *request = [NSURLRequest requestWithURL:loginURL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    //get the authenticity_token input
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [xpathParser search:@"//div/form/div/input"];
    if(elements){
        TFHppleElement *element = [elements objectAtIndex:0];
        NSDictionary *attrinutes = [element attributes];
        //make sure we have the right node
        if([[attrinutes objectForKey:@"name"] isEqualToString:@"authenticity_token"]){
            token = [attrinutes objectForKey:@"value"];
        }
    }
    
    [xpathParser release];
    return token;
}

- (id)initWithDelegate:(id<DribbbleEngineDelegate>)aDelegate{
    if((self = [super init])){
        self.delegate = aDelegate;
        self._authenticationToken = nil;
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
        [self.delegate requestDidFailWithError:error connectionIdentifier:self._authenticationToken userInfo:userInfo];
    }
}

-(void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo{
    if([self isReady]){
        //TODO: Do this in another thread
        if(!self._authenticationToken){
            self._authenticationToken = [self authenticationToken];
        }
        NSLog(@"%@", self._authenticationToken);
        
        //Always error for now...
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
