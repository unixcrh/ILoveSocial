//
//  NewFeedBlog.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedBlog : NewFeedRootData

@property (nonatomic, retain) NSString * blog_Description;
@property (nonatomic, retain) NSString * share_BlogID;
@property (nonatomic, retain) NSString * share_UserID;
@property (nonatomic, retain) NSString * title;

@end
