//
//  NewFeedSharePhotoandAlbum.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedPhoto.h"


@interface NewFeedSharePhotoandAlbum : NewFeedPhoto

@property (nonatomic, retain) NSString * from_ID;
@property (nonatomic, retain) NSString * from_Name;
@property (nonatomic, retain) NSString * from_UserID;

@end
