//
//  NewFeedShareAlbum+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-11.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedShareAlbum+Addition.h"

@implementation NewFeedShareAlbum (Addition)

+ (NewFeedShareAlbum *)insertNewFeed:(int)sytle  height:(int)height getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedShareAlbum *result = [NewFeedShareAlbum feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedShareAlbum" inManagedObjectContext:context];
    }
    
    
    result.post_ID = statusID;
    
    
    result.style=[NSNumber numberWithInt:sytle];
    
    
    result.actor_ID=[[dict objectForKey:@"actor_id"] stringValue];
    
    
    result.owner_Head= [dict objectForKey:@"headurl"] ;
    
    result.owner_Name=[dict objectForKey:@"name"] ;
    
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* dateString=[dict objectForKey:@"update_time"];
    result.update_Time=[form dateFromString: dateString];
    
    
    [form release];
    
    
    result.comment_Count=[NSNumber numberWithInt:    [ [[dict objectForKey:@"comments"] objectForKey:@"count"] intValue]];
    
    result.source_ID= [[dict objectForKey:@"source_id"] stringValue];
    
    result.owner=myUser;
    
    
    
    result.cellheight=[NSNumber numberWithInt:height];
    // result.source_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue] ;
    // result.actor_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue] ;
    
    
    
    
    result.get_Time=getDate;
    
    
    result.photo_url=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    result.album_count=[NSNumber numberWithInt:[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"photo_count"] intValue]];
    result.album_title=[dict objectForKey:@"title"];
    result.share_comment=[dict objectForKey:@"message"];
    result.fromID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];

    result.fromName=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_name"];


    
    return result;
    
    // 将自己添加到对应user的statuses里
    // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
    // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
    
    
}


+ (NewFeedShareAlbum *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedShareAlbum" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedShareAlbum *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

-(NSString*)getShareComment
{
    if (![self.share_comment compare:@""])
    {
        return @"分享相册";
    }
    else
    {
        return self.share_comment;
    }
    //return self.prefix;
    
}
-(int)getAlbumQuan
{
    return [self.album_count intValue];
}


@end
