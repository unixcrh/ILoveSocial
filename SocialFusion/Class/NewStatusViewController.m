//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewStatusViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIApplication+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "UIImageView+Addition.h"
#import "UIButton+Addition.h"

#define USER_PHOTO_CENTER CGPointMake(260.0f, -9.0f)
#define USER_PHOTO_HIDDEN_CENTER CGPointMake(260.0f, 100.0f)

@interface NewStatusViewController()
- (void)dismissUserPhoto;
@end

@implementation NewStatusViewController

@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize photoFrameImageView = _photoFrameImageView;
@synthesize photoImageView = _photoImageView;
@synthesize photoCancelButton = _photoCancelButton; 

- (void)dealloc {
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_photoFrameImageView release];
    [_photoImageView release];
    [_photoCancelButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.photoFrameImageView = nil;
    self.photoImageView = nil;
    self.photoCancelButton = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        _postToRenren = NO;
        _postToWeibo = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.postRenrenButton setSelected:_postToRenren];
    [self.postWeiboButton setSelected:_postToWeibo];

    self.photoFrameImageView.hidden = YES;
    self.photoImageView.hidden = YES;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    if(!_postToWeibo && !_postToRenren) {
        [[UIApplication sharedApplication] presentToast:@"没有选中任何平台。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if(![self isTextValid]) 
        return;
    if(_isPosting)
        return;
    _isPosting = YES;
    
    if(_postToWeibo) {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorWeibo;
            [self postStatusCompletion];
        }];
        _postCount++;
        if (self.photoImageView.image) {
            [client postStatus:self.textView.text withImage:self.photoImageView.image];
        }
        else {
            [client postStatus:self.textView.text];
        }
    }
    
    if(_postToRenren) {
        RenrenClient *client = [RenrenClient client];
        [client setCompletionBlock:^(RenrenClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorRenren;
            [self postStatusCompletion];
        }];
        _postCount++;
        if (self.photoImageView.image) {
            [client postStatus:self.textView.text withImage:self.photoImageView.image];
        }
        else {
            [client postStatus:self.textView.text];
        }
    }
    [self dismissView];
}

- (IBAction)didClickPostToRenrenButton:(id)sender {
    _postToRenren = !_postToRenren;
    [self.postRenrenButton setPostPlatformButtonSelected:_postToRenren];
}

- (IBAction)didClickPostToWeiboButton:(id)sender {
    _postToWeibo = !_postToWeibo;
    [self.postWeiboButton setPostPlatformButtonSelected:_postToWeibo];
}

- (IBAction)didClickPhotoCancelButton:(id)sender {
    [self dismissUserPhoto];
}

- (IBAction)didClickPickImageButton:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentModalViewController:ipc animated:YES]; 
}

#pragma mark -
#pragma mark pick photo methods

- (void)showPhotoCancelButton {
    self.photoCancelButton.hidden = NO;
    self.photoCancelButton.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoCancelButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.photoCancelButton.userInteractionEnabled = YES;
    }];
}

- (void)hidePhotoCancelButton {
    self.photoCancelButton.alpha = 1;
    self.photoCancelButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoCancelButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.photoCancelButton.hidden = YES;
    }];
}

- (void)presentUserPhoto:(UIImage *)image {
    self.photoFrameImageView.hidden = NO;
    self.photoImageView.hidden = NO;
    if(!self.photoImageView.image) {
        self.photoImageView.image = image;
        self.photoFrameImageView.center = USER_PHOTO_HIDDEN_CENTER;
        self.photoImageView.center = USER_PHOTO_HIDDEN_CENTER;
        [UIView animateWithDuration:0.3f animations:^{
            self.photoFrameImageView.center = USER_PHOTO_CENTER;
            self.photoImageView.center = USER_PHOTO_CENTER;
        } completion:^(BOOL finished) {
            [self showPhotoCancelButton];
        }];
    }
    else {
        UIImageView *oldImageView = [[UIImageView alloc] initWithImage:self.photoImageView.image];
        oldImageView.frame = self.photoImageView.frame;
        self.photoImageView.image = image;
        self.photoImageView.alpha = 0;
        [self.toolBarView insertSubview:oldImageView belowSubview:self.photoFrameImageView];
        [UIView animateWithDuration:0.3f animations:^{
            self.photoImageView.alpha = 1;
        }];
        oldImageView.alpha = 1;
        [UIView animateWithDuration:0.3f animations:^{
            oldImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [oldImageView removeFromSuperview];
        }];
    }
}

- (void)dismissUserPhoto {
    self.photoFrameImageView.center = USER_PHOTO_CENTER;
    self.photoImageView.center = USER_PHOTO_CENTER;
    [UIView animateWithDuration:0.3f animations:^{
        self.photoFrameImageView.center = USER_PHOTO_HIDDEN_CENTER;
        self.photoImageView.center = USER_PHOTO_HIDDEN_CENTER;
    } completion:^(BOOL finished) {
        self.photoImageView.image = nil;
        self.photoFrameImageView.hidden = YES;
        self.photoImageView.hidden = YES;
    }];
    [self hidePhotoCancelButton];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"image info:%@", info);
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentUserPhoto:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
