//
//  LNRootViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "LNLabelBarViewController.h"
#import "LNContentViewController.h"

@interface LNRootViewController : CoreDataViewController<LNLabelBarViewControllerDelegate, LNContentViewControllerDelegate> {
    LNLabelBarViewController *_labelBarViewController;
    LNContentViewController *_contentViewController;
    NSMutableDictionary *_openedUserHeap;
}

@property (nonatomic, retain) LNLabelBarViewController *labelBarViewController;
@property (nonatomic, retain) LNContentViewController *contentViewController;

@end
