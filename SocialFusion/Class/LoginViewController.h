//
//  LoginViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-23.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "CoreDataViewController.h"
#import "WeiboClient.h"

@interface LoginViewController : CoreDataViewController<UIAlertViewDelegate, WBSessionDelegate>

@property(nonatomic, retain) UIAlertView *hasLoggedInAlertView;
@property(nonatomic, retain) IBOutlet UILabel *weiboUserNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *renrenUserNameLabel;

- (IBAction)didClickRenrenLoginButton:(id)sender;
- (IBAction)didClickWeiboLoginButton:(id)sender;
- (IBAction)didClickFinishButton:(id)sender;

@end
