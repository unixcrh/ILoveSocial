//
//  NewFeedPhoto+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedPhoto.h"

@interface NewFeedPhoto (Addition)
+ (NewFeedPhoto *)insertNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedPhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
