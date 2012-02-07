//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelBarViewController.h"
#import "LabelConverter.h"

@interface LNLabelBarViewController()
- (void)pushLabelPages:(NSMutableArray *)labelPages;
- (void)popLabelPages;
- (void)pushLabelInfoArray:(NSMutableArray *)infoArray;
- (void)popLabelInfoArray;
- (void)pushPageIndex:(NSUInteger)pageIndex;
- (void)popPageIndex;
- (void)popPageManually;
- (void)closeOpenPage;
@end

@implementation LNLabelBarViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageCount = _pageCount;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_scrollView release];
    [_labelPagesStack release];
    [_labelInfoArrayStack release];
    [_pageControl release];
    [_pageIndexStack release];
    [_popPageManuallyCompletion release];
    _delegate = nil;
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

- (void)loadLabelPages{
    self.pageCount = self.labelInfoArray.count / 4;
    if(self.labelInfoArray.count % 4 != 0)
        self.pageCount = self.pageCount + 1;
    for (int i = 0; i < self.pageCount; i++) {
        [self createLabelPageAtIndex:i];
    }
    [self refreshLabelBarContentSize];
    self.pageControl.currentPage = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self loadLabelPages];
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPagesStack = [[NSMutableArray alloc] init];
        NSMutableArray *labelPages = [[[NSMutableArray alloc] init] autorelease];
        [_labelPagesStack addObject:labelPages];
        _labelInfoArrayStack = [[NSMutableArray alloc] init];
        _pageIndexStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithLabelInfoArray:(NSArray *)infoArray {
    self = [self init];
    if(self) {
        [self pushLabelInfoArray:[NSMutableArray arrayWithArray:infoArray]];
    }
    return self;
}

- (void)popPageManuallyWithCompletion:(void (^)(void))completion {
    _popPageManuallyCompletion = [completion copy];
    if(_pageIndexStack.count != 0) {
        [self popPageManually];
    }
    else {
        _popPageManuallyCompletion();
        [_popPageManuallyCompletion release];
        _popPageManuallyCompletion = nil;
    }
}

- (void)createLabelWithInfo:(LabelInfo *)info {
    if(_selectUserLock) 
        return;
    _selectUserLock = YES;
    [self popPageManuallyWithCompletion:^{
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
        _selectUserLock = NO;
    }];
    
}

- (void)selectLabelAtIndex:(NSUInteger)labelToSelectIndex {
    NSUInteger labelToSelectPage = labelToSelectIndex / 4;
    NSUInteger labelToSelectIndexInPage = labelToSelectIndex % 4;
    LNLabelPageViewController *labelPageToSelect = [self.labelPages objectAtIndex:labelToSelectPage];
    LNLabelViewController *labelToSelect = [labelPageToSelect.labelViews objectAtIndex:labelToSelectIndexInPage];
    [labelToSelect clickTitleButton:nil];
}

#pragma mark -
#pragma mark LNLabelPageViewController delegate

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectLabel:(LNLabelViewController *)label {
    NSUInteger page = pageView.page;
    for (int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *pv = (LNLabelPageViewController *)[self.labelPages objectAtIndex:i];
        [pv selectOtherPage:page];
    }
    if(label.isParentLabel && [self.delegate respondsToSelector:@selector(labelBarView: didSelectParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didSelectParentLabelAtIndex:page * 4 + label.index];
    }
    else if(label.isChildLabel && [self.delegate respondsToSelector:@selector(labelBarView: didSelectChildLabelWithIndentifier: inParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didSelectChildLabelWithIndentifier:label.info.identifier inParentLabelAtIndex:_currentParentLabelIndex];
    }
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didRemoveLabel:(LNLabelViewController *)removedLabel {
    NSUInteger index = pageView.page * 4 + removedLabel.index;
    NSUInteger page = pageView.page;
    [self.labelInfoArray removeObjectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(labelBarView:didRemoveParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didRemoveParentLabelAtIndex:index];
    }
    
    if(removedLabel.isSelected) {
        [self selectLabelAtIndex:index - 1];
    }
    
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
    _currentParentLabelIndex = pageView.page * 4 + label.index;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    NSMutableArray *labelPages = [[[NSMutableArray alloc]init] autorelease];
    [self pushLabelPages:labelPages];
    [self pushPageIndex:pageView.page];
    NSString *identifier = label.info.identifier;
    NSArray *labelInfo = [LabelConverter getChildLabelsInfoWithParentLabelIndentifier:identifier andParentLabelName:label.labelName];
    LabelInfo *returnLabelInfo = [labelInfo objectAtIndex:0];
    returnLabelInfo.bgImage = label.info.bgImage;
    [self pushLabelInfoArray:[NSMutableArray arrayWithArray:labelInfo]];
    [self loadLabelPages];
    LNLabelPageViewController *firstPage = [self.labelPages objectAtIndex:0];
    if([self.delegate respondsToSelector:@selector(labelBarView:didOpenParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didOpenParentLabelAtIndex:_currentParentLabelIndex];
    }
    [firstPage openLabelPostAnimation];
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didCloseLabel:(LNLabelViewController *)label {
    NSUInteger pageIndex = self.pageIndex;
    [self popLabelInfoArray];
    [self popPageIndex];
    [self popLabelPages];
    [_scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * pageIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    self.pageControl.currentPage = pageIndex;
    LNLabelPageViewController *page = [self.labelPages objectAtIndex:pageIndex];
    [page closeParentLabelAnimation];
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didFinishCloseLabel:(LNLabelViewController *)label {
    if(_popPageManuallyCompletion) {
        _popPageManuallyCompletion();
        [_popPageManuallyCompletion release];
        _popPageManuallyCompletion = nil;
    }
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshLabelBarContentSize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetX = scrollView.contentOffset.x;
    int inaccuracy = offsetX % (int)scrollView.frame.size.width;
    offsetX -= inaccuracy;
    [scrollView setContentOffset:CGPointMake(offsetX, scrollView.contentOffset.y) animated:NO];
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

- (NSMutableArray *)labelInfoArray {
    return _labelInfoArrayStack.lastObject;
}

- (NSUInteger)pageIndex {
    return ((NSNumber *)_pageIndexStack.lastObject).unsignedIntValue;
}

- (void)pushLabelPages:(NSMutableArray *)labelPages {
    for(int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [page.view removeFromSuperview];
    }
    if(labelPages != nil)
        [_labelPagesStack addObject:labelPages];
}

- (void)popLabelPages {
    [self pushLabelPages:nil];
    [_labelPagesStack removeLastObject];
    self.pageCount = self.labelPages.count;
    [self refreshLabelBarContentSize];
    for(int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [_scrollView addSubview:page.view];
    }
}

- (void)pushLabelInfoArray:(NSMutableArray *)infoArray {
    [_labelInfoArrayStack addObject:infoArray];
}

- (void)popLabelInfoArray {
    [_labelInfoArrayStack removeLastObject];
}

- (void)pushPageIndex:(NSUInteger)pageIndex {
    [_pageIndexStack addObject:[NSNumber numberWithUnsignedInteger:pageIndex]];
}

- (void)popPageIndex {
    [_pageIndexStack removeLastObject];
}

- (void)closeOpenPage {
    LNLabelPageViewController *page = [self.labelPages objectAtIndex:0];
    [page closePageWithReturnLabel:nil];
}

- (void)movePageToTopWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)popPageManually {
    if(self.pageControl.currentPage == 0) {
        [self closeOpenPage];
    }
    else {
        [self movePageToTopWithCompletion:^{
            [self closeOpenPage];
        }];
    }
}

- (void)selectParentLabelAtIndex:(NSUInteger)index {
    if(_selectUserLock) 
        return;
    _selectUserLock = YES;
    [self popPageManuallyWithCompletion:^{
        [self selectLabelAtIndex:index];
        NSUInteger page = index / 4;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * page, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        _selectUserLock = NO;
    }];
}

- (void)selectChildLabelWithIdentifier:(NSString *)identifier {
    if(_pageIndexStack.count <= 0) 
        return;
    [self.labelInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LabelInfo *info = obj;
        if ([info.identifier isEqualToString:identifier]) {
            [self selectLabelAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (NSUInteger)parentLabelCount {
    return ((NSArray *)[_labelInfoArrayStack objectAtIndex:0]).count;
}

@end
