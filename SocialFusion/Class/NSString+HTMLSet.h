//
//  NSString+HTMLSet.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLSet)
-(NSString*)setName:(NSString*)name;
-(NSString*)setTime:(NSString*)time ;
-(NSString*)setWeibo:(NSString*)weibo  ;
-(NSString*)setRepost:(NSString*)repost;
-(NSString*)setAlbum:(NSString*)album ;
-(NSString*)setPhotoMount:(NSString*)photomount; 
-(NSString*)setAuthor:(NSString*)author;
-(NSString*)setComment :(NSString*)comment; 
-(NSString*)setCount :(NSString*)count; 

@end
