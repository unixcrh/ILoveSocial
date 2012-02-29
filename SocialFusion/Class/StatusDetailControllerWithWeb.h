//
//  StatusDetailControllerWithWeb.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-11.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "StatusDetailController.h"
@protocol WeiboRenrenSelecter;
@interface StatusDetailControllerWithWeb : StatusDetailController<UIWebViewDelegate>
{
     IBOutlet UIWebView* _webView;
        id<WeiboRenrenSelecter> _delegate;
}
@property (nonatomic, assign) id<WeiboRenrenSelecter> delegate;
- (void)loadWebView;


@end
@protocol WeiboRenrenSelecter<NSObject>

- (void)selectWeibo:(NSString*)weibo;
-(void)selectRenren:(NSString*)renren;

@end