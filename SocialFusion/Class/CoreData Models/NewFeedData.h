//
//  NewFeedData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedData : NewFeedRootData

@property (nonatomic, retain) NSString * pic_big_URL;
@property (nonatomic, retain) NSString * pic_URL;
@property (nonatomic, retain) NSString * repost_Name;
@property (nonatomic, retain) NSString * repost_Status;
@property (nonatomic, retain) NSString * repost_StatusID;
@property (nonatomic, retain) NSString * repost_UserID;

@end
