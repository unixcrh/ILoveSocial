//
//  NewFeedUploadPhoto+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-10.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedUploadPhoto+Addition.h"

@implementation NewFeedUploadPhoto (Addition)

+ (NewFeedUploadPhoto *)insertNewFeed:(int)sytle getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedUploadPhoto *result = [NewFeedUploadPhoto feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedUploadPhoto" inManagedObjectContext:context];
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
    
    result.photo_big_url=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"raw_src"];

    result.photo_url=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    result.photo_comment=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"content"];

    result.prefix=[dict objectForKey:@"prefix"];
    result.title=[dict objectForKey:@"title"];
    return result;
    
    // 将自己添加到对应user的statuses里
    // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
    // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
    
    
}


+ (NewFeedUploadPhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedUploadPhoto" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedUploadPhoto *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

-(NSString*)getName
{
    return self.prefix;
     
}


-(NSString*)getPhoto_Comment
{
    if (![self.photo_comment compare:@""])
    {
        return @"那个人很懒，没有写介绍噢";
    }
    else
    {
     
        /*if ([self.photo_comment length]>54)
        {
            NSString* returnString=[NSString stringWithFormat:@"%@...",[self.photo_comment substringToIndex:50]];
            return returnString;
        }*/
       // else
       // {
            return self.photo_comment;
       // }
    }
}
-(NSString*)getTitle
{
    return [NSString stringWithFormat:@"来自:《%@》",self.title];;
}
@end
