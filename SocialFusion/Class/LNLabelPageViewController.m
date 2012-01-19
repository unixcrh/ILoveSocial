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
#define ANIMATION_MOVE_LENGTH   250

@implementation LNLabelPageViewController

@synthesize page = _page;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_labelViews release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    for(int i = _labelViews.count - 1; i >= 0; i--) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
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
        for(int i = 0; i < 4; i++) {
            LNLabelViewController *label = [[LNLabelViewController alloc] initWithStatus:PARENT_LABEL_CLOSE];
            label.view.frame = CGRectMake(LABEL_OFFSET_X + i * LABEL_SPACE, LABEL_OFFSET_Y, LABEL_WIDTH, LABEL_HEIGHT);
            [_labelViews addObject:label];
            label.delegate = self;
            label.index = i;
            [label release];
        }
    }
    return self;
}

- (void)unloadSubviews {
    for(int i = 0; i < _labelViews.count; i++) {
        LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
        [label.view removeFromSuperview];
        [label.plusButton setHidden:YES];
    }
}

- (void)selectOtherPage:(NSUInteger)page {
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

- (void)setToOriginAnimation {
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
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelPageView: didSelectPageAtIndex:)]) {
        [self.delegate labelPageView:self didSelectPageAtIndex:self.page];
    }
}

- (void)labelView:(LNLabelViewController *)labelView didSelectOpenAtIndex:(NSUInteger)index {
    [UIView animateWithDuration:0.3f animations:^{
        for(int i = 0; i < _labelViews.count; i++) {
            LNLabelViewController *label = ((LNLabelViewController *)[_labelViews objectAtIndex:i]);
            CGRect oldFrame = label.view.frame;
            CGRect newFrame;
            if(i < index) {
                newFrame = CGRectMake(oldFrame.origin.x - ANIMATION_MOVE_LENGTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            }
            else if(i > index) {
                newFrame = CGRectMake(oldFrame.origin.x + ANIMATION_MOVE_LENGTH, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
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

- (void)labelView:(LNLabelViewController *)labelView didSelectCloseAtIndex:(NSUInteger)index {
    [self setToOriginAnimation];
}

- (void)labelView:(LNLabelViewController *)labelView didRemoveLabelAtIndex:(NSUInteger)index {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect oldFrame = labelView.view.frame;
        CGRect newFrame;
        newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 100, oldFrame.size.width, oldFrame.size.height);
        labelView.view.frame = newFrame;
    } completion:^(BOOL finished) {
        ;
    }];
}

@end
