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
@synthesize _isLoggedin;
@synthesize delegate;

- (NSString *)encodeArgs:(NSDictionary *)args{
    NSMutableArray *argsAndValues = [[NSMutableArray alloc] init];
    for(NSString *key in [args allKeys]){
        NSString *escapedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[args objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [argsAndValues addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, value]];
    }
    NSString *argsAndValuesString = [argsAndValues componentsJoinedByString:@"&"];
    [argsAndValues release];
    NSLog(@"args: %@", argsAndValuesString);
    return argsAndValuesString;
}

//find the authenticity_token from the login page
- (NSString *)authenticationToken{
    NSError *error;
    NSURLResponse *response;    
    NSString *token = nil;
    NSURL *loginURL = [NSURL URLWithString:@"http://dribbble.com/session/new"];
    NSURLRequest *request = [NSURLRequest requestWithURL:loginURL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:20.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    //get the authenticity_token input
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [xpathParser search:@"//div/form/div/input"];
    if(elements && [elements count] > 0){
        TFHppleElement *element = [elements objectAtIndex:0];
        NSDictionary *attrinutes = [element attributes];
        //make sure we have the right node
        if([[attrinutes objectForKey:@"name"] isEqualToString:@"authenticity_token"]){
            token = [attrinutes objectForKey:@"value"];
            NSLog(@"token: %@", [attrinutes objectForKey:@"value"]);
        }
    }
    
    [xpathParser release];
    return token;
}

- (BOOL)login{
    if(![self isReady]){
        self._isLoggedin = NO;
        self._authenticationToken = nil;
    }
    if(!self._isLoggedin){
        self._authenticationToken = [self authenticationToken];
        
        NSURL *sessionURL = [NSURL URLWithString:@"http://dribbble.com/session"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:sessionURL 
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                                timeoutInterval:20.0f]; 
        [request setHTTPMethod:@"POST"];
        NSString *htmlBodyString = [self encodeArgs:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     self._authenticationToken, @"authenticity_token", 
                                                     self.username, @"login",
                                                     self.password, @"password",
                                                     nil]];
        
        NSData *htmlBodyData = [htmlBodyString dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[NSString stringWithFormat:@"%d", [htmlBodyData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:htmlBodyData];
        
        NSError *error = nil;
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        [request release];
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
        NSArray *elements  = [xpathParser search:@"//title"];
        if(elements && [elements count] > 0){
            TFHppleElement *element = [elements objectAtIndex:0];
            NSLog(@"%@", [element content]);
            self._isLoggedin = [[element content] isEqualToString:@"Dribbble - What are you working on?"];
        }
        
        [xpathParser release];
    }
    return self._isLoggedin;
}

#pragma -
#pragma Public

- (void)setUsername:(NSString *)newUsername{
    if(![self.username isEqualToString:newUsername]){
        [username autorelease];
        username = [newUsername retain];
        self._isLoggedin = NO;
    }
}

- (void)setPassword:(NSString *)newPassword{
    if(![self.password isEqualToString:newPassword]){
        [password autorelease];
        password = [newPassword retain];
        self._isLoggedin = NO;
    }
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

-(void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo{
    if([self login]){
        [self.delegate fileUploadDidSucceedWithResultingItem:nil connectionIdentifier:self._authenticationToken userInfo:userInfo];
    }else{
        NSError *error = [NSError errorWithDomain:@"DribbbleEngine" code:100 
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"Login failed", NSLocalizedDescriptionKey, nil]];
        [self.delegate requestDidFailWithError:error connectionIdentifier:self._authenticationToken userInfo:userInfo];            
    }
}

- (void)dealloc{
    delegate = nil;
    [super dealloc];
}

@end
