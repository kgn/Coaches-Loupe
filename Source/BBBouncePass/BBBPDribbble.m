//
//  BBBPDribbble.m
//  BBBouncePass
//
//  Created by David Keegan on 2/20/11.
//

#import "BBBPDribbble.h"
#import "BBBouncePass.h"
#import "NSString+BBBP.h"
#import "NSMutableData+BBBP.h"
#import "TFHpple.h"

@implementation BBBPDribbble

//find the authenticity_token from the login page
+ (NSString *)authenticityToken{
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

+ (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password andAuthenticityToken:(NSString *)authenticityToken{
    BOOL didLoggedin = NO;
    NSURL *sessionURL = [NSURL URLWithString:@"http://dribbble.com/session"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:sessionURL 
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                            timeoutInterval:20.0f]; 
    [request setHTTPMethod:@"POST"];
    NSString *htmlBodyString = [NSString urlEncodedStringForArgs:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  authenticityToken, @"authenticity_token", 
                                                                  username, @"login",
                                                                  password, @"password",
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
            didLoggedin = YES;
        }
    }
    [xpathParser release];
    
    return didLoggedin;
}

+ (NSString *)uploadImageWithName:(NSString *)imageName andData:(NSData *)imageData withAuthenticityToken:(NSString *)authenticityToken{
    NSString *newline = @"\r\n";
    NSString *boundry = [NSString HTTPPOSTBoundryStringWithPrefix:BBBPHTTPPOSTBoundryPrefix];
    //boundries lead with --
    NSString *boundryHeader = [NSString stringWithFormat:@"--%@", boundry];
    NSURL *shotsURL = [NSURL URLWithString:@"http://dribbble.com/shots"];
    
    //build the authenticity_token section
    NSMutableArray *authenticityArray = [[NSMutableArray alloc] init];
    [authenticityArray addObject:boundryHeader];
    [authenticityArray addObject:@"Content-Disposition: form-data; name=\"authenticity_token\""];
    [authenticityArray addObject:@""];
    [authenticityArray addObject:authenticityToken];
    [authenticityArray addObject:@""];
    NSString *authenticityString = [authenticityArray componentsJoinedByString:newline];
    [authenticityArray release];
    
    //build the image section
    NSMutableArray *uploadArray = [[NSMutableArray alloc] init];
    [uploadArray addObject:boundryHeader];
    [uploadArray addObject:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"screenshot[file]\"; filename=\"%@\"", imageName]];
    [uploadArray addObject:@"Content-Type: image/png"];
    [uploadArray addObject:newline];
    NSString *uploadString = [uploadArray componentsJoinedByString:newline];
    [uploadArray release];        
    
    //add the sections to the body, then add the image data
    NSMutableData *body = [[NSMutableData alloc] init];
    [body appendString:authenticityString];
    [body appendString:uploadString];
    [body appendData:imageData];
    [body appendString:newline];
    [body appendString:boundryHeader];
    [body appendString:@"--"];//Marks the end
    
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

+ (BBBPShot *)publishShotAtPath:(NSString *)shotPath name:(NSString *)name tags:(NSArray *)tags introductoryComment:(NSString *)introductoryComment withAuthenticityToken:(NSString *)authenticityToken{
    NSString *shotURLString = [NSString stringWithFormat:@"http://dribbble.com%@", shotPath];
    NSURL *shotURL = [NSURL URLWithString:shotURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:shotURL
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                            timeoutInterval:20.0f]; 
    [request setHTTPMethod:@"POST"];
    
    name = name ?: @"";
    introductoryComment = introductoryComment ?: @"";
    NSString *tagsString = @"";
    if(tags){
        [tags componentsJoinedByString:@","];
    }
    
    NSString *bodyString = [NSString urlEncodedStringForArgs:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"put", @"_method",
                                                              @"true", @"publish",
                                                              name, @"screenshot[title]",
                                                              tagsString, @"screenshot[tag_list]",
                                                              introductoryComment, @"screenshot[introductory_comment_text]",
                                                              @"Publish", @"commit",
                                                              authenticityToken, @"authenticity_token", 
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
    
    BBBPShot *shot = nil;
    if(didPublish){
        //find the short url
        NSString *shortURL = nil;
        NSArray *inputElements  = [xpathParser search:@"//form/fieldset/input"];
        if(inputElements && [inputElements count] > 0){
            TFHppleElement *element = [inputElements objectAtIndex:0];
            NSDictionary *attributes = [element attributes];                     
            shortURL = [attributes objectForKey:@"value"];
        }
        
        //build the web item
        shot = [[BBBPShot alloc] init];
        shot.name = name;
        shot.URL = shotURL;
        if(shortURL){
            shot.shortURL = [NSURL URLWithString:shortURL];
        }
    }
    [xpathParser release];
    
    return [shot autorelease];
}

+ (BBBPShot *)shootImageWithName:(NSString *)imageName andData:(NSData *)imageData name:(NSString *)name tags:(NSArray *)tags introductoryComment:(NSString *)introductoryComment withAuthenticityToken:(NSString *)authenticityToken{
    NSString *shotPath = [BBBPDribbble uploadImageWithName:imageName andData:imageData withAuthenticityToken:authenticityToken];
    return [BBBPDribbble publishShotAtPath:shotPath name:name tags:tags introductoryComment:introductoryComment withAuthenticityToken:authenticityToken];
}

@end
