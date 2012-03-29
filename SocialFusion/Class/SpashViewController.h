//
//  SpashViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-27.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SplashViewDelegate;

@interface SpashViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIImageView *pageImage;
@property (nonatomic, assign) id<SplashViewDelegate> delegate;
@end

@protocol SplashViewDelegate <NSObject>

- (void) SplashViewDidRemoved;
@end