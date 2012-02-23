//
//  LNContentViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LNContentViewController.h"
#import "LabelConverter.h"
#import "CoreDataViewController.h"
#import "User.h"
#import "PublicationViewController.h"
#import "NewFeedListController.h"
#import "FriendListViewController.h"
#import "UserInfoViewController.h"

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
@synthesize bgView = _bgView;

- (void)dealloc {
    [_contentViewControllerHeap release];
    [_contentViewIndentifierHeap release];
    [_scrollView release];
    [_bgView release];
    self.delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.bgView = nil;
}

- (void)refreshScrollViewContentSize {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.contentViewCount, self.scrollView.frame.size.height);
}

- (void)scrollContentViewAtIndexPathToVisble:(NSUInteger)index animated:(BOOL)animate{
    if(animate)
        animate = abs(index - _currentContentIndex) <= 2 && index / 4 == _currentContentIndex / 4 ? YES : NO;
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
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0f;
    
    self.scrollView.scrollsToTop = NO;
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
    else if([identifier isEqualToString:kChildWeiboFriend] || [identifier isEqualToString:kChildCurrentWeiboFriend]) {
        result = result = [FriendListViewController getNewFeedListControllerWithType:RelationshipViewTypeWeiboFriends];
    }
    else if([identifier isEqualToString:kChildWeiboFollower] || [identifier isEqualToString:kChildCurrentWeiboFollower]) {
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
    else if([identifier isEqualToString:kChildWeiboInfo] || [identifier isEqualToString:kChildCurrentWeiboInfo]) {
        result = [UserInfoViewController getUserInfoViewControllerWithType:kWeiboUserInfo];
    }
    else if([identifier isEqualToString:kChildRenrenInfo] || [identifier isEqualToString:kChildCurrentRenrenInfo]) {
        result = [UserInfoViewController getUserInfoViewControllerWithType:kRenrenUserInfo];
    }
    else {
        NSLog(@"nil identifier:%@", identifier);
        abort();
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
    
    UIViewController *oldVC = [_contentViewControllerHeap objectAtIndex:_currentContentIndex];
    UIViewController *newVC = [_contentViewControllerHeap objectAtIndex:currentContentIndex];
    if([oldVC isKindOfClass:[EGOTableViewController class]]) {
        EGOTableViewController *vc = (EGOTableViewController *)oldVC;
        vc.tableView.scrollsToTop = NO;
    }
    if([newVC isKindOfClass:[EGOTableViewController class]]) {
        EGOTableViewController *vc = (EGOTableViewController *)newVC;
        vc.tableView.scrollsToTop = YES;
    }

    _currentContentIndex = currentContentIndex;
}

- (NSUInteger)contentViewCount {
    return self.contentViewControllerHeap.count;
}

- (BOOL)isFake{
    return (self.contentViewCount == 0);
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
    if(identifier == nil) {
        NSLog(@"replaceObjectAtIndex! identifier nil!");
        abort();
    }
    vc2.view.frame = vc.view.frame;
    [vc.view removeFromSuperview];
    [self.scrollView addSubview:vc2.view];
    [self.contentViewControllerHeap replaceObjectAtIndex:index withObject:vc2];
    [self.contentViewIndentifierHeap replaceObjectAtIndex:index withObject:identifier];
    
    if([vc2 isKindOfClass:[EGOTableViewController class]]) {
        EGOTableViewController *vc = (EGOTableViewController *)vc2;
        vc.tableView.scrollsToTop = YES;
    }
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

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.currentContentIndex = index;
    if(index < 0 || index >= self.contentViewCount)
        return;
    if([self.delegate respondsToSelector:@selector(contentViewController:didScrollToIndex:)]) {
        [self.delegate contentViewController:self didScrollToIndex:index];
    }
}

@end
