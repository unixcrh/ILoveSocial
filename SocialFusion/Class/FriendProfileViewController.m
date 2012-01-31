//
//  FriendProfileViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-8-28.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "RenrenUser+Addition.h"
#import "RenrenStatus+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "User+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"

@interface FriendProfileViewController()
- (void)clearData;
@end

@implementation FriendProfileViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [Image clearAllCacheInContext:self.managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_type == RelationshipViewTypeRenrenFriends && self.renrenUser.friends.count > 0)
        return;
    [self refresh];
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSArray *descriptors;
    if(_type == RelationshipViewTypeRenrenFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.renrenUser.friends];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"pinyinName" ascending:YES] autorelease];
        NSSortDescriptor *sort2 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
        descriptors = [NSArray arrayWithObjects:sort, sort2, nil];
    }
    else if(_type == RelationshipViewTypeWeiboFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.weiboUser.friends];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES] autorelease];
        descriptors = [NSArray arrayWithObject:sort];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.weiboUser.followers];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES] autorelease];;
        descriptors = [NSArray arrayWithObject:sort];
    }
    [request setPredicate:predicate];
    
    [request setSortDescriptors:descriptors]; 
    
    request.fetchBatchSize = 20;
}

#pragma mark -
#pragma mark EGORefresh Method
- (void)refresh {
    [self hideLoadMoreDataButton];
    [self clearData];
    [self loadMoreData];
}

- (void)showHeadImageAnimation:(UIImageView *)imageView {
    imageView.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        imageView.alpha = 1;
    } completion:nil];
}

- (void)clearData
{
    if(_type == RelationshipViewTypeRenrenFriends) {
        _firstLoadFlag = YES;
        [self.renrenUser removeFriends:self.renrenUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFriends) {
        _nextCursor = -1;
        [self.weiboUser removeFriends:self.weiboUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        _nextCursor = -1;
        [self.weiboUser removeFollowers:self.weiboUser.followers];
    }
}

- (id)initWithType:(RelationshipViewType)type
{
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                RenrenUser *friend = [RenrenUser insertFriend:dict inManagedObjectContext:self.managedObjectContext];
                [self.renrenUser addFriendsObject:friend];
            }
            //NSLog(@"renren friend count:%d", array.count);
            //NSLog(@"add finished");
        }
        [self doneLoadingTableViewData];
        
        _loading = NO;
        
    }];
    [renren getFriendsProfile];
}

- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            NSArray *dictArray = [client.responseJSONObject objectForKey:@"users"];
            //NSLog(@"count:%d", [dictArray count]);
            for (NSDictionary *dict in dictArray) {
                WeiboUser *usr = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
                if (_type == RelationshipViewTypeWeiboFollowers) {
                    [self.weiboUser addFollowersObject:usr];
                }
                else if (_type == RelationshipViewTypeWeiboFriends) {
                    [self.weiboUser addFriendsObject:usr];
                }
            }
            _nextCursor = [[client.responseJSONObject objectForKey:@"next_cursor"] intValue];
            //NSLog(@"new cursor:%d", _nextCursor);
            if (_nextCursor == 0) {
                [self hideLoadMoreDataButton];
            }
            else {
                [self showLoadMoreDataButton];
            }
            [self doneLoadingTableViewData];
            _loading = NO;
        }
    }];
    if (_type == RelationshipViewTypeWeiboFriends) {
        [client getFriendsOfUser:self.weiboUser.userID cursor:_nextCursor count:20];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        [client getFollowersOfUser:self.weiboUser.userID cursor:_nextCursor count:20];
    }
}

- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    if(_type == RelationshipViewTypeRenrenFriends) {
        [self loadMoreRenrenData];
    }
    else {
        [self loadMoreWeiboData];
    }
}

// 优化显示，每次滑动停止才载入数据
- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
}

- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSTimeInterval i = 0;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        i += 0.05;
        [self performSelector:@selector(loadExtraDataForOnScreenRowsHelp:) withObject:indexPath afterDelay:i];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadExtraDataForOnscreenRows];
}

@end
