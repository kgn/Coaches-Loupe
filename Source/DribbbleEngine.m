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

- (NSString *)encode:(NSString *)aString{
    //Modified from: http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/Foundation/GTMNSString%2BURLArguments.m
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)aString,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return [(NSString *)escaped autorelease];
}

//Modified from: http://forums.macrumors.com/showthread.php?t=229602
- (NSString *)boundryString{
    char randoms[16];
    char aRandom = 0;
    for(int i = 0; i < 16; i++){
        while(YES){
            aRandom = (char)random() + 128;
            if(((aRandom >= '0') && (aRandom <= '9')) || ((aRandom >= 'a') && (aRandom <= 'z'))){
                randoms[i] = aRandom;
                break; // we found an alphanumeric character, move on
            }
        }
    }
    NSString *randString = [NSString stringWithUTF8String:randoms];
    //boundries lead with --
    return [NSString stringWithFormat:@"--%@----", randString];
}

- (NSString *)encodeArgs:(NSDictionary *)args{
    NSMutableArray *argsAndValues = [[NSMutableArray alloc] init];
    for(NSString *key in [args allKeys]){
        NSString *escapedKey = [self encode:key];
        NSString *value = [self encode:[args objectForKey:key]];
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
        
        NSData *body = [htmlBodyString dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
        
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
    NSError *error = nil;
    if([self login]){
        //Upload image
        NSString *newline = @"\r\n";
        NSString *boundry = [self boundryString];
        //boundries lead with --
        NSString *boundryHeader = [NSString stringWithFormat:@"--%@", boundry];
        NSURL *shotsURL = [NSURL URLWithString:@"http://dribbble.com/shots"];
        
        //build the authenticity_token section
        NSMutableArray *authenticityArray = [[NSMutableArray alloc] init];
        [authenticityArray addObject:boundryHeader];
        [authenticityArray addObject:@"Content-Disposition: form-data; name=\"authenticity_token\""];
        [authenticityArray addObject:@""];
        [authenticityArray addObject:self._authenticationToken];
        [authenticityArray addObject:@""];
        NSString *authenticityString = [authenticityArray componentsJoinedByString:newline];
        [authenticityArray release];
        
        //build the image section
        NSMutableArray *uploadArray = [[NSMutableArray alloc] init];
        [uploadArray addObject:boundryHeader];
        [uploadArray addObject:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"screenshot[file]\"; filename=\"%@\"", fileName]];
        [uploadArray addObject:@"Content-Type: image/png"];
        [uploadArray addObject:newline];
        NSString *uploadString = [uploadArray componentsJoinedByString:newline];
        [uploadArray release];        
        
        //add the sections to the body, then add the image data
        NSMutableData *body = [[NSMutableData alloc] init];
        [body appendData:[authenticityString dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[uploadString dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileData];
        
        //setup the request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:shotsURL 
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                                timeoutInterval:20.0f];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry] forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"http://dribbble.com/shots/new" forHTTPHeaderField:@"Referer"];
        [request setValue:@"http://dribbble.com" forHTTPHeaderField:@"Origin"];//is this needed
        [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:body];

        //is this needed
        NSURL *root = [NSURL URLWithString:@"http://dribbble.com"];
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:root];
        NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [request setAllHTTPHeaderFields:headers];
        
        NSError *uploadError = nil;
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&uploadError];
        
        //temp code to see the html we get back
        NSString *responceString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responceString);
        [responceString release];
        
        [body release];
        [request release];
        
        [self.delegate fileUploadDidSucceedWithResultingItem:nil connectionIdentifier:self._authenticationToken userInfo:userInfo];
    }else{
        error = [NSError errorWithDomain:@"DribbbleEngine" code:100 
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Login failed", NSLocalizedDescriptionKey, nil]];            
    }
    
    if(error){
        [self.delegate requestDidFailWithError:error connectionIdentifier:self._authenticationToken userInfo:userInfo];
    }
}

- (void)dealloc{
    delegate = nil;
    [super dealloc];
}

@end
