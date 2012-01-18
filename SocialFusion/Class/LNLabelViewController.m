//
//  LNLabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelViewController.h"

@implementation LNLabelViewController

@synthesize titleButton = _titleButton;
@synthesize index = _index;
@synthesize delegate = _delegate;
@synthesize labelType = _labelType;
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
}

- (IBAction)clickButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectLabelAtIndex:)]) {
        [self.delegate labelView:self didSelectLabelAtIndex:self.index];
    }
    if(self.labelType == PARENT_LABEL) {
        [self.plusButton setHidden:NO];
        self.isSelected = YES;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if(isSelected == YES)
        [self.plusButton setHidden:NO];
}

@end
