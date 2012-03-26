//
//  NewFeedSharePhotoandAlbum+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedSharePhotoandAlbum.h"

@interface NewFeedSharePhotoandAlbum (Addition)
+ (NewFeedSharePhotoandAlbum *)insertNewFeed:(int)sytle getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedSharePhotoandAlbum *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
