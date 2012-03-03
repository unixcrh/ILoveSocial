//
//  CardBrowserWebBackgroundView.m
//  SocialFusion
//
//  Created by 紫川 王 on 12-3-3.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "CardBrowserWebBackgroundView.h"

@interface CardBrowserWebBackgroundView ()

@end

@implementation CardBrowserWebBackgroundView

- (void)didAddSubview:(UIView *)subview {
    NSLog(@"tag%d", subview.tag);
}

@end
