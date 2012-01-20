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

@synthesize labelName = _labelName;
@synthesize labelStatus = _labelStatus;
@synthesize isSystemLabel = _isSystemLabel;

+ (LabelInfo *)labelInfoWithName:(NSString *)name status:(LabelStatus)status isSystem:(BOOL)isSystem{
    LabelInfo *info = [[[LabelInfo alloc] init] autorelease];
    info.labelStatus = status;
    info.labelName = name;
    info.isSystemLabel = isSystem;
    return info;
}

@end

@implementation LNLabelViewController

@synthesize titleButton = _titleButton;
@synthesize index = _index;
@synthesize delegate = _delegate;
@synthesize isSelected = _isSelected;
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
    _isSelected = isSelected;
    if(_isSelected) {
        if(self.info.labelStatus == PARENT_LABEL_CLOSE || self.info.labelStatus == PARENT_LABEL_OPEN)
            [self.titleLabel setTextColor:[UIColor magentaColor]];
        else 
            [self.titleLabel setTextColor:[UIColor redColor]];
    }   
    else {
        [self.titleLabel setTextColor:[UIColor grayColor]];
    }
}

- (BOOL)isParentLabel {
    return self.info.labelStatus == PARENT_LABEL_OPEN || self.info.labelStatus == PARENT_LABEL_CLOSE;
}

- (IBAction)clickTitleButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectLabelAtIndex:)]) {
        [self.delegate labelView:self didSelectLabelAtIndex:self.index];
    }
    if(self.info.labelStatus == PARENT_LABEL_OPEN) {
        self.info.labelStatus = PARENT_LABEL_CLOSE;
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didCloseLabelAtIndex:)])
            [self.delegate labelView:self didCloseLabelAtIndex:self.index];
        /*[UIView animateWithDuration:0.3f animations:^{
         CGAffineTransform xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
         self.plusButton.transform = xform;
         }completion:^(BOOL finished) {
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didCloseLabelAtIndex:)])
         [self.delegate labelView:self didCloseLabelAtIndex:self.index];
         }];*/
    }
    else if(self.info.labelStatus == PARENT_LABEL_CLOSE && self.isSelected){ 
        self.info.labelStatus = PARENT_LABEL_OPEN;
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didOpenLabelAtIndex:)])
            [self.delegate labelView:self didOpenLabelAtIndex:self.index];
    }
    self.isSelected = YES;
    
    if([self.titleLabel.text isEqualToString:@"人人测试"]) {
    }
    else if([self.titleLabel.text isEqualToString:@"微博测试"]) {
    }
    else if([self.titleLabel.text isEqualToString:@"新标签测试"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectFriendNotification object:nil userInfo:nil];
    }
}

- (id)initWithStatus:(LabelStatus)status {
    if([self init])
        self.info.labelStatus = status;
    return self;
}

- (void)swipeUp:(UISwipeGestureRecognizer *)ges {
    NSLog(@"swipe top");
    if(self.info.isSystemLabel)
        return;
    if(self.info.labelStatus != PARENT_LABEL_CLOSE)
        return;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didRemoveLabelAtIndex:)])
        [self.delegate labelView:self didRemoveLabelAtIndex:self.index];
}

- (void)setInfo:(LabelInfo *)info {
    if(_info != info) {
        [_info release];
        _info = [info retain];
        self.titleLabel.text = _info.labelName;
    }
}
@end
