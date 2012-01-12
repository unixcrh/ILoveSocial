//
//  NewFeedSharePhoto.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedSharePhoto : NewFeedRootData

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * share_comment;
@property (nonatomic, retain) NSString * photo_comment;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * fromName;

@end
