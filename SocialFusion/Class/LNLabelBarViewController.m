//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelBarViewController.h"

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
    _pageCount = 3;
    for (int i = 0; i < _pageCount; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        LNLabelPageViewController *pageView = [[LNLabelPageViewController alloc] init];
        pageView.view.frame = frame;
        [self.scrollView addSubview:pageView.view];
        [_labelPages addObject:pageView];
        pageView.page = i;
        pageView.delegate = self;
        [pageView release];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _pageCount, self.scrollView.frame.size.height);
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectPageAtIndex:(NSUInteger)page {
    for (int i = 0; i < _pageCount; i++) {
        LNLabelPageViewController *pv = (LNLabelPageViewController *)[_labelPages objectAtIndex:i];
        [pv selectOtherPage:page];
    }
}

@end
