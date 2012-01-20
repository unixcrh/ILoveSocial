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
@synthesize labelInfoArray = _labelInfoArray;

- (void)dealloc {
    [_scrollView release];
    [_labelPages release];
    [_labelInfoArray release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
}

- (void)createLabelPageAtIndex:(NSInteger)index {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    NSMutableArray *labelInfoSubArray = [NSMutableArray arrayWithArray:[self.labelInfoArray subarrayWithRange:
                                                                        NSMakeRange(index * 4, self.labelInfoArray.count < (index + 1) * 4 ? self.labelInfoArray.count - index * 4 : 4)]];
    LNLabelPageViewController *pageView = [[LNLabelPageViewController alloc] initWithInfoSubArray:labelInfoSubArray pageIndex:index];
    
    pageView.view.frame = frame;
    [self.scrollView addSubview:pageView.view];
    [_labelPages addObject:pageView];
    pageView.delegate = self;
    [pageView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageCount = _labelInfoArray.count / 4;
    if(_labelInfoArray.count % 4 != 0)
        _pageCount++;
    for (int i = 0; i < _pageCount; i++) {
        [self createLabelPageAtIndex:i];
    }
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _pageCount, self.scrollView.frame.size.height);
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPages = [[NSMutableArray alloc] init];
        _labelInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createLabelWithInfo:(LabelInfo *)info {
    [self.labelInfoArray addObject:info];
    if(self.labelInfoArray.count % 4 == 1) {
        _pageCount++;
        [self createLabelPageAtIndex:_pageCount - 1];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _pageCount, self.scrollView.frame.size.height);
        LNLabelPageViewController *page = [_labelPages objectAtIndex:_pageCount - 1];
        [page selectLastLabel];
    }
    else {
        LNLabelPageViewController *page = [_labelPages objectAtIndex:_pageCount - 1];
        [page activateLastLabel:info];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (_pageCount - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

#pragma mark -
#pragma mark LNLabelPageViewController delegate

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectLabelAtIndex:(NSUInteger)index {
    NSUInteger page = pageView.page;
    for (int i = 0; i < _pageCount; i++) {
        LNLabelPageViewController *pv = (LNLabelPageViewController *)[_labelPages objectAtIndex:i];
        [pv selectOtherPage:page];
    }
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didRemoveLabelAtIndex:(NSUInteger)index {
    [self.labelInfoArray removeObjectAtIndex:index];
    NSUInteger page = pageView.page;
    if(self.labelInfoArray.count % 4 == 0) {
        _pageCount--;
        LNLabelPageViewController *lastPage = [_labelPages lastObject];
        [lastPage.view removeFromSuperview];
        [_labelPages removeLastObject];
        if(page >= _pageCount)
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (_pageCount - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        else 
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _pageCount, self.scrollView.frame.size.height);
    }
    for(int i = page; i < _pageCount; i++) {
        NSMutableArray *labelInfoSubArray = [NSMutableArray arrayWithArray:[self.labelInfoArray subarrayWithRange:
                                                                            NSMakeRange(i * 4, self.labelInfoArray.count < (i + 1) * 4 ? self.labelInfoArray.count - i * 4 : 4)]];
        LNLabelPageViewController *pageView = [_labelPages objectAtIndex:i];
        pageView.labelInfoSubArray = labelInfoSubArray;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
     self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _pageCount, self.scrollView.frame.size.height);
}

@end
