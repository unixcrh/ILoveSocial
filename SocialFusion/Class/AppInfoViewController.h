//
//  AppInfoViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol AppInfoViewControllerDelegate;

@interface AppInfoViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;
@property (nonatomic, assign) id<AppInfoViewControllerDelegate> delegate;

- (IBAction)didClickFeedbackButton;

@end

@protocol AppInfoViewControllerDelegate <NSObject>

- (void)didFinishShow;

@end