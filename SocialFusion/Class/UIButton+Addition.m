//
//  UIButton+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIButton+Addition.h"
#import "UIImageView+Addition.h"

@implementation UIButton (Addition)

- (void)setPostPlatformButtonSelected:(BOOL)select {
    if(self.isSelected == select)
        return;
    [self setUserInteractionEnabled:NO];
    if(select) {
        [self setSelected:select];
        [self.imageView fadeInWithCompletion:^(BOOL finished) {
            [self setUserInteractionEnabled:YES];
        }];
    }
    else {
        [self.imageView fadeOutWithCompletion:^(BOOL finished) {
            [self setSelected:select];
            [self setUserInteractionEnabled:YES];
        }];
    }
}

@end
