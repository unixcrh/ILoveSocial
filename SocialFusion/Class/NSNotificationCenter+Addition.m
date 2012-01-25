//
//  NSNotificationCenter+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-24.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "NSNotificationCenter+Addition.h"

@implementation NSNotificationCenter (Addition)

+ (void)postDidSelectFriendNotificationWithUserDict:(NSDictionary *)userDict {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectFriendNotification object:userDict userInfo:nil];
}

@end
