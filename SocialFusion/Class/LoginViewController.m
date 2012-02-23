//
//  LoginViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-23.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "LoginViewController.h"
#import "LNRootViewController.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "WeiboClient.h"
#import "RenrenClient.h"
#import <QuartzCore/QuartzCore.h>

#define LOGOUT_RENREN NO
#define LOGOUT_WEIBO YES

@interface LoginViewController()
@property(nonatomic, assign) BOOL logoutClient;
- (void)rrDidLogin;
- (void)wbDidLogin;
@end

@implementation LoginViewController
@synthesize weiboUserNameLabel = _weiboUserNameLabel;
@synthesize renrenUserNameLabel = _renrenUserNameLabel;
@synthesize hasLoggedInAlertView = _hasLoggedInAlertView;
@synthesize logoutClient = _logoutClient;
@synthesize weiboPhotoImageView = _weiboPhotoImageView, renrenPhotoImageView = _renrenPhotoImageView;
@synthesize weiboPhotoView = _weiboPhotoView, renrenPhotoView = _renrenPhotoView;


- (void)dealloc
{
    [_weiboUserNameLabel release];
    [_renrenUserNameLabel release];
    if(self.hasLoggedInAlertView.visible) {
		[self.hasLoggedInAlertView dismissWithClickedButtonIndex:-1 animated:NO];
	}
    [_hasLoggedInAlertView release];
    [_weiboPhotoImageView release];
    [_renrenPhotoImageView release];
    [_weiboPhotoView release];
    [_renrenPhotoView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.weiboUserNameLabel = nil;
    self.renrenUserNameLabel = nil;
    self.weiboPhotoImageView = nil;
    self.renrenPhotoImageView = nil;
    self.weiboPhotoView = nil;
    self.renrenPhotoView = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weiboPhotoView.layer.masksToBounds = YES;
    self.weiboPhotoView.layer.cornerRadius = 2.0f;
    self.renrenPhotoView.layer.masksToBounds = YES;
    self.renrenPhotoView.layer.cornerRadius = 2.0f;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([RenrenClient authorized]) {
        NSString *renrenID = [ud objectForKey:@"renren_ID"];
        self.currentRenrenUser = [RenrenUser userWithID:renrenID inManagedObjectContext:self.managedObjectContext];
        if(self.currentRenrenUser == nil) {
            [self rrDidLogin];
        }
        else {
            self.renrenUser = self.currentRenrenUser;
            [self.renrenUserNameLabel setText:[ud stringForKey:@"renren_Name"]];
        }
	} else {
		[self.renrenUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
    
	if ([WeiboClient authorized]) {
        NSString *weiboID = [ud objectForKey:@"weibo_ID"];
        self.currentWeiboUser = [WeiboUser userWithID:weiboID inManagedObjectContext:self.managedObjectContext];
        if(self.currentWeiboUser == nil) {
            [self wbDidLogin];
        }
        else {
            self.weiboUser = self.currentWeiboUser;
            [self.weiboUserNameLabel setText:[ud stringForKey:@"weibo_Name"]];
        }
	} else {
		[self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
}

- (void)showHasLoggedInAlert:(BOOL)whoCalled {
    self.logoutClient = whoCalled;
    NSString *message;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(whoCalled == LOGOUT_WEIBO)
        message = [ud stringForKey:@"weibo_Name"];
    else if(whoCalled == LOGOUT_RENREN)
        message = [ud stringForKey:@"renren_Name"];
    message = [message stringByAppendingString:NSLocalizedString(@"ID_LogOut_All",nil )];
    if(self.hasLoggedInAlertView && self.hasLoggedInAlertView.visible) {
        self.hasLoggedInAlertView.message = message;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ID_OK",nil) otherButtonTitles:NSLocalizedString(@"ID_Cancel",nil), nil];
        self.hasLoggedInAlertView = alert;
        [alert show];
        [alert release];
    }
}

- (IBAction)didClickWeiboLoginButton:(id)sender
{
	if (![WeiboClient authorized]) {
        /*  WeiboClient *weibo = [WeiboClient client];
         [weibo setCompletionBlock:^(WeiboClient *client) {
         [self wbDidLogin];
         }];
         
         [weibo authWithUsername:@"wzc345@gmail.com" password:@"5656496" autosave:YES];
         */
        
        WeiboClient *weibo = [WeiboClient client];
        // [weibo setDelegate:self];
        //[weibo oAuth:@selector(wbDidLogin) withFailedSelector:@selector(wbDidLogin)];
        [weibo authorize:nil delegate:self];
        
        
    }
    else {
        [self showHasLoggedInAlert:LOGOUT_WEIBO];
    }
}


- (IBAction)didClickRenrenLoginButton:(id)sender
{    
	if (![RenrenClient authorized]) {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            [self rrDidLogin];
        }];
        [renren authorize];
	}
    else {
        [self showHasLoggedInAlert:LOGOUT_RENREN];
    }
}

- (void)wbDidNotLogin:(BOOL)cancelled
{
    
}

- (void)wbDidLogin {
    NSLog(@"weibo did login");
    // get user info
    WeiboClient *weibo = [WeiboClient client];
    [weibo setCompletionBlock:^(WeiboClient *client) {
        if (!weibo.hasError) {
            NSLog(@"weibo did get user info");
            NSDictionary *dict = client.responseJSONObject;
            NSLog(@"weibo user info:%@", dict);
            NSString *weiboName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"screen_name"]];
            NSString *weiboID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:weiboName forKey:@"weibo_Name"];
            [ud setValue:weiboID forKey:@"weibo_ID"];
            [ud synchronize];
            [self.weiboUserNameLabel setText:weiboName];
            
            
            self.currentWeiboUser = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            self.weiboUser = self.currentWeiboUser;
            [self.managedObjectContext processPendingChanges];
        }
    }];
    [weibo getUser:[WeiboClient currentUserID]];
}

- (void)rrDidLogin
{
    NSLog(@"renren did login");
    // get user info
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!renren.hasError) {
            NSArray *result = client.responseJSONObject;
            NSDictionary* dict = [result lastObject];
            NSLog(@"renren user info:%@", dict);
            NSString *renrenName = [dict objectForKey:@"name"];
            NSString *renrenID = [dict objectForKey:@"uid"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:renrenName forKey:@"renren_Name"];
            [ud setValue:renrenID forKey:@"renren_ID"];
            [ud synchronize];
            [self.renrenUserNameLabel setText:renrenName];
            self.currentRenrenUser = [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            self.renrenUser = self.currentRenrenUser;
            [self.managedObjectContext processPendingChanges];
        };
    }];
	[renren getUserInfo];
}

- (void)wbDidLogout
{
    [self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
}

- (void)rrDidLogout
{
    [self.renrenUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
}

//alertView登出的delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.logoutClient == LOGOUT_RENREN) {
        if (buttonIndex == 0) {
            [RenrenClient signout];
            [self rrDidLogout];
            
        }
    }
    else if(self.logoutClient == LOGOUT_WEIBO)
    {
        if (buttonIndex == 0) {
            [WeiboClient signout];
            [self wbDidLogout];
        }
    }
    self.hasLoggedInAlertView = nil;
}

- (BOOL)isLoginValid {
    return ([RenrenClient authorized] && [WeiboClient authorized]);
}

@end

