//
//  NewFeedPhoto.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedPhoto : NewFeedRootData

@property (nonatomic, retain) NSString * album_ID;
@property (nonatomic, retain) NSString * album_Title;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * pic_big_URL;
@property (nonatomic, retain) NSString * pic_URL;

@end
