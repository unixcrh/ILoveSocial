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
    self=[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\'"];
    self=[self stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    self=[self stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    self=[self stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return  self;
}

- (NSString*)replaceHTMLSign 
{
    self=[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp"];

     self=[self stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    self=[self stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];


    self=[self stringByReplacingOccurrencesOfString:@"¢" withString:@"&cent"];

    self=[self stringByReplacingOccurrencesOfString:@"£" withString:@"&pound"];

    self=[self stringByReplacingOccurrencesOfString:@"¥" withString:@"&yen"];

    self=[self stringByReplacingOccurrencesOfString:@"€" withString:@"&euro"];

    self=[self stringByReplacingOccurrencesOfString:@"§" withString:@"&sect"];
       self=[self stringByReplacingOccurrencesOfString:@"©" withString:@"&copy"];
       self=[self stringByReplacingOccurrencesOfString:@"®" withString:@"&reg"];
           self=[self stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot"];
    return self;
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
@end
