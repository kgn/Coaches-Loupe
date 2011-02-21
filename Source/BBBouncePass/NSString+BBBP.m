//
//  NSString+BBBP.m
//  BBBouncePass
//
//  Created by David Keegan on 2/20/11.
//

#import "NSString+BBBP.h"
#import "BBBouncePass.h"

@implementation NSString (BBBP)

+ (NSString *)HTTPPOSTBoundryStringWithPrefix:(NSString *)prefix{
    NSUInteger length = 16;
    NSString *characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];
    for(NSUInteger i = 0; i<length; ++i){
        NSUInteger randomIndex = arc4random() % [characters length];
        NSString *character = [characters substringWithRange:NSMakeRange(randomIndex, 1)];
        [randomString appendString:character];
    }
    
    //boundries lead with --
    NSString *boundryString = [NSString stringWithFormat:@"--%@%@----", prefix, randomString];
    [randomString release];
    return boundryString;
}

+ (NSString *)urlEncodedStringForArgs:(NSDictionary *)args{
    NSMutableArray *argsAndValues = [[NSMutableArray alloc] init];
    for(NSString *key in [args allKeys]){
        NSString *escapedKey = [key stringWithURLEncoding];
        NSString *value = [[args objectForKey:key] stringWithURLEncoding];
        [argsAndValues addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, value]];
    }
    NSString *argsAndValuesString = [argsAndValues componentsJoinedByString:@"&"];
    [argsAndValues release];
    
    return argsAndValuesString;
}

//Modified from: http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/Foundation/GTMNSString%2BURLArguments.m
- (NSString *)stringWithURLEncoding{
    CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return [(NSString *)escaped autorelease];
}

@end
