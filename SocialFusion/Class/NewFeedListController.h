//
//  NewFeedListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef   enum kUserFeed {
    kRenrenUserFeed = 0,
    kWeiboUserFeed = 1,
    kSelfUserFeed=2
} kUserFeed;
#import "EGOTableViewController.h"


//#import "DragRefreshTableViewController.h"
#import "NewFeedRootData.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "NewFeedStatusCell.h"


#import "NewFeedDetailViewCell.h"
#import "NewFeedCellHeight.h"
@interface NewFeedListController : EGOTableViewController {
    
    
    
    // NewFeedRootData *feedDatas;
    //  NSMutableArray* _feedArray;
    //  NSMutableArray* _tempArray;
    NSDate* _currentTime;
    
    IBOutlet NewFeedStatusCell *_feedStatusCel;


    IBOutlet NewFeedDetailViewCell *_newFeedDetailViewCel;
    
    NSIndexPath* _indexPath;
    //int _openedCell;
    int _pageNumber;
    
    
    
    NewFeedCellHeight* _cellHeightHelper;
    
   // UIWebView* _webView;
    

    
    
}


+(NewFeedListController*)getNewFeedListControllerwithStyle:(kUserFeed)style;
-(void)exposeCell:(NSIndexPath*)indexPath;
-(void)showImage:(NSIndexPath*)indexPath;
-(void)showImage:(NSString*)smallURL bigURL:(NSString*)stringURL;
-(void)showImage:(NSString*)smallURL userID:(NSString*)userID photoID:(NSString*)photoID;
-(void)processRenrenData:(NSArray*)array;
-(void)processWeiboData:(NSArray*)array;
- (void)clearData;
-(IBAction)resetToNormalList;
@end
