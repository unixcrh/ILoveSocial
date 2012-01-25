//
//  NewFeedSelfListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-21.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedSelfListController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
@implementation NewFeedSelfListController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:@"NewFeedListController" bundle:nil];
    return self;
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
    [renren getNewFeed:_pageNumber uid:self.renrenUser.userID];
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
    [client getUserTimeline:self.weiboUser.userID SinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
}




- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    _pageNumber++;
    
    _currentTime=[[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    if (_style==kRenrenSelfFeed)
    {
        [self loadMoreRenrenData];
    }
    
    else if(_style==kWeiboSelfFeed)
    {
        [self loadMoreWeiboData];
    }
    
}
@end
