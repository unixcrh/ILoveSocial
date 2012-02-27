//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewStatusViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIApplication+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "UIImageView+Addition.h"
#import "UIButton+Addition.h"
#import "NSString+WeiboSubString.h"

#define USER_PHOTO_CENTER CGPointMake(260.0f, 29.0f)
#define USER_PHOTO_HIDDEN_CENTER CGPointMake(260.0f, 150.0f)

#define USER_PHOTO_SIDE_LENGTH 40.0f


@interface NewStatusViewController()
- (void)dismissUserPhoto;
@end

@implementation NewStatusViewController

@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize photoView = _photoView;
@synthesize photoImageView = _photoImageView;
@synthesize photoCancelButton = _photoCancelButton; 

- (void)dealloc {
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_photoView release];
    [_photoImageView release];
    [_photoCancelButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.photoView = nil;
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

    self.photoView.hidden = YES;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    if(!_postToWeibo && !_postToRenren) {
        [[UIApplication sharedApplication] presentToast:@"请选择发送平台。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if([self.textView.text isEqualToString:@""] && !self.photoImageView.image) {
        [[UIApplication sharedApplication] presentToast:@"请输入内容或添加照片。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    
    if(_postToWeibo) {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorWeibo;
            [self postStatusCompletion];
        }];
        _postCount++;
        if (self.photoImageView.image) {
            
            if ([self.textCountLabel.text integerValue]>WEIBO_MAX_WORD)
            {
                [client postStatus:[self.textView.text getSubstringToIndex:WEIBO_MAX_WORD] withImage:self.photoImageView.image];
            }
            else
            {
                [client postStatus:self.textView.text withImage:self.photoImageView.image];
            }
        }
        else {
            if ([self.textCountLabel.text integerValue]>WEIBO_MAX_WORD)
            {
            [client postStatus:[self.textView.text getSubstringToIndex:WEIBO_MAX_WORD]];
            }
            else
            {
                [client postStatus:self.textView.text];
            }
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

- (IBAction)didClickPhotoFrameButton:(id)sender {
    [self.textView resignFirstResponder];
    DetailImageViewController *vc = [DetailImageViewController showDetailImageWithImage:self.photoImageView.image];
    vc.saveButton.hidden = YES;
    vc.delegate = self;
}

#pragma mark -
#pragma mark DetailImageViewController delegate

- (void)didFinishShow {
    [self.textView becomeFirstResponder];
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
    self.photoView.hidden = NO;
    if(!self.photoImageView.image) {
        self.photoImageView.image = image;
        [self.photoImageView centerizeWithSideLength:USER_PHOTO_SIDE_LENGTH];
        self.photoView.center = USER_PHOTO_HIDDEN_CENTER;
        [UIView animateWithDuration:0.3f animations:^{
            self.photoView.center = USER_PHOTO_CENTER;
        } completion:^(BOOL finished) {
            [self showPhotoCancelButton];
        }];
    }
    else {
        UIImageView *oldImageView = [[UIImageView alloc] initWithImage:self.photoImageView.image];
        oldImageView.frame = self.photoImageView.frame;
        self.photoImageView.image = image;
        [self.photoImageView centerizeWithSideLength:USER_PHOTO_SIDE_LENGTH];
        self.photoImageView.alpha = 0;
        [self.photoView insertSubview:oldImageView aboveSubview:self.photoImageView];
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
    self.photoView.center = USER_PHOTO_CENTER;
    [UIView animateWithDuration:0.3f animations:^{
        self.photoView.center = USER_PHOTO_HIDDEN_CENTER;
    } completion:^(BOOL finished) {
        self.photoImageView.image = nil;
        self.photoView.hidden = YES;
    }];
    [self hidePhotoCancelButton];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentUserPhoto:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString*)getSubstringToIndex:(NSString*)string index:(int)index
{
    int i,n=[string length];
    unichar c;
    int a=0;
    int b=0;
    int l=0;
    for(i=0;i<n;i++){
        c=[string characterAtIndex:i];
        if(isblank(c)){
            a++;
        }else if(isascii(c)){
            b++;
        }else{
            l++;
        }
        if (l+(int)ceilf((float)(a+b)/2.0)>index)
        {
            break;
        }
    }
   return [string substringToIndex:a+b+l];    
}


@end
