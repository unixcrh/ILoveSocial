//
//  LNRootViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNRootViewController.h"

@implementation LNRootViewController;

@synthesize labelBarViewController = _labelBarViewController;

- (void)dealloc {
    [_labelBarViewController release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.labelBarViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.labelBarViewController.view];
}

- (id)init {
    self = [super init];
    if(self) {
        _labelBarViewController = [[LNLabelBarViewController alloc] init];
    }
    return self;
}

@end
