//
//  UserInfoViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "User.h"

typedef enum {
    kRenrenUserInfo = 0,
    kWeiboUserInfo  = 1,
} kUserInfoType;

@interface UserInfoViewController : CoreDataViewController {
    kUserInfoType _type;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;

@property (nonatomic, retain) User *user;

- (id)initWithType:(kUserInfoType)type;
+ (UserInfoViewController *)getUserInfoViewControllerWithType:(kUserInfoType)type;

@end
