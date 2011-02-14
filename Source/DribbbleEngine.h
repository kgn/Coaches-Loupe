//
//  DribbbleEngine.h
//  Coaches Loupe
//
//  Created by David Keegan on 2/14/11.
//

@protocol DribbbleEngineDelegate;

@interface DribbbleEngine : NSObject {
    NSString *username, *password;
    id<DribbbleEngineDelegate> delegate;
    
    @private
    NSString *authenticationToken;
}

@property (copy, nonatomic) NSString *username, *password;
@property (assign) id<DribbbleEngineDelegate> delegate;
@property (copy, nonatomic) NSString *authenticationToken;

+ (id)engine;
+ (id)engineWithDelegate:(id<DribbbleEngineDelegate>)aDelegate;
- (id)initWithDelegate:(id<DribbbleEngineDelegate>)aDelegate;

- (BOOL)isReady;

-(void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo;

@end

@protocol DribbbleEngineDelegate <NSObject>

@optional
- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo;

@end