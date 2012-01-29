//
//  PublicationViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "PublicationViewController.h"
#import "NewStatusViewController.h"
#import "UIApplication+Addition.h"

@implementation PublicationViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
   [super viewDidLoad];
}

- (IBAction)didClickNewStatusButton:(id)sender  {
    NewStatusViewController *vc = [[NewStatusViewController alloc] init];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

@end