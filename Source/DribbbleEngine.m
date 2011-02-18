//
//  DribbbleEngine.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/14/11.
//

#import "DribbbleEngine.h"
#import "TFHpple.h"

#define LoginError [NSError errorWithDomain:@"DribbbleEngine" code:100 \
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys: \
                    @"Login failed", NSLocalizedDescriptionKey, nil]];

#define UploadError [NSError errorWithDomain:@"DribbbleEngine" code:100 \
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys: \
                    @"Upload failed", NSLocalizedDescriptionKey, nil]];

@implementation DBWebItem

@synthesize name;
@synthesize URL;

@end

@implementation DribbbleEngine

@synthesize username, password;
@synthesize _authenticationToken;
@synthesize _isLoggedin;
@synthesize delegate;
@synthesize operationQueue;

#pragma -
#pragma url/http stuff

- (NSString *)boundryString{
    NSUInteger length = 16;
    NSString *characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    for(NSUInteger i = 0; i<length; ++i){
        NSUInteger randomIndex = arc4random() % [characters length];
        NSString *character = [characters substringWithRange:NSMakeRange(randomIndex, 1)];
        [randomString appendString:character];
    }
    
    //boundries lead with --
    NSString *boundryString = [NSString stringWithFormat:@"--%@%@----", BoundryPrefix, randomString];
    [randomString release];
    return boundryString;
}

- (NSString *)urlEncodeString:(NSString *)aString{
    //Modified from: http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/Foundation/GTMNSString%2BURLArguments.m
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)aString,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return [(NSString *)escaped autorelease];
}

- (NSString *)urlEncodeArgs:(NSDictionary *)args{
    NSMutableArray *argsAndValues = [[NSMutableArray alloc] init];
    for(NSString *key in [args allKeys]){
        NSString *escapedKey = [self urlEncodeString:key];
        NSString *value = [self urlEncodeString:[args objectForKey:key]];
        [argsAndValues addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, value]];
    }
    NSString *argsAndValuesString = [argsAndValues componentsJoinedByString:@"&"];
    [argsAndValues release];
    
    return argsAndValuesString;
}

#pragma -
#pragma dribbble

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
        NSDictionary *attributes = [element attributes];
        //make sure we have the right node
        if([[attributes objectForKey:@"name"] isEqualToString:@"authenticity_token"]){
            token = [attributes objectForKey:@"value"];
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
        NSString *htmlBodyString = [self urlEncodeArgs:[NSDictionary dictionaryWithObjectsAndKeys:
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
            //login succeeded
            if([[element content] isEqualToString:@"Dribbble - What are you working on?"]){
                self._isLoggedin = YES;
            }
        }
        [xpathParser release];
    }
    return self._isLoggedin;
}

- (NSString *)uploadImageWithFileName:(NSString *)fileName andData:(NSData *)fileData{
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
    [body appendData:[newline dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[boundryHeader dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];//Marks the end
    
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
    
    //make request
    NSError *uploadError = nil;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&uploadError];
    
    [body release];
    [request release];
    
    //check what we got back
    BOOL didUpload = YES;
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *titleElements  = [xpathParser search:@"//title"];
    if(titleElements && [titleElements count] > 0){
        NSString *title = [[titleElements objectAtIndex:0] content];
        if([title isEqualToString:@"Sorry, something went wrong and we're looking into it. (500)"]){
            didUpload = NO;
        }
    }else{
        didUpload = NO;
    }
    
    //find the shot url
    NSString *shotPath = nil;
    if(didUpload){
        NSArray *formElements  = [xpathParser search:@"//form"];
        if(formElements && [formElements count] > 0){
            for(TFHppleElement *element in formElements){
                NSDictionary *attributes = [element attributes]; 
                NSString *action = [attributes objectForKey:@"action"];
                //ignore search
                if(![action isEqualToString:@"/search"]){
                    shotPath = [attributes objectForKey:@"action"];
                    break;
                }
            }
        }
    }
    [xpathParser release];
    
    return shotPath;
}

-(void)synchronousShootWithData:(NSDictionary *)shotData{
    NSString *fileName = [shotData objectForKey:@"fileName"];
    NSData *fileData = [shotData objectForKey:@"fileData"];
    id userInfo = [shotData objectForKey:@"userInfo"];
    
    NSError *error = nil;
    if([self login]){
        NSString *shotPath = [self uploadImageWithFileName:fileName andData:fileData];
        if(shotPath){
            //publish shot
            NSString *shotURLString = [NSString stringWithFormat:@"http://dribbble.com%@", shotPath];
            NSURL *shotURL = [NSURL URLWithString:shotURLString];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:shotURL
                                                                        cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                                    timeoutInterval:20.0f]; 
            [request setHTTPMethod:@"POST"];
            
            NSString *bodyString = [self urlEncodeArgs:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"put", @"_method",
                                                        @"true", @"publish",
                                                        [fileName stringByDeletingPathExtension], @"screenshot[title]",
                                                        @"", @"screenshot[tag_list]",
                                                        @"", @"screenshot[introductory_comment_text]",
                                                        @"Publish", @"commit",
                                                        self._authenticationToken, @"authenticity_token", 
                                                        nil]];
            
            NSData *body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
            [request setValue:[NSString stringWithFormat:@"%@/edit", shotURL] forHTTPHeaderField:@"Referer"];            
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:body];
            
            NSError *publishError = nil;
            NSURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&publishError];
            [request release];
            
            BOOL didPublish = YES;
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            NSArray *titleElements  = [xpathParser search:@"//title"];
            if(titleElements && [titleElements count] > 0){
                NSString *title = [[titleElements objectAtIndex:0] content];
                if([title isEqualToString:@"Sorry, something went wrong and we're looking into it. (500)"]){
                    didPublish = NO;
                }
            }
            [xpathParser release];
            
            if(didPublish){
                DBWebItem *webItem = [[DBWebItem alloc] init];
                webItem.name = fileName;
                webItem.URL = shotURL;
                [self.delegate dribbbleShotUploadDidSucceedWithResultingItem:webItem connectionIdentifier:self._authenticationToken userInfo:userInfo]; 
                [webItem release];
            }else{
                error = UploadError;
            }
        }else{
            error = UploadError;
        }
    }else{
        error = LoginError;            
    }
    
    if(error){
        [self.delegate dribbbleRequestDidFailWithError:error connectionIdentifier:self._authenticationToken userInfo:userInfo];
    }
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
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];        
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

-(void)shootWithFileName:(NSString *)fileName andData:(NSData *)fileData withUserInfo:(id)userInfo{
    NSDictionary *shotData = [NSDictionary dictionaryWithObjectsAndKeys:
                              fileName, @"fileName",
                              fileData, @"fileData",
                              userInfo, @"userInfo",
                              nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                            selector:@selector(synchronousShootWithData:) 
                                                                              object:shotData];
    [self.operationQueue addOperation:operation];
    [operation release];
}

- (void)dealloc{
    delegate = nil;
    [super dealloc];
}

@end
