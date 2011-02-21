//
//  NSMutableData+BBBP.m
//  BBBouncePass
//
//  Created by David Keegan on 2/20/11.
//

#import "NSMutableData+BBBP.h"

@implementation NSMutableData (BBBP)

- (void)appendString:(NSString *)aString{
    [self appendData:[aString dataUsingEncoding:NSUTF8StringEncoding]]; 
}

@end
