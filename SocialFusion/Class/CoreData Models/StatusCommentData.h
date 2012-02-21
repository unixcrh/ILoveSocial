//
//  StatusCommentData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-31.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StatusCommentData : NSManagedObject

@property (nonatomic, retain) NSNumber * style;
@property (nonatomic, retain) NSString * actor_ID;
@property (nonatomic, retain) NSString * comment_ID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * owner_Name;
@property (nonatomic, retain) NSDate * update_Time;
@property (nonatomic, retain) NSString * owner_Head;
@property (nonatomic, retain) NSNumber * secret;

@end
