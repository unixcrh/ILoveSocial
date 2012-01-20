//
//  LNLabelPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelPageViewController.h"

#define LABEL_OFFSET_X  7
#define LABEL_OFFSET_Y  0
#define LABEL_SPACE     75
#define LABEL_WIDTH     81
#define LABEL_HEIGHT    44
#define ANIMATION_HORIZONTAL_MOVE_LENGTH   250
#define ANIMATION_VERTICAL_MOVE_LENGTH   100

@implementation LNLabelPageViewController

@synthesize page = _page;
@synthesize delegate = _delegate;
@synthesize labelInfoSubArray = _labelInfoSubArray;
@synthesize labelViews = _labelViews;

- (void)dealloc {
    [_labelViews release];
    [_labelInfoSubArray release];
    self.delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(int i = 0; i < 4; i++) {
        LNLabelViewController *label = [[LNLabelViewController alloc] initWithStatus:PARENT_LABEL_CLOSE];
        label.view.frame = CGRectMake(LABEL_OFFSET_X + i * LABEL_SPACE, LABEL_OFFSET_Y, LABEL_WIDTH, LABEL_HEIGHT);
        [_labelViews addObject:label];
        label.delegate = self;
        label.index = i;
        [label release];
    }
    
    for(int i = _labelViews.count - 1; i >= 0; i--) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        if(self.labelInfoSubArray.count - 1 < i) {
            [label.view setHidden:YES];
            [label.view setUserInteractionEnabled:NO];
        }
        else {
            label.info = [self.labelInfoSubArray objectAtIndex:i];
        }
        if(self.page == 0 && i == 0) {
            label.isSelected = YES;
        }
        [self.view addSubview:label.view];
    }
}

- (id)init {
    self = [super init];
    if(self) {
        _labelViews = [[NSMutableArray alloc] init];
        _labelInfoSubArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithInfoSubArray:(NSMutableArray *)array pageIndex:(NSUInteger)page{
    self = [self init];
    if(self) {
        self.labelInfoSubArray = array;
        self.page = page;
    }
    return self;
}

- (void)unloadSubviews {
    for(int i = 0; i < _labelViews.count; i++) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        [label.view removeFromSuperview];
    }
}

- (void)selectOtherPage:(NSUInteger)page {
    for(int i = 0; i < _labelViews.count; i++) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        label.isSelected = NO;
    }
    if(page == self.page)
        return;
    [self unloadSubviews];
    if(page > self.page) {
        for(int i = 0; i < _labelViews.count; i++) {
            LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
            [self.view addSubview:label.view];
        }
    }
    else if(page < self.page) {
        for(int i = _labelViews.count - 1; i >= 0; i--) {
            LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
            [self.view addSubview:label.view];
        }
    }
}

- (void)closeParentLabelAnimation {
    [UIView animateWithDuration:0.3f animations:^{
        for(int i = 0; i < _labelViews.count; i++) {
            LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
            CGRect oldFrame = label.view.frame;
            CGRect newFrame;
            newFrame = CGRectMake(LABEL_OFFSET_X + label.index * LABEL_SPACE, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            label.view.frame = newFrame;
        }
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)removeLabelPostAnimation:(NSUInteger)index {
    for(int i = index; i < 4; i++) {
        LNLabelViewController *label = [_labelViews objectAtIndex:i];
        CGRect oldFrame = label.view.frame;
        CGRect newFrame;
        CGFloat posX = LABEL_OFFSET_X + (label.index + 1) * LABEL_SPACE;
        if(i == 3) {
            posX += ANIMATION_HORIZONTAL_MOVE_LENGTH;
        }
        newFrame = CGRectMake(posX, LABEL_OFFSET_Y, oldFrame.size.width, oldFrame.size.height);
        label.view.frame = newFrame;
        
    }
    [UIView animateWithDuration:0.3f animations:^{
        for(int i = index; i < 4; i++) {
            LNLabelViewController *label = [_labelViews objectAtIndex:i];
            CGRect oldFrame = label.view.frame;
            CGRect newFrame;
            newFrame = CGRectMake(LABEL_OFFSET_X + label.index * LABEL_SPACE, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            label.view.frame = newFrame;
        }
    } completion:^(BOOL finished) {
    }];
}


#pragma mark -
#pragma mark LNLabelViewController delegate

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index {
    [self unloadSubviews];
    for(int i = 0; i < index; i++) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        [self.view addSubview:label.view];
    }
    for(int i = _labelViews.count - 1; i > index; i--) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        [self.view addSubview:label.view];
    }
    LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:index]);
    [self.view addSubview:label.view];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelPageView: didSelectLabelAtIndex:)]) {
        BOOL labelPreState = label.isSelected;
        [self.delegate labelPageView:self didSelectLabelAtIndex:self.page * 4 + index];
        if(labelPreState)
            label.isSelected = YES;
    }
}

- (void)labelView:(LNLabelViewController *)labelView didOpenLabelAtIndex:(NSUInteger)index {
    [UIView animateWithDuration:0.3f animations:^{
        for(int i = 0; i < _labelViews.count; i++) {
            LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
            CGRect oldFrame = label.view.frame;
            CGRect newFrame;
            if(i < index) {
                newFrame = CGRectMake(oldFrame.origin.x - ANIMATION_HORIZONTAL_MOVE_LENGTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            }
            else if(i > index) {
                newFrame = CGRectMake(oldFrame.origin.x + ANIMATION_HORIZONTAL_MOVE_LENGTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            }
            else {
                newFrame = CGRectMake(LABEL_OFFSET_X, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            }
            label.view.frame = newFrame;
        }
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)labelView:(LNLabelViewController *)labelView didCloseLabelAtIndex:(NSUInteger)index {
    [self closeParentLabelAnimation];
}

- (void)labelView:(LNLabelViewController *)labelView didRemoveLabelAtIndex:(NSUInteger)index {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect oldFrame = labelView.view.frame;
        CGRect newFrame;
        newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - ANIMATION_VERTICAL_MOVE_LENGTH, oldFrame.size.width, oldFrame.size.height);
        labelView.view.frame = newFrame;
    } completion:^(BOOL finished) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelPageView: didRemoveLabelAtIndex:)]) {
            [self.delegate labelPageView:self didRemoveLabelAtIndex:self.page * 4 + index];
            [self removeLabelPostAnimation:index];
        }
    }];
}

- (void)activateLastLabel:(LabelInfo *)info {
    NSLog(@"activate:%@", info.labelName);
    [self.labelInfoSubArray addObject:info];
    int labelIndex = self.labelInfoSubArray.count - 1;
    LNLabelViewController *label = [_labelViews objectAtIndex:labelIndex];
    [label.view setHidden:NO];
    [label.view setUserInteractionEnabled:YES];
    label.info = info;
    CGRect oldFrame = label.view.frame;
    CGRect newFrame;
    newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + ANIMATION_VERTICAL_MOVE_LENGTH, oldFrame.size.width, oldFrame.size.height);
    label.view.frame = newFrame;
    [UIView animateWithDuration:0.3f animations:^{
        label.view.frame = oldFrame;
    } completion:^(BOOL finished) {
        [self selectLastLabel];
    }];
}

- (void)selectLastLabel {
    int labelIndex = self.labelInfoSubArray.count - 1;
    LNLabelViewController *label = [_labelViews objectAtIndex:labelIndex];
    [label clickTitleButton:nil];
}

- (void)setLabelInfoSubArray:(NSMutableArray *)labelInfoSubArray {
    if(_labelInfoSubArray != labelInfoSubArray) {
        [_labelInfoSubArray release];
        _labelInfoSubArray = [labelInfoSubArray retain];
        if(_labelViews.count < 4)
            return;
        for(int i = 0; i < 4; i++) {
            if(i < _labelInfoSubArray.count) {
                LabelInfo *info = [_labelInfoSubArray objectAtIndex:i];
                LNLabelViewController *label = [_labelViews objectAtIndex:i];
                label.info = info;
            }
            if(i >= _labelInfoSubArray.count) {
                LNLabelViewController *label = [_labelViews objectAtIndex:i];
                label.info = nil;
                [label.view setHidden:YES];
                [label.view setUserInteractionEnabled:NO];
            }
        }
    }
}

@end
