//
//  LNLabelBarViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNLabelBarViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSMutableArray *_labelPages;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
