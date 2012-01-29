//
//  NewFeedBlog+NewFeedBlog_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedBlog+NewFeedBlog_Addition.h"

@implementation NewFeedBlog (NewFeedBlog_Addition)
+ (NewFeedBlog *)insertNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Owner:(User*)myUser Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
        NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedBlog *result = [NewFeedBlog feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedBlog" inManagedObjectContext:context];
        }
        
        
        result.post_ID = statusID;
        
        
        result.style=[NSNumber numberWithInt:sytle];
        
    if ([[dict objectForKey:@"feed_type"] intValue]==21)
    {
        result.source_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];
        result.actor_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];
    }
    
    else
    {
        result.actor_ID=[[dict objectForKey:@"actor_id"] stringValue];
        result.source_ID= [[dict objectForKey:@"source_id"] stringValue]; 
    }

        
        
        result.owner_Head= [dict objectForKey:@"headurl"] ;
        
        result.owner_Name=[dict objectForKey:@"name"] ;
        
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        NSString* dateString=[dict objectForKey:@"update_time"];
        result.update_Time=[form dateFromString: dateString];
        
        
        [form release];
        
        
        result.comment_Count=[NSNumber numberWithInt:    [ [[dict objectForKey:@"comments"] objectForKey:@"count"] intValue]];
        
       // result.source_ID= [[dict objectForKey:@"source_id"] stringValue];
        
        result.prefix=[dict objectForKey:@"prefix"] ;
        result.title=[dict objectForKey:@"title"] ;
        result.mydescription=[dict objectForKey:@"description"] ;
        
        
    result.cellheight=[NSNumber numberWithInt:height];
       // result.source_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue] ;
       // result.actor_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue] ;


        result.get_Time=getDate;
    return result;
        
        // 将自己添加到对应user的statuses里
        // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
        // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
       
    
}


+ (NewFeedBlog *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedBlog" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedBlog *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

-(NSString*)getBlog
{
    return self.mydescription;
}

-(NSString*)getName
{
    
    
    //if (description==nil)
    //description=@"";
    
   
    
    
    
    
    return [NSString stringWithFormat:@"%@%@",self.prefix,self.title]  ;
    
}



@end
