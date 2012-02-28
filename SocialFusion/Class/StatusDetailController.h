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

@interface StatusDetailController : EGOTableViewController<UIScrollViewDelegate>
{
    IBOutlet StatusCommentCell *_commentCel;
    IBOutlet UIImageView* _headImage;
    IBOutlet UILabel* _time;
    IBOutlet UILabel* _nameLabel;
    IBOutlet UIView* _titleView;
    
    int _pageNumber;
    BOOL _showMoreButton;
    UIButton* _commentButton;
    UIActivityIndicatorView* _activity;
    NSData* _photoData; 
}

@property (nonatomic, retain) NewFeedRootData* feedData;

- (void)setFixedInfo;
- (void)loadMainView;
- (void)loadData;
- (void)ProcessRenrenData:(NSArray*)array;
- (void)ProcessWeiboData:(NSArray*)array;
- (void)clearData;

- (IBAction)repost;
- (IBAction)comment:(id)sender;

@end
