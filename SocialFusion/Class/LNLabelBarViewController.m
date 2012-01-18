//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "LNLabelBarViewController.h"
#import "LNLabelPageViewController.h"

@implementation LNLabelBarViewController

@synthesize scrollView = _scrollView;

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < 2; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        LNLabelPageViewController *page = [[LNLabelPageViewController alloc] init];
        UIView *subview = page.view;
        subview.frame = frame;
        [self.scrollView addSubview:subview];
        [page release];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
}


@end
