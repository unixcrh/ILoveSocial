//
//  UIApplication+Addition.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-30.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIApplication+Addition.h"
#import <QuartzCore/QuartzCore.h>

static UIViewController *_modalViewController;
static UIViewController *_secondModalViewController;
static UIView *_backView;
static BOOL _isShowingToast;

#define TOAST_VIEW_WIDTH    205
#define TOAST_VIEW_HEIGHT   32

#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT   480

@implementation UIApplication (Addition)

- (void)presentSecondModalViewController:(UIViewController *)vc {
    if (!_modalViewController || _secondModalViewController)
        return;
    
	_secondModalViewController = [vc retain];
	
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

- (void)dismissSecondModalViewController {
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _backView.alpha = 0.0;
        CGRect frame = _modalViewController.view.frame;
        frame.origin.y = SCREEN_HEIGHT;
        _modalViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
			[_backView removeFromSuperview];
            [_backView release];
            _backView = nil;
			[_modalViewController release];
            _modalViewController = nil;
		}
    }];
}

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
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _backView.alpha = 0.0;
        CGRect frame = _modalViewController.view.frame;
        frame.origin.y = SCREEN_HEIGHT;
        _modalViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
			[_backView removeFromSuperview];
            [_backView release];
            _backView = nil;
			[_modalViewController release];
            _modalViewController = nil;
		}
    }];
}

- (void)presentToast:(NSString *)text withVerticalPos:(CGFloat)y andTime:(float)time isError:(BOOL)isError
{
    if(_isShowingToast)
        return;
    _isShowingToast = YES;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TOAST_VIEW_WIDTH) / 2, y, TOAST_VIEW_WIDTH, TOAST_VIEW_HEIGHT)];
    if(isError)
        bgImageView.image = [UIImage imageNamed:@"toast_bg_red@2x.png"];
    else
        bgImageView.image = [UIImage imageNamed:@"toast_bg_green.png"];
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, TOAST_VIEW_WIDTH, TOAST_VIEW_HEIGHT)];
    labelView.minimumFontSize = 10.0f;
    labelView.text = text;
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor whiteColor];
    labelView.shadowColor = [UIColor darkGrayColor];
    labelView.shadowOffset = CGSizeMake(0, 1.0f);
    labelView.textAlignment = UITextAlignmentCenter;
    labelView.font = [UIFont boldSystemFontOfSize:14.0f];
    
    [bgImageView addSubview:labelView];
    [labelView release];
    [self.keyWindow addSubview:bgImageView];
    [bgImageView release];
    
    labelView.alpha = 0;
    bgImageView.alpha = 0;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        labelView.alpha = 1;
        bgImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:time options:UIViewAnimationOptionCurveEaseInOut animations:^{
            labelView.alpha = 0;
            bgImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [bgImageView removeFromSuperview];
            _isShowingToast = NO;
        }];
    }];
}

- (void)presentErrorToast:(NSString *)text withVerticalPos:(CGFloat)y {
    [self presentToast:text withVerticalPos:y andTime:1.2f isError:YES];
}

- (void)presentToast:(NSString *)text withVerticalPos:(CGFloat)y {
    [self presentToast:text withVerticalPos:y andTime:1.2f isError:NO];
}

- (void)presentToastwithShortInterval:(NSString *)text withVerticalPos:(CGFloat)y {
       [self presentToast:text withVerticalPos:y andTime:0.5f isError:NO];
}


@end
