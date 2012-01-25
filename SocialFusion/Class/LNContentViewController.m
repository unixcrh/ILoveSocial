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

#import "NewFeedListController.h"
#import "FriendListViewController.h"

@interface LNContentViewController()
- (id)addContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict;
@property (nonatomic, retain) NSMutableArray *contentViewIndentifierHeap;
@end

@implementation LNContentViewController

@synthesize contentViewControllerHeap = _contentViewControllerHeap;
@synthesize currentContentIndex = _currentContentIndex;
@synthesize contentViewIndentifierHeap = _contentViewIndentifierHeap;

- (void)dealloc {
    [_contentViewControllerHeap release];
    [_contentViewIndentifierHeap release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *vc = [self.contentViewControllerHeap objectAtIndex:0];
    if(vc) {
        _currentContentIndex = 0;
        [self.view addSubview:vc.view];
    }
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
            NSString *childIdentifier = [LabelConverter getDefaultChildIdentifierWithParentIdentifier:identifier];
            id vc = [self addContentViewWithIndentifier:childIdentifier andUsers:userDict];
            if(!vc)
                continue;
            [self.contentViewControllerHeap addObject:vc];
            [self.contentViewIndentifierHeap addObject:childIdentifier];
        }
    }
    return self;
}

- (id)addContentViewWithIndentifier:(NSString *)identifier andUsers:(NSDictionary *)userDict {
    id result = nil;
    if([identifier isEqualToString:kChildAllNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kAllUserFeed];
    }
    else if([identifier isEqualToString:kChildRenrenNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kRenrenSelfFeed];
    }
    else if([identifier isEqualToString:kChildWeiboNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kWeiboSelfFeed];
    }
    else if([identifier isEqualToString:kChildRenrenFriend]) {
        result = [[[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends] autorelease];
    }
    else if([identifier isEqualToString:kChildWeiboFriend]) {
        result = [[[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFriends] autorelease];
    }
    else if([identifier isEqualToString:kChildWeiboFollower]) {
        result = [[[FriendListViewController alloc] initWithType:RelationshipViewTypeWeiboFollowers] autorelease];
    }
    else if([identifier isEqualToString:KParentUserInfo]) {
        
    }
    else if([identifier isEqualToString:kParentInbox]) {
        
    }
    if([result isKindOfClass:[CoreDataViewController class]]) {
        ((CoreDataViewController *)result).userDict = userDict;
    }
    return result;
}

- (void)setCurrentContentIndex:(NSUInteger)currentContentIndex {
    if(currentContentIndex >= self.contentViewControllerHeap.count)
        return;
    UIViewController *vc = [self.contentViewControllerHeap objectAtIndex:_currentContentIndex];
    [vc.view removeFromSuperview];
    _currentContentIndex = currentContentIndex;
    vc = [self.contentViewControllerHeap objectAtIndex:_currentContentIndex];
    [self.view addSubview:vc.view];
}

- (void)setContentViewAtIndex:(NSUInteger)index forIdentifier:(NSString *)identifier {
    if(index >= self.contentViewControllerHeap.count)
        return;
    NSString *currentIdentifier = [self.contentViewIndentifierHeap objectAtIndex:index];
    if([currentIdentifier isEqualToString:identifier])
        return;
    CoreDataViewController *vc = [self.contentViewControllerHeap objectAtIndex:index];
    [vc.view removeFromSuperview];
    vc = [self addContentViewWithIndentifier:identifier andUsers:vc.userDict];
    [self.view addSubview:vc.view];
    [self.contentViewControllerHeap replaceObjectAtIndex:index withObject:vc];
    [self.contentViewIndentifierHeap replaceObjectAtIndex:index withObject:identifier];
}

@end
