//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "PostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIApplication+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "UIImageView+Addition.h"
#import "UIButton+Addition.h"

#define TOOLBAR_HEIGHT  22

@interface PostViewController()
- (void)updateTextCount;
- (void)dismissView;
@end

@implementation PostViewController

@synthesize textView = _textView;
@synthesize textCountLabel = _textCountLabel;
@synthesize toolBarView = _toolBarView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc {
    [_textView release];
    [_textCountLabel release];
    [_toolBarView release];
    [_titleLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.textView = nil;
    self.textCountLabel = nil;
    self.toolBarView = nil;
    self.titleLabel = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    self.textView.text = @"";
    [self updateTextCount];
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
    }
}

#pragma mark -
#pragma mark IBAction
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissView];
}

- (IBAction)didClickPostButton:(id)sender {
    [self dismissView];
}

- (IBAction)didClickAtButton:(id)sender {
    PickAtListViewController *vc = [[PickAtListViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
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
}

#pragma mark -
#pragma makr PickAtListViewController delegate

- (void)cancelPickUser {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didPickAtUser:(NSString *)userName {
    int location = self.textView.selectedRange.location;
    NSString *content = self.textView.text;
    NSString *stringToInsert = [userName stringByAppendingString:@" "];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location], stringToInsert, [content substringFromIndex:location]];
    self.textView.text = result;
    NSRange range = self.textView.selectedRange;
    range.location = location + stringToInsert.length;
    self.textView.selectedRange = range;
    [self updateTextCount];
    [self dismissModalViewControllerAnimated:YES];
}

@end
