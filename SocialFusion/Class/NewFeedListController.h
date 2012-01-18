//
//  NewFeedListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "EGOTableViewController.h"


//#import "DragRefreshTableViewController.h"
#import "NewFeedRootData.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "NewFeedStatusCell.h"
#import "NewFeedStatusWithRepostcell.h"
#import "NewFeedBlogCell.h"
#import "NewFeedDetailViewCell.h"
#import "NewFeedCellHeight.h"
@interface NewFeedListController : EGOTableViewController {
    
    
    
    // NewFeedRootData *feedDatas;
    //  NSMutableArray* _feedArray;
    //  NSMutableArray* _tempArray;
    NSDate* _currentTime;
    
    IBOutlet NewFeedStatusCell *_feedStatusCel;
    IBOutlet NewFeedStatusWithRepostcell *_feedRepostStatusCel;
    IBOutlet NewFeedBlogCell *_newFeedBlogCel;
    IBOutlet NewFeedDetailViewCell *_newFeedDetailViewCel;
    
    NSIndexPath* _indexPath;
    //int _openedCell;
    int _pageNumber;
    
    
    
    NewFeedCellHeight* _cellHeightHelper;
    
   // UIWebView* _webView;
    

    
    
}



-(void)exposeCell:(NSIndexPath*)indexPath;
-(void)showImage:(NSString*)smallURL bigURL:(NSString*)stringURL;
-(void)showImage:(NSString*)smallURL userID:(NSString*)userID photoID:(NSString*)photoID;
-(IBAction)resetToNormalList;
@end
