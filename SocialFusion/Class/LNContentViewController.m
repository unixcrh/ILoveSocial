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
- (id)addContentViewWithIndentifer:(NSString *)identifer andUsers:(NSDictionary *)userDict;
@end

@implementation LNContentViewController

@synthesize contentViewControllerHeap = _contentViewControllerHeap;
@synthesize currentContentIndex = _currentContentIndex;

- (void)dealloc {
    [_contentViewControllerHeap release];
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
    }
    return self;
}

- (id)initWithlabelIdentifiers:(NSArray *)identifers andUsers:(NSDictionary *)userDict {
    self = [self init];
    if(self) {
        for(NSString *identifier in identifers) {
            id vc = [self addContentViewWithIndentifer:identifier andUsers:userDict];
            if(!vc)
                continue;
            [self.contentViewControllerHeap addObject:vc];
            if([vc isKindOfClass:[CoreDataViewController class]]) {
                ((CoreDataViewController *)vc).userDict = userDict;
            }
                
        }
    }
    return self;
}

- (id)addContentViewWithIndentifer:(NSString *)identifer andUsers:(NSDictionary *)userDict {
    id result = nil;
    if([identifer isEqualToString:kParentNewFeed]) {
        result = [NewFeedListController getNewFeedListControllerwithStyle:kAllUserFeed];
    }
    else if([identifer isEqualToString:kParentFriend]) {
        result = [[[FriendListViewController alloc] initWithType:RelationshipViewTypeRenrenFriends] autorelease];
    }
    else if([identifer isEqualToString:KParentUserInfo]) {
        
    }
    else if([identifer isEqualToString:kParentInbox]) {
        
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

@end
