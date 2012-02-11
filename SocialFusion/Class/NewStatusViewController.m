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

#define TOOLBAR_HEIGHT  22
#define TOAST_POS_Y   self.toolBarView.frame.origin.y - 20.0f

#define USER_PHOTO_CENTER CGPointMake(260.0f, -9.0f)
#define USER_PHOTO_HIDDEN_CENTER CGPointMake(260.0f, 100.0f)

@interface NewStatusViewController()
- (void)updateTextCount;
- (void)dismissView;
- (void)dismissUserPhoto;
@end

@implementation NewStatusViewController

@synthesize textView = _textView;
@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize textCountLabel = _textCountLabel;
@synthesize toolBarView = _toolBarView;
@synthesize photoFrameImageView = _photoFrameImageView;
@synthesize photoImageView = _photoImageView;
@synthesize photoCancelButton = _photoCancelButton; 

- (void)dealloc {
    [_textView release];
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_textCountLabel release];
    [_toolBarView release];
    [_photoFrameImageView release];
    [_photoImageView release];
    [_photoCancelButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.textView = nil;
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.textCountLabel = nil;
    self.toolBarView = nil;
    self.photoFrameImageView = nil;
    self.photoImageView = nil;
    self.photoCancelButton = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        _postToRenren = YES;
        _postToWeibo = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    _postToRenren = NO;
    _postToWeibo = NO;
    [self.postRenrenButton setSelected:_postToRenren];
    [self.postWeiboButton setSelected:_postToWeibo];
    self.textView.text = @"";
    [self updateTextCount];
    
    self.photoFrameImageView.hidden = YES;
    self.photoImageView.hidden = YES;
}

- (void)dismissView {
    [self.textView resignFirstResponder];
    [[UIApplication sharedApplication] dismissModalViewController];
}

- (void)updateTextCount {
    NSString *text = self.textView.text;
    int bytes = [text lengthOfBytesUsingEncoding:NSUTF16StringEncoding];
    const char *ptr = [text cStringUsingEncoding:NSUTF16StringEncoding];
    int words = 0;
    for (int i = 0; i < bytes; i++) {
        if (*ptr) {
            words++;
        }
        ptr++;
    }
    words += 1;
    words /= 2;
    self.textCountLabel.text = [NSString stringWithFormat:@"%d", words];

}

- (BOOL)isTextValid {
    BOOL result = YES;
    NSInteger textCount = [self.textCountLabel.text integerValue];
    if(textCount <= 0) {
        result = NO;
        [[UIApplication sharedApplication] presentToast:@"请输入内容。" withVerticalPos:TOAST_POS_Y];
    }
    else if(textCount > 140) {
        result = NO;
        [[UIApplication sharedApplication] presentToast:@"内容超过140字限制。" withVerticalPos:TOAST_POS_Y];
    }
    return result;
}

- (void)postStatusCompletion {
    _postCount--;
    if(_postCount == 0) {
        switch (_postStatusErrorCode) {
            case PostStatusErrorAll:
                [[UIApplication sharedApplication] presentToast:@"发送到微博、人人均失败。" withVerticalPos:kToastBottomVerticalPosition];
                break;
            case PostStatusErrorWeibo:
                [[UIApplication sharedApplication] presentToast:@"发送到微博失败。" withVerticalPos:kToastBottomVerticalPosition];
                break;
            case PostStatusErrorRenren:
                [[UIApplication sharedApplication] presentToast:@"发送到人人失败。" withVerticalPos:kToastBottomVerticalPosition];
                break;
            case PostStatusErrorNone:
                [[UIApplication sharedApplication] presentToast:@"发送成功。" withVerticalPos:kToastBottomVerticalPosition];
                break;
            default:
                break;
        }
        _isPosting = NO;
        [self dismissView];
    }
}

#pragma mark -
#pragma mark IBAction
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissView];
}

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

- (IBAction)didClickAtButton:(id)sender {
    PickAtListViewController *vc = [[PickAtListViewController alloc] init];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

- (IBAction)didClickPickImageButton:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentModalViewController:ipc animated:YES]; 
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //NSLog(@"keyboard changed, keyboard width = %f, height = %f", kbSize.width,kbSize.height);
    
    CGRect toolbarFrame = self.toolBarView.frame;
    toolbarFrame.origin.y = self.view.frame.size.height - kbSize.height - TOOLBAR_HEIGHT;
    self.toolBarView.frame = toolbarFrame;
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = self.view.frame.size.height - kbSize.height - textViewFrame.origin.y - TOOLBAR_HEIGHT;
    self.textView.frame = textViewFrame;
    
}

#pragma mark -
#pragma mark UITextView delegate 
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateTextCount];
        /*self.wordsCountLabel.text = [NSString stringWithFormat:@"%d", words];
    self.doneButton.enabled = words >= 0;
    
	if (words >= 0) {
		self.wordsCountLabel.text = [NSString stringWithFormat:@"%d", words];
		self.wordsCountLabel.textColor = LabelBlackColor;
	} else {
		self.wordsCountLabel.text = [NSString stringWithFormat:@"超出 %d", -words];
		self.wordsCountLabel.textColor = LabelRedColor;
	}
	
    if ((NSString*)_lastChar && [(NSString*)_lastChar compare:@"@"] == NSOrderedSame) {
        [self atButtonClicked:nil];
    }*/
}

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

#pragma mark -
#pragma makr PickAtListViewController delegate
- (void)didPickAtUser {
    [self dismissModalViewControllerAnimated:YES];
}

@end
