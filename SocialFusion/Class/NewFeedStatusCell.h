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
@class NewFeedListController;
@interface NewFeedStatusCell : UITableViewCell<UIWebViewDelegate> {
    NewFeedRootData* _feedData;
   
    
    NewFeedListController* _listController;
    

    

    
    IBOutlet UIWebView* _webView;
    
    

}







+(float)heightForCell:(NewFeedData*)feedData;


-(void)setList:(NewFeedListController*)list;
-(void)configureCell:(NewFeedData*)feedData;
-(void)exposeCell;
-(void)loadImage:(NSData*)image;
-(void)loadPicture:(NSData*)image;
@end
