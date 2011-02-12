//
//  PassMouseViews.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "PassMouseViews.h"

@implementation LoupeView

-(BOOL)mouseDownCanMoveWindow{
    return YES;
}

@end

@implementation LoupeImageView

-(BOOL)mouseDownCanMoveWindow{
    return YES;
}

@end
