//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewStatusViewController.h"
#import "UIApplication+Addition.h"

#define TOOLBAR_HEIGHT  22

@interface NewStatusViewController()
- (void)updateTextCount;
- (void)dismissView;
@end

@implementation NewStatusViewController

@synthesize textView = _textView;
@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize textCountLabel = _textCountLabel;
@synthesize toolBarView = _toolBarView;

- (void)dealloc {
    [_textView release];
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_textCountLabel release];
    [_toolBarView release];
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
    [self.postRenrenButton setSelected:_postToRenren];
    [self.postWeiboButton setSelected:_postToWeibo];
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

#pragma mark -
#pragma mark IBAction
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissView];
}

- (IBAction)didClickPostButton:(id)sender {
    [self dismissView];
}

- (IBAction)didClickPostToRenrenButton:(id)sender {
    _postToRenren = !_postToRenren;
    [self.postRenrenButton setSelected:_postToRenren];
}

- (IBAction)didClickPostToWeiboButton:(id)sender {
    _postToWeibo = !_postToWeibo;
    [self.postWeiboButton setSelected:_postToWeibo];
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"keyboard changed, keyboard width = %f, height = %f", kbSize.width,kbSize.height);
    
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

@end
