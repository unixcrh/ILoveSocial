//
//  PickAtListViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "PickAtListViewController.h"
#import "UIButton+Addition.h"

#define kPlatformRenren NO
#define kPlatformWeibo  YES

@implementation PickAtListViewController

@synthesize delegate = _delegate;
@synthesize renrenButton = _renrenButton;
@synthesize weiboButton = _weiboButton;

- (void)dealloc {
    [_renrenButton release];
    [_weiboButton release]; 
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.renrenButton = nil;
    self.weiboButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.renrenButton setPostPlatformButtonSelected:YES];
}

- (id)init {
    self = [super init];
    if(self) {
        _platformCode = kPlatformRenren;
    }
    return self;
}

#pragma mark -
#pragma makr IBAction

- (IBAction)didClickCancelButton:(id)sender {
    [self.delegate didPickAtUser];
}

- (IBAction)didClickFinishButton:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)didClickRenrenButton:(id)sender {
    _platformCode = kPlatformRenren;
    [self.renrenButton setPostPlatformButtonSelected:YES];
    [self.weiboButton setPostPlatformButtonSelected:NO];
}

- (IBAction)didClickWeiboButton:(id)sender {
    _platformCode = kPlatformWeibo;
    [self.renrenButton setPostPlatformButtonSelected:NO];
    [self.weiboButton setPostPlatformButtonSelected:YES];
}

@end
