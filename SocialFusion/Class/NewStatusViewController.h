//
//  NewStatusViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "PickAtListViewController.h"


#import "WebStringToImageConverter.h"
@interface NewStatusViewController : PostViewController <UIImagePickerControllerDelegate,WebStringToImageConverterDelegate> {
    BOOL _postToRenren;
    BOOL _postToWeibo;
    
    UIView *_photoView;
    UIImageView *_photoImageView;
    UIButton *_photoCancelButton;
}

@property (nonatomic, retain) IBOutlet UIButton *postRenrenButton;
@property (nonatomic, retain) IBOutlet UIButton *postWeiboButton;

@property (nonatomic, retain) IBOutlet UIView *photoView;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) IBOutlet UIButton *photoCancelButton;


- (IBAction)didClickPostToRenrenButton:(id)sender;
- (IBAction)didClickPostToWeiboButton:(id)sender;

- (IBAction)didClickPhotoCancelButton:(id)sender;
- (IBAction)didClickPickImageButton:(id)sender;

@end
