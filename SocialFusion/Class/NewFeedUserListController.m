//
//  NewFeedUserListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-21.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedUserListController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
@implementation NewFeedUserListController



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
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            
            [self processWeiboData:array];
        }
    }];
    
   // [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
    [client getUserTimeline:self.weiboUser.userID SinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
}


-(void)setStyle:(int)style
{
    _style=style;
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
