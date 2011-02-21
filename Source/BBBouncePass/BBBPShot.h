//
//  BBBPShot.h
//  BBBouncePass
//
//  Created by David Keegan on 2/20/11.
//

@interface BBBPShot : NSObject {
    NSString *name;
    NSURL *URL, *shortURL;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSURL *URL, *shortURL;

@end
