//
//  RenrenUser.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class RenrenDetail, RenrenUser;

@interface RenrenUser : User

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * pinyinNameFirstLetter;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) RenrenDetail *detailInfo;
@end

@interface RenrenUser (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(RenrenUser *)value;
- (void)removeFriendsObject:(RenrenUser *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
