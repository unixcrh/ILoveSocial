//
//  LabelConverter.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataViewController.h"

#define kParentNewFeed      @"kParentNewFeed"
#define kChildAllNewFeed    @"kChildAllNewFeed"
#define kChildRenrenNewFeed @"kChildRenrenNewFeed"
#define kChildWeiboNewFeed  @"kChildWeiboNewFeed"

#define KParentUserInfo     @"KParentUserInfo"
#define kChildRenrenAlbum   @"kChildAlbum"
#define kChildRenrenBlog    @"kChildBlog"
#define kChildRenrenInfo    @"kChildRenrenInfo"
#define kChildWeiboInfo     @"kChildWeiboInfo"

#define kParentFriend       @"kParentFriend"
#define kChildRenrenFriend  @"kChildRenrenFriend"
#define kChildWeiboFriend   @"kChildWeiboFriend"
#define kChildWeiboFollower @"kChildWeiboFollower"

#define kParentInbox        @"kParentInbox"
#define kChildNewMessage    @"kChildNewMessage"
#define kChildNewFriend     @"kChildNewFriend"

#define kSystemDefaultLabels    @"kSystemDefaultLabels"
#define kLabelName              @"kLabelName"
#define kLabelIsRetractable     @"kLabelIsRetractable"
#define kChildLabels            @"kChildLabels"



@interface LabelConverter : NSObject {
    NSDictionary *_configMap;
}

@property (nonatomic, readonly) NSDictionary *configMap;

+ (LabelConverter *)getInstance;
+ (NSArray *)getSystemDefaultLabelsInfo;
+ (NSArray *)getChildLabelsInfoWithParentLabelIndentifier:(NSString *)identifier;
//+ (UIViewController)getViewControllerWithIndentifer:(NSString *)indentifer andUsers:(NSArray *)userArray;

@end
