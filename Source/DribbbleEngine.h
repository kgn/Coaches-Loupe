//
//  DribbbleEngine.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/14/11.
//

//Default prefix is the application name, with non-alphanumeric characters removed
#define BoundryPrefix [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] \
                        componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] \
                        componentsJoinedByString:@""]

@interface DBWebItem : NSObject {
    NSString *name;
    NSURL *URL;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSURL *URL;

@end

@protocol DribbbleEngineDelegate;

@interface DribbbleEngine : NSObject {
    NSString *username, *password;
    id<DribbbleEngineDelegate> delegate;
    
    @private
    NSString *_authenticationToken;
    BOOL _isLoggedin;
}

@property (copy, nonatomic) NSString *username, *password;
@property (assign) id<DribbbleEngineDelegate> delegate;
@property (copy, nonatomic) NSString *_authenticationToken;
@property (nonatomic) BOOL _isLoggedin;

+ (id)engine;
+ (id)engineWithDelegate:(id<DribbbleEngineDelegate>)aDelegate;
- (id)initWithDelegate:(id<DribbbleEngineDelegate>)aDelegate;

- (BOOL)isReady;

-(void)shootWithFileName:(NSString *)fileName andData:(NSData *)fileData withUserInfo:(id)userInfo;

@end

@protocol DribbbleEngineDelegate <NSObject>

@optional
- (void)dribbbleRequestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;
- (void)dribbbleShotUploadDidSucceedWithResultingItem:(DBWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

@end
