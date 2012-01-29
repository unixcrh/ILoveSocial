//
//  UIApplication+Addition.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-30.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimationDuration 0.5f

@interface UIApplication (Addition)

- (void)presentModalViewController:(UIViewController *)vc;
- (void)dismissModalViewController;

@end
