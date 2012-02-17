//
//  WeiboUser.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-17.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class WeiboDetail, WeiboStatus, WeiboUser;

@interface WeiboUser : User

@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) WeiboStatus *favorites;
@property (nonatomic, retain) WeiboDetail *detailInfo;
@end

@interface WeiboUser (CoreDataGeneratedAccessors)

- (void)addFollowersObject:(WeiboUser *)value;
- (void)removeFollowersObject:(WeiboUser *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addFriendsObject:(WeiboUser *)value;
- (void)removeFriendsObject:(WeiboUser *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
