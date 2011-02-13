//
//  CloudApp.m
//  Coaches Loupe
//
//  Created by David Keegan on 2/12/11.
//

#import "AppDelegate.h"

@implementation AppDelegate (CloudApp)

- (IBAction)precipitate:(id)sender{
	CLAPIEngine *engine = [CLAPIEngine engineWithDelegate:self];
	engine.email = @"user@email.com";
	engine.password = @"password";
    
	[engine uploadFileWithName:[self shotName] fileData:[self shotData] userInfo:nil];
}

- (void)requestDidFailWithError:(NSError *)error connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[FAIL]: %@, %@", connectionIdentifier, error);
}

- (void)fileUploadDidProgress:(CGFloat)percentageComplete connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[UPLOAD PROGRESS]: %@, %f", connectionIdentifier, percentageComplete);
}

- (void)fileUploadDidSucceedWithResultingItem:(CLWebItem *)item connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[UPLOAD SUCCESS]: %@, %@", connectionIdentifier, item);
}

- (void)itemListRetrievalSucceeded:(NSArray *)items connectionIdentifier:(NSString *)connectionIdentifier userInfo:(id)userInfo {
	NSLog(@"[ITEM LIST]: %@, %@", connectionIdentifier, items);
}

@end
