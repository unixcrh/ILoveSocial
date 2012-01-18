//
//  LNLabelViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "LNLabelViewController.h"

@implementation LNLabelViewController

@synthesize button = _button;

- (void)dealloc {
    [_button release];
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
}
@end
