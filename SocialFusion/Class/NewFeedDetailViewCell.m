//
//  NewFeedDetailViewCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedDetailViewCell.h"

@implementation NewFeedDetailViewCell



- (void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei
{
    detailController.feedData=_feedData;
    detailController.managedObjectContext=context;
    detailController.currentRenrenUser=ren;
    detailController.currentWeiboUser=wei;
    
  //  [self.contentView addSubview:detailController.view];
}



- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");

    
    [super dealloc];
}


@end
