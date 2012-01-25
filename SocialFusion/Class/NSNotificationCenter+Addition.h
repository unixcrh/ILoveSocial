//
//  NSNotificationCenter+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-24.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDidSelectFriendNotification @"kDidSelectFriendNotification"

@interface NSNotificationCenter (Addition)

+ (void)postDidSelectFriendNotificationWithUserDict:(NSDictionary *)userDict;

@end
