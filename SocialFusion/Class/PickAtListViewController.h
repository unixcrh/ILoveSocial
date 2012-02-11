//
//  PickAtListViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickAtListViewControllerDelegate;

@interface PickAtListViewController : UIViewController {
    UIButton *_renrenButton;
    UIButton *_weiboButton;
    BOOL _platformCode;
    id<PickAtListViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<PickAtListViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *renrenButton;
@property (nonatomic, retain) IBOutlet UIButton *weiboButton;

- (IBAction)didClickCancelButton:(id)sender;
- (IBAction)didClickFinishButton:(id)sender;

- (IBAction)didClickRenrenButton:(id)sender;
- (IBAction)didClickWeiboButton:(id)sender;

@end

@protocol PickAtListViewControllerDelegate <NSObject>

- (void)didPickAtUser;

@end
