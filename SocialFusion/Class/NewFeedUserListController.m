//
//  NewFeedUserListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-21.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedUserListController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
@implementation NewFeedUserListController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:@"NewFeedListController" bundle:nil];
    return self;
}

- (void)clearData
{
    
    _noAnimationFlag = YES;
    [self.processRenrenUser removeStatuses:self.processRenrenUser.statuses];
    
    [self.processWeiboUser removeStatuses:self.processWeiboUser.statuses];
    
}

- (WeiboUser *)processWeiboUser {
    return self.weiboUser;
}

- (RenrenUser *)processRenrenUser {
    return self.renrenUser;
}

-(NSPredicate *)customPresdicate {
    NSPredicate *predicate;
    if(_style == kRenrenUserFeed) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processRenrenUser.statuses];
    }
    else if(_style == kWeiboUserFeed) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processWeiboUser.statuses];
    }
    return predicate;
}

- (void)addNewWeiboData:(NewFeedRootData *)data {
    [self.processWeiboUser addStatusesObject:data];
}

- (void)addNewRenrenData:(NewFeedRootData *)data {
    [self.processRenrenUser addStatusesObject:data];
}

- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];
    
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            [self processRenrenData:array];
            
        }
    }];
    [renren getNewFeed:_pageNumber uid:self.processRenrenUser.userID];
}


- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            
            NSArray *array = client.responseJSONObject;
            
            [self processWeiboData:array];
        }
    }];
    
    // [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
    [client getUserTimeline:self.processWeiboUser.userID SinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
}

- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    _pageNumber++;
    
    _currentTime=[[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    if (_style==kRenrenUserFeed)
    {
        [self loadMoreRenrenData];
    }
    else if(_style==kWeiboUserFeed)
    {
        [self loadMoreWeiboData];
    }
    
}
@end
