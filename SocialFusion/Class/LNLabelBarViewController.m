//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelBarViewController.h"

@interface LNLabelBarViewController()
- (void)pushLabelPages:(NSMutableArray *)labelPages;
- (void)popLabelPages;
@end

@implementation LNLabelBarViewController

@synthesize scrollView = _scrollView;
@synthesize labelInfoArray = _labelInfoArray;
@synthesize pageControl = _pageControl;
@synthesize pageCount = _pageCount;

- (void)dealloc {
    [_scrollView release];
    [_labelPagesStack release];
    [_labelInfoArray release];
    [_pageControl release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.pageControl = nil;
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
    [self.labelPages addObject:pageView];
    pageView.delegate = self;
    [pageView release];
}

- (void)refreshLabelBarContentSize {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount + 1, self.scrollView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageCount = _labelInfoArray.count / 4;
    if(_labelInfoArray.count % 4 != 0)
        self.pageCount = self.pageCount + 1;
    for (int i = 0; i < self.pageCount; i++) {
        [self createLabelPageAtIndex:i];
    }
    self.scrollView.delegate = self;
    [self refreshLabelBarContentSize];
    self.pageControl.numberOfPages = self.pageCount;
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPagesStack = [[NSMutableArray alloc] init];
        NSMutableArray *labelPages = [[NSMutableArray alloc] init];
        [_labelPagesStack addObject:labelPages];
        _labelInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createLabelWithInfo:(LabelInfo *)info {
    [self.labelInfoArray addObject:info];
    if(self.labelInfoArray.count % 4 == 1) {
        self.pageCount = self.pageCount + 1;
        [self createLabelPageAtIndex:self.pageCount - 1];
        [self refreshLabelBarContentSize];
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:self.pageCount - 1];
        [page selectLastLabel];
    }
    else {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:self.pageCount - 1];
        [page activateLastLabel:info];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (self.pageCount - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    self.pageControl.currentPage = self.pageCount;
}

#pragma mark -
#pragma mark LNLabelPageViewController delegate

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectLabel:(LNLabelViewController *)label {
    NSUInteger page = pageView.page;
    for (int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *pv = (LNLabelPageViewController *)[self.labelPages objectAtIndex:i];
        [pv selectOtherPage:page];
    }
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didRemoveLabel:(LNLabelViewController *)label {
    NSUInteger index = pageView.page * 4 + label.index;
    if(label.isSelected) {
        NSUInteger labelToSelectIndex = index - 1;
        NSUInteger labelToSelectPage = labelToSelectIndex / 4;
        NSUInteger labelToSelectIndexInPage = labelToSelectIndex % 4;
        LNLabelPageViewController *labelPageToSelect = [self.labelPages objectAtIndex:labelToSelectPage];
        LNLabelViewController *labelToSelect = [labelPageToSelect.labelViews objectAtIndex:labelToSelectIndexInPage];
        [labelToSelect clickTitleButton:nil];
    }
    
    NSUInteger page = pageView.page;
    [self.labelInfoArray removeObjectAtIndex:index];
    
    if(self.labelInfoArray.count % 4 == 0) {
        self.pageCount = self.pageCount - 1;
        LNLabelPageViewController *lastPage = [self.labelPages lastObject];
        [lastPage.view removeFromSuperview];
        [self.labelPages removeLastObject];
        if(page >= self.pageCount)
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (self.pageCount - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        else 
            [self refreshLabelBarContentSize];
    }
    
    for(int i = page; i < self.pageCount; i++) {
        NSMutableArray *labelInfoSubArray = [NSMutableArray arrayWithArray:[self.labelInfoArray subarrayWithRange:
                                                                            NSMakeRange(i * 4, self.labelInfoArray.count < (i + 1) * 4 ? self.labelInfoArray.count - i * 4 : 4)]];
        LNLabelPageViewController *pageView = [self.labelPages objectAtIndex:i];
        pageView.labelInfoSubArray = labelInfoSubArray;
    }
    for(int i = 0; i < self.pageCount; i++) {
        for(int j = 0; j < 4; j++) {
            LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
            LNLabelViewController *label = [page.labelViews objectAtIndex:j];
            if(label.isSelected) {
                [label clickTitleButton:nil];
            }
        }
    }
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didOpenLabel:(LNLabelViewController *)label {
    
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didCloseLabel:(LNLabelViewController *)label {
    [self popLabelPages];
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshLabelBarContentSize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

- (void)setPageCount:(NSUInteger)pageCount {
    _pageCount = pageCount;
    self.pageControl.numberOfPages = pageCount;
}

- (NSMutableArray *)labelPages {
    return _labelPagesStack.lastObject;
}

- (void)pushLabelPages:(NSMutableArray *)labelPages {
    [_labelPagesStack addObject:labelPages];
}

- (void)popLabelPages {
    [_labelPagesStack removeLastObject];
}

@end
