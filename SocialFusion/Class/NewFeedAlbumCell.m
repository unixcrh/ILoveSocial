//
//  NewFeedAlbumCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedAlbumCell.h"

@implementation NewFeedAlbumCell

- (void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei
{
    detailController.feedData=_feedData;
    detailController.managedObjectContext=context;
    detailController.currentRenrenUser=ren;
    detailController.currentWeiboUser=wei;
    
}




- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    
    [detailController release];
    [super dealloc];
}


@end
