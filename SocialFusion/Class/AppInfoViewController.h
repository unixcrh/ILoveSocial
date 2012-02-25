//
//  AppInfoViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppInfoViewControllerDelegate;

@interface AppInfoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;
@property (nonatomic, assign) id<AppInfoViewControllerDelegate> delegate;

@end

@protocol AppInfoViewControllerDelegate <NSObject>

- (void)didFinishShow;

@end