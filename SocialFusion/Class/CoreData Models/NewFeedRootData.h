//
//  NewFeedRootData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewFeedRootData : NSManagedObject

@property (nonatomic, retain) NSNumber * cell_Height;
@property (nonatomic, retain) NSNumber * comment_Count;
@property (nonatomic, retain) NSString * feed_ID;
@property (nonatomic, retain) NSDate * get_Time;
@property (nonatomic, retain) NSString * maininfo;
@property (nonatomic, retain) NSString * maininfo_ID;
@property (nonatomic, retain) NSString * owner_Head_URL;
@property (nonatomic, retain) NSString * owner_Name;
@property (nonatomic, retain) NSNumber * style;
@property (nonatomic, retain) NSDate * update_Time;
@property (nonatomic, retain) NSManagedObject *author;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSManagedObject *owner;
@end

@interface NewFeedRootData (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
