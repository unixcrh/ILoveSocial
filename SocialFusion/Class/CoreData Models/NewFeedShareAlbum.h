//
//  NewFeedShareAlbum.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewFeedShareAlbum : NSManagedObject

@property (nonatomic, retain) NSString * from_ID;
@property (nonatomic, retain) NSString * from_Name;
@property (nonatomic, retain) NSString * from_UserID;

@end
