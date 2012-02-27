//
//  NewBlogViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-26.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewBlogViewController.h"
#import "UIButton+Addition.h"

@implementation NewBlogViewController
@synthesize blogTextView = _blogTextView;
@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize blogBodyButton = _blogBodyButton;
@synthesize blogTitleButton = _blogTitleButton;
@synthesize scrollView = _scrollView;

- (void)dealloc {
    [_blogTextView release];
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_blogBodyButton release];
    [_blogTitleButton release];
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.blogTextView = nil;
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.blogBodyButton = nil;
    self.blogTitleButton = nil;
    self.scrollView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickPostToRenrenButton:(id)sender {
    _postToRenren = !_postToRenren;
    [self.postRenrenButton setPostPlatformButtonSelected:_postToRenren];
}

- (IBAction)didClickPostToWeiboButton:(id)sender {
    _postToWeibo = !_postToWeibo;
    [self.postWeiboButton setPostPlatformButtonSelected:_postToWeibo];
}

- (IBAction)didClickBlogTitleButton:(id)sender {
    
}

- (IBAction)didClickBlogBodyButton:(id)sender {
    
}

@end
