//
//  ImageData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface ImageData : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Image *owner;

@end
