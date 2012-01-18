//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelBarViewController.h"
#import "LNLabelPageViewController.h"

@implementation LNLabelBarViewController

@synthesize scrollView = _scrollView;

- (void)dealloc {
    [_scrollView release];
    [_labelPages release];
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
        page.view.frame = frame;
        [self.scrollView addSubview:page.view];
        [_labelPages addObject:page];
        [page release];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPages = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
