//
//  AppInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "AppInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIApplication+Addition.h"
#define SINAWEIBOID @"2497693760"

@implementation AppInfoViewController
@synthesize iconImageView = _iconImageView;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_iconImageView release];
    self.delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.iconImageView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 7.0f;    
}  



- (void)dismissView
{
    [self.delegate didFinishShow];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissView];
}

#pragma mark - 
#pragma mark IBActions

- (IBAction)didClickFeedbackButton {
 
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Pocket Social 0.9.0 feedback"];
        [picker.navigationBar setBarStyle:UIBarStyleBlack];
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"PocketSocial@live.com"];
        NSString *emailBody = @"Please leave your message for the Pocket Social Team here.";
        [picker setToRecipients:toRecipients];
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    

}


-(IBAction)followUs
{
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            [[UIApplication sharedApplication] presentToast:@"关注成功" withVerticalPos:370];
        }
        else
        {
            [[UIApplication sharedApplication] presentToast:@"该账号已关注" withVerticalPos:370];

        }
    }];
    [client follow:SINAWEIBOID];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}
@end
