//
//  WeiboUserInfoViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-17.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"

@interface WeiboUserInfoViewController : UserInfoViewController

@property (nonatomic, retain) IBOutlet UILabel *blogLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

@end
