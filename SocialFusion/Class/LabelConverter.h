//
//  LabelConverter.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-22.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataViewController.h"

#define kParentNewFeed      @"kParentNewFeed"
#define kChildAllNewFeed    @"kChildAllNewFeed"
#define kChildRenrenNewFeed @"kChildRenrenNewFeed"
#define kChildWeiboNewFeed  @"kChildWeiboNewFeed"

#define KParentUserInfo         @"KParentUserInfo"
#define kChildSelfRenrenNewFeed @"kChildSelfRenrenNewFeed"
#define kChildSelfWeiboNewFeed  @"kChildSelfWeiboNewFeed"
#define kChildRenrenAlbum       @"kChildAlbum"
#define kChildRenrenBlog        @"kChildBlog"
#define kChildRenrenInfo        @"kChildRenrenInfo"
#define kChildWeiboInfo         @"kChildWeiboInfo"

#define kParentFriend       @"kParentFriend"
#define kChildRenrenFriend  @"kChildRenrenFriend"
#define kChildWeiboFriend   @"kChildWeiboFriend"
#define kChildWeiboFollower @"kChildWeiboFollower"

#define kParentInbox        @"kParentInbox"
#define kChildNewMessage    @"kChildNewMessage"
#define kChildNewFriend     @"kChildNewFriend"

#define kParentRenrenUser       @"kParentRenrenUser"
#define kChildRenrenUserNewFeed @"kChildRenrenUserNewFeed"
#define kChildRenrenUserBlog    @"kChildRenrenUserBlog"

#define kParentWeiboUser        @"kParentWeiboUser"

#define kSystemDefaultLabels    @"kSystemDefaultLabels"
#define kLabelName              @"kLabelName"
#define kLabelIsRetractable     @"kLabelIsRetractable"
#define kChildLabels            @"kChildLabels"

@class LabelInfo;

@interface LabelConverter : NSObject {
    NSDictionary *_configMap;
}

@property (nonatomic, readonly) NSDictionary *configMap;

+ (LabelConverter *)getInstance;
+ (LabelInfo *)getLabelInfoWithIdentifier:(NSString *)identifier;
+ (NSArray *)getSystemDefaultLabelsInfo;
+ (NSArray *)getSystemDefaultLabelsIdentifier;
+ (NSArray *)getChildLabelsInfoWithParentLabelIndentifier:(NSString *)identifier andParentLabelName:(NSString *)name;
+ (NSString *)getDefaultChildIdentifierWithParentIdentifier:(NSString *)parentIdentifier;

@end
