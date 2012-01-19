//
//  NSString+HTMLSet.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+HTMLSet.h"

@implementation NSString (HTMLSet)

-(NSString*)setName:(NSString*)name  
{
    NSArray* array=[self componentsSeparatedByString:@"@#Name#@"];
    [self release];
   // NSLog(@"%@",name);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],name,[array objectAtIndex:1]];
 
    return returnString;
}


-(NSString*)setTime:(NSString*)time 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Time#@"];
    [self release];
    
   // NSLog(@"%@",time);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],time,[array objectAtIndex:1]];
    return returnString;
}



-(NSString*)setWeibo:(NSString*)weibo  
{
    NSArray* array=[self componentsSeparatedByString:@"@#Weibo#@"];
    [self release];
    
    //NSLog(@"%@",weibo);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],weibo,[array objectAtIndex:1]];
    return returnString;
}



-(NSString*)setRepost:(NSString*)repost
{
    
   // NSLog(@"%@",self);
    NSArray* array=[self componentsSeparatedByString:@"@#Repost#@"];
    [self release];
    
    //NSLog(@"%@",repost);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],repost,[array objectAtIndex:1]];
    return returnString;
}

-(NSString*)setAlbum:(NSString*)album 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Album#@"];
    [self release];
    
   // NSLog(@"%@",album);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],album,[array objectAtIndex:1]];
    return returnString;
}


-(NSString*)setPhotoMount:(NSString*)photomount 
{
    NSArray* array=[self componentsSeparatedByString:@"@#PhotoMount#@"];
    [self release];
    
    
   // NSLog(@"%@",photomount);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],photomount,[array objectAtIndex:1]];
    return returnString;
}


-(NSString*)setAuthor:(NSString*)author
{
    NSArray* array=[self componentsSeparatedByString:@"@#Author#@"];
    [self release];
    
    
   // NSLog(@"%@",author);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],author,[array objectAtIndex:1]];
    return returnString;
}

-(NSString*)setComment :(NSString*)comment 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Comment#@"];
    [self release];
    
    
  //  NSLog(@"%@",comment);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],comment,[array objectAtIndex:1]];
    return returnString;
}

@end
