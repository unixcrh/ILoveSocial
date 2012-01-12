//
//  NewFeedShareAlbum+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-11.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedShareAlbum.h"

@interface NewFeedShareAlbum (Addition)
+ (NewFeedShareAlbum *)insertNewFeed:(int)sytle getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedShareAlbum *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
-(NSString*)getShareComment;
-(int)getAlbumQuan;
@end
