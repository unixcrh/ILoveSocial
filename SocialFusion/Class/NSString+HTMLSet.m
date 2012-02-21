//
//  NSString+HTMLSet.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+HTMLSet.h"

@implementation NSString (HTMLSet)
- (NSString*)replaceJSSign 
{
    NSString* returnString;
    returnString=[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\'"];
    returnString=[returnString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    returnString=[returnString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    returnString=[returnString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return  returnString;
}

- (NSString*)replaceHTMLSign 
{
    NSString* returnString;
    returnString=[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp"];

     returnString=[returnString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    returnString=[returnString stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];


    returnString=[returnString stringByReplacingOccurrencesOfString:@"¢" withString:@"&cent"];

    returnString=[returnString stringByReplacingOccurrencesOfString:@"£" withString:@"&pound"];

    returnString=[returnString stringByReplacingOccurrencesOfString:@"¥" withString:@"&yen"];

    returnString=[returnString stringByReplacingOccurrencesOfString:@"€" withString:@"&euro"];

    returnString=[returnString stringByReplacingOccurrencesOfString:@"§" withString:@"&sect"];
       returnString=[returnString stringByReplacingOccurrencesOfString:@"©" withString:@"&copy"];
       returnString=[returnString stringByReplacingOccurrencesOfString:@"®" withString:@"&reg"];
           returnString=[returnString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot"];
    return returnString;
}
- (NSString*)setName:(NSString*)name  
{
 //   NSArray* array=[self componentsSeparatedByString:@"@#Name#@"];
 //   [self release];
   // NSLog(@"%@",name);
  //  NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],name,[array objectAtIndex:1]];
  
    return self;
}


- (NSString*)setTime:(NSString*)time 
{
  /*  NSArray* array=[self componentsSeparatedByString:@"@#Time#@"];
    [self release];
    
   // NSLog(@"%@",time);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],time,[array objectAtIndex:1]];
    return returnString;*/
    return self;
}



- (NSString*)setWeibo:(NSString*)weibo  
{
    NSArray* array=[self componentsSeparatedByString:@"@#Weibo#@"];
    [self release];
    
    //NSLog(@"%@",weibo);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],weibo,[array objectAtIndex:1]];
    return returnString;
}



- (NSString*)setRepost:(NSString*)repost
{
    
   // NSLog(@"%@",self);
    NSArray* array=[self componentsSeparatedByString:@"@#Repost#@"];
    [self release];
    
    //NSLog(@"%@",repost);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],repost,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setAlbum:(NSString*)album 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Album#@"];
    [self release];
    
   // NSLog(@"%@",album);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],album,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setPhotoMount:(NSString*)photomount 
{
    NSArray* array=[self componentsSeparatedByString:@"@#PhotoMount#@"];
    [self release];
    
    
   // NSLog(@"%@",photomount);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],photomount,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setAuthor:(NSString*)author
{
    NSArray* array=[self componentsSeparatedByString:@"@#Author#@"];
    [self release];

   // NSLog(@"%@",author);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],author,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setComment :(NSString*)comment 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Comment#@"];
    [self release];
    
    
  //  NSLog(@"%@",comment);
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],comment,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setCount :(NSString*)count
{
    NSArray* array=[self componentsSeparatedByString:@"@#Count#@"];
    [self release];
    
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],count,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setBlogTitle :(NSString*)title 
{
    NSArray* array=[self componentsSeparatedByString:@"@#Title#@"];
    [self release];
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],title,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setBlogDetail :(NSString*)blog 
{
    NSArray* array=[self componentsSeparatedByString:@"@#blog#@"];
    [self release];
    NSString* returnString=[[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],blog,[array objectAtIndex:1]];
    return returnString;
}



@end
