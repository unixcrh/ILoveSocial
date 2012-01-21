//
//  NewFeedUserListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-21.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFeedListController.h"
@interface NewFeedUserListController : NewFeedListController
{
    int _style;
}
-(void)setStyle:(int)style;
@end
