//
//  LNLabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelViewController.h"

#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

@implementation LNLabelViewController

@synthesize titleButton = _titleButton;
@synthesize index = _index;
@synthesize delegate = _delegate;
@synthesize labelStatus = _labelStatus;
@synthesize plusButton = _plusButton;
@synthesize isSelected = _isSelected;

- (void)dealloc {
    NSLog(@"LNLabelViewController dealloc");
    [_titleButton release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.titleButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.titleButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [self.titleButton setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
    if(!_isSelected)
        [self.plusButton setHidden:YES];
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
																							action:@selector(swipeUp:)];
	swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
	swipeUpGesture.numberOfTouchesRequired = 1;
	[self.view addGestureRecognizer:swipeUpGesture];
	[swipeUpGesture release];
	
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if(isSelected == YES)
        [self.plusButton setHidden:NO];
}

- (BOOL)isParentLabel {
    return self.labelStatus == PARENT_LABEL_OPEN || self.labelStatus == PARENT_LABEL_CLOSE;
}

- (IBAction)clickTitleButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectLabelAtIndex:)]) {
        [self.delegate labelView:self didSelectLabelAtIndex:self.index];
    }
    if(self.isParentLabel) {
        [self.plusButton setHidden:NO];
        self.isSelected = YES;
    }
}

- (IBAction)clickPlusButton:(id)sender {
    if(self.labelStatus == PARENT_LABEL_OPEN) {
        self.labelStatus = PARENT_LABEL_CLOSE;
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            self.plusButton.transform = xform;
        }completion:^(BOOL finished) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectCloseAtIndex:)])
                [self.delegate labelView:self didSelectCloseAtIndex:self.index];
        }];
    }
    else if(self.labelStatus == PARENT_LABEL_CLOSE) { 
        self.labelStatus = PARENT_LABEL_OPEN;
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180 + 45));
            self.plusButton.transform = xform;
        } completion:^(BOOL finished) {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectOpenAtIndex:)])
                [self.delegate labelView:self didSelectOpenAtIndex:self.index];
        }];
    }
}

- (id)initWithStatus:(LabelStatus)status {
    if([self init])
        self.labelStatus = status;
    return self;
}

- (void)swipeUp:(UISwipeGestureRecognizer *)ges {
    NSLog(@"swipe top");
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didRemoveLabelAtIndex:)])
        [self.delegate labelView:self didRemoveLabelAtIndex:self.index];
}

@end
