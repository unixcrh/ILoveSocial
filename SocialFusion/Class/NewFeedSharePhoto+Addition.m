//
//  NewFeedSharePhoto+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NewFeedSharePhoto+Addition.h"

@implementation NewFeedSharePhoto (Addition)

+ (NewFeedSharePhoto *)insertNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedSharePhoto *result = [NewFeedSharePhoto feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedSharePhoto" inManagedObjectContext:context];
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
    
    
    
    
    // result.source_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue] ;
    // result.actor_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue] ;
    
    
    
    
    result.get_Time=getDate;
    
    
    result.photo_url=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    result.share_comment=[dict objectForKey:@"message"];
    result.photo_comment=[dict objectForKey:@"description"];
   
    result.mediaID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];

    
    result.fromID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];
    
    result.fromName=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_name"];

    result.title=[dict objectForKey:@"title"];
 //   result.prefix=[dict objectForKey:@"prefix"];

    result.cellheight=[NSNumber numberWithInt:height];
    return result;
    

    
}


+ (NewFeedSharePhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedSharePhoto" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedSharePhoto *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

-(NSString*)getShareComment
{
    if (![self.share_comment compare:@""])
    {
        return @"分享照片";
    }
    else
    {
        return self.share_comment;
    }
    //return self.prefix;
    
}

-(NSString*)getPhotoComment
{
    if (![self.photo_comment compare:@""])
    {
        return @"那个人很懒，没有写介绍噢";
    }
    else
    {
        if ([self.photo_comment length]>54)
        {
            NSString* returnString=[NSString stringWithFormat:@"%@...",[self.photo_comment substringToIndex:50]];
            return returnString;
        }
        else
        {
        return self.photo_comment;
        }
    }
    //return self.prefix;
    
}


@end
