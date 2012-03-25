//
//  NewFeedData+NewFeedData_Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedData.h"

@interface NewFeedData (NewFeedData_Addition)

+ (NewFeedData *)insertNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
