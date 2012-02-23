//
//  NewStatusViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "PickAtListViewController.h"

typedef enum {
    PostStatusErrorNone     = 0,
    PostStatusErrorWeibo    = 1,
    PostStatusErrorRenren   = 2,
    PostStatusErrorAll      = 3,
} PostStatusErrorCode;

#define TOAST_POS_Y   self.toolBarView.frame.origin.y - 20.0f

@interface PostViewController : CoreDataViewController <UITextViewDelegate, UINavigationControllerDelegate, PickAtListViewControllerDelegate> {
    PostStatusErrorCode _postStatusErrorCode;
    NSUInteger _postCount;
    
    UITextView *_textView;
    UILabel *_textCountLabel;
    UIView *_toolBarView;
    UILabel *titleLabel;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *textCountLabel;
@property (nonatomic, retain) IBOutlet UIView *toolBarView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

- (IBAction)didClickCancelButton:(id)sender;
- (IBAction)didClickPostButton:(id)sender;
- (IBAction)didClickAtButton:(id)sender;

- (BOOL)isTextValid;
- (void)postStatusCompletion;
- (void)dismissView;

- (void)updateTextCount;

@end
