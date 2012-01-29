//
//  NewStatusViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewStatusViewController : UIViewController <UITextViewDelegate> {
    BOOL _postToRenren;
    BOOL _postToWeibo;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *postRenrenButton;
@property (nonatomic, retain) IBOutlet UIButton *postWeiboButton;
@property (nonatomic, retain) IBOutlet UILabel *textCountLabel;
@property (nonatomic, retain) IBOutlet UIView *toolBarView;

- (IBAction)didClickCancelButton:(id)sender;
- (IBAction)didClickPostButton:(id)sender;

- (IBAction)didClickPostToRenrenButton:(id)sender;
- (IBAction)didClickPostToWeiboButton:(id)sender;

@end
