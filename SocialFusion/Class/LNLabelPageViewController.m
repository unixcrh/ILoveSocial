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
            LNLabelViewController *label = [[LNLabelViewController alloc] init];
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

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index {
    NSLog(@"select %ud", index);
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

@end
