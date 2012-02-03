//
//  UIApplication+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-30.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "UIApplication+Addition.h"
#import <QuartzCore/QuartzCore.h>

static UIViewController *_modalViewController;
static UIView *_backView;
static BOOL _isShowingToast;

#define TOAST_VIEW_WIDTH    200
#define TOAST_VIEW_HEIGHT   30

#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT   480

@implementation UIApplication (Addition)

- (void)presentModalViewController:(UIViewController *)vc
{
    if (_modalViewController)
        return;
    
	_modalViewController = [vc retain];
	
	_backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	_backView.alpha = 0.0f;
	_backView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = vc.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 480;
    vc.view.frame = frame;
    
	[self.keyWindow addSubview:_backView];
	[self.keyWindow addSubview:vc.view];
	
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = vc.view.frame;
        frame.origin.y = 20;
        vc.view.frame = frame;
    } completion:^(BOOL finished) {}];
}

- (void)dismissModalViewController
{
	[UIView animateWithDuration:kAnimationDuration animations:^{
		_backView.alpha = 0.0;
        CGRect frame = _modalViewController.view.frame;
        frame.origin.y = SCREEN_HEIGHT;
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

- (void)presentToast:(NSString *)text withVerticalPos:(CGFloat)y {
    if(_isShowingToast)
        return;
    _isShowingToast = YES;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TOAST_VIEW_WIDTH) / 2, y, TOAST_VIEW_WIDTH, TOAST_VIEW_HEIGHT)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.6f green:0.8f blue:0 alpha:1.0f];
    CALayer *layer = backgroundView.layer;
    //layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    layer.shadowOffset = CGSizeMake(0, 3.0f);
    layer.shadowColor = [UIColor darkGrayColor].CGColor;
    layer.shadowOpacity = 0.7f;
    layer.shadowRadius = 5.0f;
    

    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TOAST_VIEW_WIDTH, TOAST_VIEW_HEIGHT)];
    labelView.text = text;
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor whiteColor];
    labelView.shadowColor = [UIColor darkTextColor];
    labelView.shadowOffset = CGSizeMake(0, 1.0f);
    labelView.textAlignment = UITextAlignmentCenter;
    labelView.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [backgroundView addSubview:labelView];
    [labelView release];
    [self.keyWindow addSubview:backgroundView];
    [backgroundView release];
    
    [UIView animateWithDuration:0.3f delay:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        labelView.alpha = 0;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        _isShowingToast = NO;
    }];
}

@end
