//
//  NewFeedDetailBlogViewCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedDetailBlogViewCell.h"

@implementation NewFeedDetailBlogViewCell

-(void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei
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
