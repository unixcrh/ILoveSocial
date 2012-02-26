//
//  NSString+HTMLSet.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLSet)
- (NSString*)replaceJSSign;
- (NSString*)replaceHTMLSign;
- (NSString*)decodeHTMLSign;
- (NSString*)setName:(NSString*)name;
- (NSString*)setTime:(NSString*)time ;
- (NSString*)setWeibo:(NSString*)weibo  ;
- (NSString*)setRepost:(NSString*)repost;
- (NSString*)setAlbum:(NSString*)album ;
- (NSString*)setPhotoMount:(NSString*)photomount; 
- (NSString*)setAuthor:(NSString*)author;
- (NSString*)setComment :(NSString*)comment; 
- (NSString*)setCount :(NSString*)count; 
- (NSString*)setBlogTitle :(NSString*)title ;
- (NSString*)setBlogDetail :(NSString*)blog;
@end
