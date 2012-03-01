//
//  NewStatusViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "PickAtListViewController.h"
#import "DetailImageViewController.h"
#import "User.h"


@interface NewStatusViewController : PostViewController <UIImagePickerControllerDelegate, DetailImageViewControllerDelegate> {
    BOOL _postToRenren;
    BOOL _postToWeibo;
}

@property (nonatomic, retain) IBOutlet UIButton *postRenrenButton;
@property (nonatomic, retain) IBOutlet UIButton *postWeiboButton;

@property (nonatomic, retain) IBOutlet UIView *photoView;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) IBOutlet UIButton *photoCancelButton;

@property (nonatomic, retain) User *processUser;

- (IBAction)didClickPostToRenrenButton:(id)sender;
- (IBAction)didClickPostToWeiboButton:(id)sender;

- (IBAction)didClickPhotoCancelButton:(id)sender;
- (IBAction)didClickPickImageButton:(id)sender;

- (IBAction)didClickPhotoFrameButton:(id)sender;

@end
