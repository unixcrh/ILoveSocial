//
//  RenrenClient.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-9-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORequest.h"
#import "ROWebDialogViewController.h"

@class RenrenClient;
typedef void (^RRCompletionBlock)(RenrenClient *client);

@interface RenrenClient : NSObject<RODialogDelegate, RORequestDelegate> {
    //RRDialog *_rrDialog;
    RORequest* _request;
    RRCompletionBlock _completionBlock;
}

@property(nonatomic, copy) NSString *accessToken;
@property(nonatomic,copy) NSString *secret;
@property(nonatomic, copy) NSString *sessionKey;
@property(nonatomic, retain) NSDate *expirationDate;

@property (nonatomic, assign, readonly) BOOL hasError;
// NSDictionary or NSArray
@property (nonatomic, retain) id responseJSONObject;

- (void)setCompletionBlock:(void (^)(RenrenClient* client))completionBlock;
- (RRCompletionBlock)completionBlock;

+ (id)client;
// logout
+ (void)signout;
// return true if user already logged in
+ (BOOL)authorized;
// authorize with renren dialog
- (void)authorize;


- (void)getUserInfo;
- (void)getLatestStatus:(NSString *)userID;
- (void)getFriendsProfile;
- (void)getFriendsID;
- (void)getNewFeed:(int)pageNumber;
- (void)getComments:(NSString*)userID status_ID:(NSString*)status pageNumber:(int)pageNumber;
- (void)getStatus:(NSString*)userID status_ID:(NSString*)status;
- (void)getNewFeed:(int)pageNumber  uid:(NSString*)id;
- (void)getSinglePhoto:(NSString*)userID photoID:(NSString*)photoID;
- (void)getBlog:(NSString*)userID status_ID:(NSString*)status;
- (void)getBlogComments:(NSString*)userID status_ID:(NSString*)status pageNumber:(int)pageNumber;
- (void)getShareComments:(NSString*)userID share_ID:(NSString*)share pageNumber:(int)pageNumber;
-(void)getAlbum:(NSString*)userID a_ID:(NSString*)a_ID pageNumber:(int)pageNumber;
-(void)getPhotoComments:(NSString*)userID photo_ID:(NSString*)p_ID pageNumber:(int)pageNumber;

- (void)postStatus:(NSString *)status;
- (void)postStatus:(NSString *)status withImage:(UIImage *)iamge;
- (void)postMessage:(NSString *)msg guestBookOwnerID:(NSString *)uid useSecretWord:(BOOL)isSecret;

@end
