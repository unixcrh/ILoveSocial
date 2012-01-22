//
//  LNLabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelViewController.h"

#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

@implementation LabelInfo

@synthesize identifier = _identifier;
@synthesize labelName = _labelName;
@synthesize isRetractable = _isRetractable;
@synthesize isRemovable = _isRemovable;
@synthesize isSelected = _isSelected;
@synthesize isReturnLabel = _isReturnLabel;

- (void)dealloc {
    [_labelName release];
    [super dealloc];
}

+ (LabelInfo *)labelInfoWithIdentifier:(NSString *)identifier labelName:(NSString *)name isRetractable:(BOOL)retractable {
    LabelInfo *info = [[[LabelInfo alloc] init] autorelease];
    info.identifier = identifier;
    info.labelName = name;
    info.isRetractable = retractable;
    return info;
}

@end

@implementation LNLabelViewController

@synthesize titleButton = _titleButton;
@synthesize index = _index;
@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize info = _info;

- (void)dealloc {
    NSLog(@"LNLabelViewController dealloc");
    [_titleButton release];
    [_titleLabel release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.titleButton = nil;
    self.titleLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
																							action:@selector(swipeUp:)];
	swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
	swipeUpGesture.numberOfTouchesRequired = 1;
	[self.view addGestureRecognizer:swipeUpGesture];
	[swipeUpGesture release];
	
}

- (void)setIsSelected:(BOOL)isSelected {
    self.info.isSelected = isSelected;
    if(self.isSelected) {
        [self.titleLabel setHighlighted:YES];
    }
    else {
        [self.titleLabel setHighlighted:NO];
    }
}

- (BOOL)isSelected {
    return self.info.isSelected;
}

- (BOOL)isRetractable {
    return self.info.isRetractable;
}

- (BOOL)isRemovable {
    return self.info.isRemovable;
}

- (BOOL)isReturnLabel {
    return self.info.isReturnLabel;
}

- (BOOL)isParentLabel {
    return self.isRetractable && !self.isReturnLabel;
}

- (BOOL)isChildLabel {
    return !self.isRetractable;
}

- (IBAction)clickTitleButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectLabelAtIndex:)]) {
        [self.delegate labelView:self didSelectLabelAtIndex:self.index];
    }
    if(sender == nil) {
        // called by label bar or label page
        self.isSelected = YES;
        return;
    }
    if(self.isReturnLabel) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didCloseLabelAtIndex:)])
            [self.delegate labelView:self didCloseLabelAtIndex:self.index];
    }
    else if(self.isRetractable && self.isSelected){ 
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didOpenLabelAtIndex:)])
            [self.delegate labelView:self didOpenLabelAtIndex:self.index];
    }
    self.isSelected = YES;
}

- (void)swipeUp:(UISwipeGestureRecognizer *)ges {
    if(!self.isRemovable)
        return;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didRemoveLabelAtIndex:)])
        [self.delegate labelView:self didRemoveLabelAtIndex:self.index];
}

- (void)setInfo:(LabelInfo *)info {
    if(_info != info) {
        [_info release];
        _info = [info retain];
        self.titleLabel.text = _info.labelName;
        self.isSelected = _info.isSelected;
    }
}
@end
