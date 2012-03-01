//
//  AppInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "AppInfoViewController.h"
#import <QuartzCore/QuartzCore.h>


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
-(IBAction)mail
{
 
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"PocketSocial1.0.0 Feedback"];
        [picker.navigationBar setBarStyle:UIBarStyleBlack];
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"PocketSocial@live.com"];
        NSString *emailBody = @"Leave your note to the PocketSocial here.";
        [picker setToRecipients:toRecipients];
        [picker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    

}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}
@end
