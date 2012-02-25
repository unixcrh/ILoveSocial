//
//  LoginViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-23.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "CoreDataViewController.h"
#import "WeiboClient.h"
#import "AppInfoViewController.h"

@interface LoginViewController : CoreDataViewController<UIAlertViewDelegate, WBSessionDelegate, AppInfoViewControllerDelegate>

@property(nonatomic, retain) UIAlertView *hasLoggedInAlertView;
@property(nonatomic, retain) IBOutlet UILabel *weiboUserNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *renrenUserNameLabel;
@property(nonatomic, retain) IBOutlet UIImageView *weiboPhotoImageView;
@property(nonatomic, retain) IBOutlet UIImageView *renrenPhotoImageView;
@property(nonatomic, retain) IBOutlet UIView *weiboPhotoView;
@property(nonatomic, retain) IBOutlet UIView *renrenPhotoView;
@property(nonatomic, readonly) BOOL isLoginValid;

- (IBAction)didClickRenrenLoginButton:(id)sender;
- (IBAction)didClickWeiboLoginButton:(id)sender;
- (IBAction)didClickInfoButton:(id)sender;

@end
