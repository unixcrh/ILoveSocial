//
//  NewStatusViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PostStatusErrorNone     = 0,
    PostStatusErrorWeibo    = 1,
    PostStatusErrorRenren   = 2,
    PostStatusErrorAll      = 3,
} PostStatusErrorCode;

@interface NewStatusViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL _postToRenren;
    BOOL _postToWeibo;
    PostStatusErrorCode _postStatusErrorCode;
    NSUInteger _postCount;
    UIImageView *_photoFrameImageView;
    UIImageView *_photoImageView;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *postRenrenButton;
@property (nonatomic, retain) IBOutlet UIButton *postWeiboButton;
@property (nonatomic, retain) IBOutlet UILabel *textCountLabel;
@property (nonatomic, retain) IBOutlet UIView *toolBarView;
@property (nonatomic, retain) IBOutlet UIImageView *photoFrameImageView;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;


- (IBAction)didClickCancelButton:(id)sender;
- (IBAction)didClickPostButton:(id)sender;

- (IBAction)didClickPostToRenrenButton:(id)sender;
- (IBAction)didClickPostToWeiboButton:(id)sender;

- (IBAction)pickImage:(id)sender;

@end
