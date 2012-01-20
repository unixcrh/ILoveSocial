//
//  LNLabelBarViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLabelPageViewController.h"

@interface LNLabelBarViewController : UIViewController<UIScrollViewDelegate ,LNLabelPageViewControllerDelegate> {
    UIScrollView *_scrollView;
    NSMutableArray *_labelPages;
    NSUInteger _pageCount;
    NSMutableArray *_labelInfoArray;
    UIPageControl *_pageControl;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *labelInfoArray;
@property (nonatomic) NSUInteger pageCount;

- (void)createLabelWithInfo:(LabelInfo *)info;

@end
