//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
@class NewFeedSelfListController;
@interface NewFeedStatusCell : UITableViewCell<UIWebViewDelegate> {

   
    
    NewFeedSelfListController* _listController;
    

    
     UIWebView* _webView;
    
    int _style;

}







+(float)heightForCell:(NewFeedRootData*)feedData;


-(void)setList:(NewFeedSelfListController*)list;
-(void)configureCell:(NewFeedRootData*)feedData;
-(void)exposeCell;
-(void)loadImage:(NSData*)image;
-(void)loadPicture:(NSData*)image;
@end
