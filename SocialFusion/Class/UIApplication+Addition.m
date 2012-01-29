//
//  UIApplication+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-30.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "UIApplication+Addition.h"

static UIViewController *_modalViewController;
static UIView *_backView;

@implementation UIApplication (Addition)

- (void)presentModalViewController:(UIViewController *)vc
{
    if (_modalViewController)
        return;
    
	_modalViewController = [vc retain];
	
	_backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	_backView.alpha = 0.0f;
	_backView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = vc.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 480;
    vc.view.frame = frame;
    
	[[UIApplication sharedApplication].keyWindow addSubview:_backView];
	[[UIApplication sharedApplication].keyWindow addSubview:vc.view];
	
	[UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect frame = vc.view.frame;
        frame.origin.y = 20;
        vc.view.frame = frame;
	}];
}

- (void)dismissModalViewController
{
	[UIView animateWithDuration:kAnimationDuration animations:^{
		_backView.alpha = 0.0;
        CGRect frame = _modalViewController.view.frame;
        frame.origin.y = 480;
        _modalViewController.view.frame = frame;
	} completion:^(BOOL fin){
		if (fin) {
			[_backView removeFromSuperview];
            [_backView release];
            _backView = nil;
			[_modalViewController release];
            _modalViewController = nil;
		}
	}];
}

@end
