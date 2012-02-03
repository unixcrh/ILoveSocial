//
//  StatusDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewFeedData.h"
#import "StatusCommentCell.h"
#import "NewFeedStatusCell.h"

#import "EGOTableViewController.h"
#import "NewFeedRootData.h"
@interface StatusDetailController : EGOTableViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    IBOutlet StatusCommentCell *_commentCel;
    int _pageNumber;
    BOOL _showMoreButton;
    IBOutlet UIImageView* _headImage;
    IBOutlet UIImageView* _style;
    IBOutlet UILabel* _time;
    IBOutlet UILabel* _nameLabel;
    IBOutlet UIWebView* _webView;
    IBOutlet UIPageControl* _pageControl;
    
    UIActivityIndicatorView* _activity;
    
    NSData* _photoData; 
}
@property (nonatomic, retain) NewFeedRootData* feedData;

-(void)loadData;
-(void)setFixedInfo;
-(void)loadWebView;
-(void)ProcessRenrenData:(NSArray*)array;
-(void)ProcessWeiboData:(NSArray*)array;
@end
