//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedRootData+Addition.h"
@class NewFeedListController;
@interface NewFeedStatusCell : UITableViewCell<UIWebViewDelegate> {

    NewFeedListController* _listController;
    
    UIWebView* _webView;
    
    UIImageView* _photoView;
    UIImageView* _defaultphotoView;
    UIButton* _photoOut;
    
    UIButton* _name;
    UILabel* _time;
    UIImageView* _upCutline;
    

    NSData* _photoData;
}


@property(nonatomic, retain)  UIImageView* photoView;




+(float)heightForCell:(NewFeedRootData*)feedData;


- (void)setList:(NewFeedListController*)list;
- (void)configureCell:(NewFeedRootData*)feedData;
- (void)exposeCell;
- (void)loadImage:(NSData*)image;
- (void)loadPicture:(NSData*)image;
- (void)setData:(NSData*)image;
@end
