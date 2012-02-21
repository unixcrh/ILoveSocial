//
//  RenrenUserInfoViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-17.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"

@interface RenrenUserInfoViewController : UserInfoViewController

@property (nonatomic, retain) IBOutlet UILabel *birthDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *hometownLabel;
@property (nonatomic, retain) IBOutlet UILabel *highSchoolLabel;
@property (nonatomic, retain) IBOutlet UILabel *universityLabel;
@property (nonatomic, retain) IBOutlet UILabel *companyLabel;

@end
