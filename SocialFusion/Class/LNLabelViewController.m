//
//  LNLabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelViewController.h"

@implementation LNLabelViewController

@synthesize button = _button;
@synthesize index = _index;
@synthesize delegate = _delegate;

- (void)dealloc {
    NSLog(@"LNLabelViewController dealloc");
    [_button release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.button = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
}

- (IBAction)clickButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(labelView: didSelectLabelAtIndex:)]) {
        [self.delegate labelView:self didSelectLabelAtIndex:self.index];
    }
}

@end
