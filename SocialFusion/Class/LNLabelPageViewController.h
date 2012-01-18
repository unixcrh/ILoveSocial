//
//  LNLabelPageViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLabelViewController.h"

@protocol LNLabelPageViewControllerDelegate;
@interface LNLabelPageViewController : UIViewController<LNLabelViewControllerDelegate> {
    NSMutableArray *_labelViews;
    NSUInteger _page;
    id<LNLabelPageViewControllerDelegate> _delegate;
}

@property NSUInteger page;
@property (nonatomic, assign) id<LNLabelPageViewControllerDelegate> delegate;

- (void)selectOtherPage:(NSUInteger)page;

@end

@protocol LNLabelPageViewControllerDelegate <NSObject>

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectPageAtIndex:(NSUInteger)page;

@end