//
//  PublicationViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "PublicationViewController.h"
#import "NewStatusViewController.h"
#import "UIApplication+Addition.h"

@implementation PublicationViewController

@synthesize scrollView = _scrollView;

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scrollView = nil;
}

- (void)viewDidLoad {
   [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
}

- (IBAction)didClickNewStatusButton:(id)sender  {
    NewStatusViewController *vc = [[NewStatusViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

@end