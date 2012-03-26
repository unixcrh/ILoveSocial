//
//  NewFeedSharePhotoandAlbum+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-25.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedSharePhotoandAlbum+Addition.h"

@implementation NewFeedSharePhotoandAlbum (Addition)

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    self.pic_big_URL = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"raw_src"];
    
    self.pic_URL = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    self.comment = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"content"];
    
    self.maininfo_ID = [[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];
    
    self.maininfo = [dict objectForKey:@"prefix"];
    self.album_Title = [dict objectForKey:@"title"];
    
    self.album_ID = [[dict objectForKey:@"source_id"] stringValue];
    
    
}


+ (NewFeedSharePhotoandAlbum *)insertNewFeed:(int)style getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedSharePhotoandAlbum *result = [NewFeedSharePhotoandAlbum feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedSharePhotoandAlbum" inManagedObjectContext:context];
    }    
    
    [result configureNewFeed:style height:0 getDate:getDate Dic:dict inManagedObjectContext:context];
    
    
    return result;
}


+ (NewFeedSharePhotoandAlbum *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedSharePhotoandAlbum" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedSharePhotoandAlbum *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}
@end
