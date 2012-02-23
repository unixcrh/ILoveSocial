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


- (void)dealloc
{
    [_weiboUserNameLabel release];
    [_renrenUserNameLabel release];
    if(self.hasLoggedInAlertView.visible) {
		[self.hasLoggedInAlertView dismissWithClickedButtonIndex:-1 animated:NO];
	}
    [_hasLoggedInAlertView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.weiboUserNameLabel = nil;
    self.renrenUserNameLabel = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];      
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([RenrenClient authorized]) {
        NSString *renrenID = [ud objectForKey:@"renren_ID"];
        self.currentRenrenUser = [RenrenUser userWithID:renrenID inManagedObjectContext:self.managedObjectContext];
        if(self.currentRenrenUser == nil) {
            [self rrDidLogin];
        }
        else {
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
            // [self wbDidLogin];
            
            [self.weiboUserNameLabel setText:[ud stringForKey:@"weibo_Name"]];
        }
	} else {
		[self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
}

- (IBAction)didClickFinishButton:(id)sender
{
    if(![RenrenClient authorized] && ![WeiboClient authorized])
        return;
    LNRootViewController *vc = [[LNRootViewController alloc] init];
    self.renrenUser = self.currentRenrenUser;
    self.weiboUser = self.currentWeiboUser;
    vc.userDict = self.userDict;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; 
    transition.type = kCATransitionPush; 
    transition.subtype = kCATransitionFromTop;
    
    [self.navigationController pushViewController:vc animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [vc release];
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

- (void)finished
{
    
    self.currentWeiboUser = [WeiboUser insertUser:nil inManagedObjectContext:self.managedObjectContext];
    [self.managedObjectContext processPendingChanges];
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
    [self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

