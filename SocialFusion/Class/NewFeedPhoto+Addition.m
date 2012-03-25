//
//  NewFeedPhoto+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedPhoto+Addition.h"

@implementation NewFeedPhoto (Addition)
- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
}

+ (NewFeedPhoto *)insertNewFeed:(int)style  height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedPhoto *result = [NewFeedPhoto feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedPhoto" inManagedObjectContext:context];
    }
    
    [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    return result;
    
    // 将自己添加到对应user的statuses里
    // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
    // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
    
    
}


+ (NewFeedPhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedPhoto" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedPhoto *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}


@end
