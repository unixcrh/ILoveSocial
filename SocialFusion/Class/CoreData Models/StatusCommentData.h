//
//  StatusCommentData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StatusCommentData : NSManagedObject

@property (nonatomic, retain) NSNumber * secret;
@property (nonatomic, retain) NSNumber * style;
@property (nonatomic, retain) NSString * actor_ID;
@property (nonatomic, retain) NSString * comment_ID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * owner_Name;
@property (nonatomic, retain) NSDate * update_Time;
@property (nonatomic, retain) NSString * owner_Head;
@property (nonatomic, retain) NSManagedObject *owner;

@end
