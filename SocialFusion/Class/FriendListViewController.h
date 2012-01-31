//
//  FriendListViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendProfileViewController.h"

#define kCustomRowCount 7

@interface FriendListViewController : FriendProfileViewController

+ (FriendListViewController *)getNewFeedListControllerWithType:(RelationshipViewType)type;

@end


