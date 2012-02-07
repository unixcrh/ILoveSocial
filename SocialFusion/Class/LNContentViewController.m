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

#define SCROLL_VIEW_WIDTH self.scrollView.frame.size.width

@interface LNContentViewController()
- (id)addContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict;
@property (nonatomic, retain) NSMutableArray *contentViewIndentifierHeap;
@end

@implementation LNContentViewController

@synthesize scrollView = _scrollView;
@synthesize contentViewControllerHeap = _contentViewControllerHeap;
@synthesize currentContentIndex = _currentContentIndex;
@synthesize contentViewIndentifierHeap = _contentViewIndentifierHeap;

- (void)dealloc {
    [_contentViewControllerHeap release];
    [_contentViewIndentifierHeap release];
    [_scrollView release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshScrollViewContentSize];
    [self.contentViewControllerHeap enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = obj;
        CGRect frame = vc.view.frame;
        frame.origin.x = SCROLL_VIEW_WIDTH * idx;
        vc.view.frame = frame;
        [self.scrollView addSubview:vc.view];
    }];
}

- (id)init {
    self = [super init];
    if(self) {
        _contentViewControllerHeap = [[NSMutableArray alloc] init];
        _contentViewIndentifierHeap = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithlabelIdentifiers:(NSArray *)identifiers andUsers:(NSDictionary *)userDict {
    self = [self init];
    if(self) {
        for(NSString *identifier in identifiers) {
            [self addUserContentViewWithIndentifier:identifier andUsers:userDict];
        }
    }
    return self;
}

- (void)addContentViewToScrollView {
    [self refreshScrollViewContentSize];
    UIViewController *vc = [self.contentViewControllerHeap lastObject];
    CGRect frame = vc.view.frame;
    frame.origin.x = SCROLL_VIEW_WIDTH * (self.contentViewCount - 1);
    vc.view.frame = frame;
    [self.scrollView addSubview:vc.view];
}

- (void)removeContentViewAtIndexFromScrollView:(NSUInteger)index {
    [self refreshScrollViewContentSize];
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
    UIViewController *vc = [self.contentViewControllerHeap objectAtIndex:_currentContentIndex];
    [vc.view removeFromSuperview];
    _currentContentIndex = currentContentIndex;
    vc = [self.contentViewControllerHeap objectAtIndex:_currentContentIndex];
    [self.view addSubview:vc.view];
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
    [vc.view removeFromSuperview];
    [self.view addSubview:vc2.view];
    [self.contentViewControllerHeap replaceObjectAtIndex:index withObject:vc2];
    [self.contentViewIndentifierHeap replaceObjectAtIndex:index withObject:identifier];
}

- (void)addUserContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict {
    NSString *childIdentifier = [LabelConverter getDefaultChildIdentifierWithParentIdentifier:identifier];
    id vc = [self addContentViewWithIndentifier:childIdentifier andUsers:userDict];
    if(!vc)
        return;
    [self.contentViewControllerHeap addObject:vc];
    [self.contentViewIndentifierHeap addObject:childIdentifier];
}

- (void)removeContentViewAtIndex:(NSUInteger)index {
    UIViewController *vc = [self.contentViewControllerHeap objectAtIndex:index];
    if(self.currentContentIndex == index)
        [vc.view removeFromSuperview];
    [self.contentViewControllerHeap removeObjectAtIndex:index];
    [self.contentViewIndentifierHeap removeObjectAtIndex:index];
    if(index == _currentContentIndex) {
        vc = [self.contentViewControllerHeap objectAtIndex:_currentContentIndex - 1];
        [self.view addSubview:vc.view];
    }
    _currentContentIndex--;
}

- (NSString *)currentContentIdentifierAtIndex:(NSUInteger)index {
    NSString *result = [self.contentViewIndentifierHeap objectAtIndex:index];
    return result;
}

@end
