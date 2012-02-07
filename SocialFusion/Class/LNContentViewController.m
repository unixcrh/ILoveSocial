//
//  LNContentViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNContentViewController.h"
#import "LabelConverter.h"
#import "CoreDataViewController.h"
#import "User.h"
#import "PublicationViewController.h"
#import "NewFeedListController.h"
#import "FriendListViewController.h"

@interface LNContentViewController()
- (id)addContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict;
@property (nonatomic, retain) NSMutableArray *contentViewIndentifierHeap;
@end

@implementation LNContentViewController

@synthesize scrollView = _scrollView;
@synthesize contentViewControllerHeap = _contentViewControllerHeap;
@synthesize currentContentIndex = _currentContentIndex;
@synthesize contentViewIndentifierHeap = _contentViewIndentifierHeap;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_contentViewControllerHeap release];
    [_contentViewIndentifierHeap release];
    [_scrollView release];
    self.delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
}

- (void)refreshScrollViewContentSize {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.contentViewCount, self.scrollView.frame.size.height);
}

- (void)scrollContentViewAtIndexPathToVisble:(NSUInteger)index animated:(BOOL)animate{
    if(animate)
        animate = abs(index - _currentContentIndex) > 3 ? NO : YES;
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * index, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:animate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshScrollViewContentSize];
    [self.contentViewControllerHeap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = obj;
        CGRect frame = vc.view.frame;
        frame.origin.x = self.scrollView.frame.size.width * idx;
        vc.view.frame = frame;
        [self.scrollView addSubview:vc.view];
    }];
    self.scrollView.delegate = self;
}

- (id)init {
    self = [super init];
    if(self) {
        _contentViewControllerHeap = [[NSMutableArray alloc] init];
        _contentViewIndentifierHeap = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithLabelIdentifiers:(NSArray *)identifiers andUsers:(NSDictionary *)userDict {
    self = [self init];
    if(self) {
        for(NSString *identifier in identifiers) {
            [self addUserContentViewWithIndentifier:identifier andUsers:userDict];
        }
    }
    return self;
}

- (void)addLastContentViewToScrollView {
    [self refreshScrollViewContentSize];
    UIViewController *vc = [self.contentViewControllerHeap lastObject];
    CGRect frame = vc.view.frame;
    frame.origin.x = self.scrollView.frame.size.width * (self.contentViewCount - 1);
    vc.view.frame = frame;
    [self.scrollView addSubview:vc.view];
}

- (void)removeContentViewAtIndexFromScrollView:(NSUInteger)index {
    UIViewController *vc = [self.contentViewControllerHeap objectAtIndex:index];
    [vc.view removeFromSuperview];
    [self.contentViewControllerHeap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx > index) {
            UIViewController *vc = obj;
            CGRect frame = vc.view.frame;
            frame.origin.x -= self.scrollView.frame.size.width;
            vc.view.frame = frame;
        }
    }];
    [self.contentViewControllerHeap removeObjectAtIndex:index];
    [self refreshScrollViewContentSize];
    if(_currentContentIndex == index) {
        [self scrollContentViewAtIndexPathToVisble:_currentContentIndex - 1 animated:YES];
    }

}

- (id)addContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict {
    id result = nil;
    if([identifier isEqualToString:kChildAllSelfNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kAllSelfFeed];
    }
    else if([identifier isEqualToString:kChildRenrenSelfNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kRenrenSelfFeed];
    }
    else if([identifier isEqualToString:kChildWeiboSelfNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kWeiboSelfFeed];
    }
    else if([identifier isEqualToString:kChildRenrenFriend]) {
        result = [FriendListViewController getNewFeedListControllerWithType:RelationshipViewTypeRenrenFriends];
    }
    else if([identifier isEqualToString:kChildWeiboFriend]) {
        result = result = [FriendListViewController getNewFeedListControllerWithType:RelationshipViewTypeWeiboFriends];
    }
    else if([identifier isEqualToString:kChildWeiboFollower]) {
        result = [FriendListViewController getNewFeedListControllerWithType:RelationshipViewTypeWeiboFollowers];
    }
    else if([identifier isEqualToString:kChildRenrenNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kRenrenUserFeed];
    }
    else if([identifier isEqualToString:kChildWeiboNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kWeiboUserFeed];
    }
    else if([identifier isEqualToString:kParentPublication]) {
        result = [[[PublicationViewController alloc] init] autorelease];
    }
    // test code
    else {
        NSLog(@"nil identifier:%@", identifier);
        result = [NewFeedListController getNewFeedListControllerwithStyle:kAllSelfFeed];
    }
    if([result isKindOfClass:[CoreDataViewController class]]) {
        ((CoreDataViewController *)result).userDict = userDict;
    }
    return result;
}

- (void)setCurrentContentIndex:(NSUInteger)currentContentIndex {
    if(currentContentIndex >= self.contentViewControllerHeap.count)
        return;
    if(currentContentIndex == _currentContentIndex)
        return;
    [self scrollContentViewAtIndexPathToVisble:currentContentIndex animated:YES];
    _currentContentIndex = currentContentIndex;
}

- (NSUInteger)contentViewCount {
    return self.contentViewControllerHeap.count;
}

- (void)setContentViewAtIndex:(NSUInteger)index forIdentifier:(NSString *)identifier {
    if(index >= self.contentViewControllerHeap.count)
        return;
    NSString *currentIdentifier = [self.contentViewIndentifierHeap objectAtIndex:index];
    if([currentIdentifier isEqualToString:identifier])
        return;
    CoreDataViewController *vc = [self.contentViewControllerHeap objectAtIndex:index];
    CoreDataViewController *vc2 = [self addContentViewWithIndentifier:identifier andUsers:vc.userDict];
    if(vc2 == nil)
        return;
    vc2.view.frame = vc.view.frame;
    [vc.view removeFromSuperview];
    [self.scrollView addSubview:vc2.view];
    [self.contentViewControllerHeap replaceObjectAtIndex:index withObject:vc2];
    [self.contentViewIndentifierHeap replaceObjectAtIndex:index withObject:identifier];
}

- (void)addUserContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict {
    NSString *childIdentifier = [LabelConverter getDefaultChildIdentifierWithParentIdentifier:identifier];
    id vc = [self addContentViewWithIndentifier:childIdentifier andUsers:userDict];
    if(!vc)
        return;
    [self.contentViewControllerHeap addObject:vc];
    [self addLastContentViewToScrollView];
    [self.contentViewIndentifierHeap addObject:childIdentifier];
}

- (void)removeContentViewAtIndex:(NSUInteger)index {
    [self removeContentViewAtIndexFromScrollView:index];
    [self.contentViewIndentifierHeap removeObjectAtIndex:index];
    if(_currentContentIndex >= index)
        _currentContentIndex--;
}

- (NSString *)currentContentIdentifierAtIndex:(NSUInteger)index {
    NSString *result = [self.contentViewIndentifierHeap objectAtIndex:index];
    return result;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    if(index < 0 || index > self.contentViewCount)
        return;
    if([self.delegate respondsToSelector:@selector(contentViewController:didScrollToIndex:)]) {
        [self.delegate contentViewController:self didScrollToIndex:index];
    }
}

@end
