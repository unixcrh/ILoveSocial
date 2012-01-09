//
//  CalculateHeight.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-6.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"

@interface CalculateHeight : NSObject<UIWebViewDelegate>
{
    int _height;
    NewFeedRootData* _feedData;
    
    UIWebView* _webView;
}

-(int)getHeight;
-(id)initWithFeed:(NewFeedRootData*)feed;
@end
