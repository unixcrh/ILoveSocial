//
//  LNLabelPageViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "LNLabelPageViewController.h"
#import "LNLabelViewController.h"

#define LABEL_OFFSET_X  7
#define LABEL_OFFSET_Y  0
#define LABEL_SPACE     75
#define LABEL_WIDTH     81
#define LABEL_HEIGHT    44

@implementation LNLabelPageViewController

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
    for(int i = 0; i < 4; i++) {
        [self.view addSubview:((LNLabelViewController *)[_labelViews objectAtIndex:i]).view];
    }
}

- (id)init {
    self = [super init];
    if(self) {
        _labelViews = [[NSMutableArray arrayWithCapacity:4] retain];
        for(int i = 0; i < 4; i++) {
            LNLabelViewController *label = [[LNLabelViewController alloc] init];
            label.view.frame = CGRectMake(LABEL_OFFSET_X + i * LABEL_SPACE, LABEL_OFFSET_Y, LABEL_WIDTH, LABEL_HEIGHT);
            [_labelViews insertObject:label atIndex:i];
            [label release];
        }
    }
    return self;
}

@end
