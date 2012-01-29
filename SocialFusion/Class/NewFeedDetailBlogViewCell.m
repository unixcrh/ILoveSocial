//
//  NewFeedDetailBlogViewCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedDetailBlogViewCell.h"

@implementation NewFeedDetailBlogViewCell

-(void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context
{
    detailController.feedData=_feedData;
    detailController.managedObjectContext=context;
    
    
    //  [self.contentView addSubview:detailController.view];
}



- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    
    
    [super dealloc];
}


@end
