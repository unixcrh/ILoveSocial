//
//  UserInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "RenrenUser+Addition.h"
#import "RenrenUserInfoViewController.h"
#import "WeiboUserInfoViewController.h"

@implementation UserInfoViewController

@synthesize scrollView = _scrollView;
@synthesize photoImageView = _photoImageView;
@synthesize user = _user;
@synthesize photoView = _photoView;

@synthesize genderLabel = _genderLabel;
@synthesize followButton = _followButton;
@synthesize atButton = _atButton;
@synthesize relationshipLabel = _relationshipLabel;
@synthesize nameLabel = _nameLabel;

- (void)dealloc {
    [_scrollView release];
    [_photoImageView release];
    [_user release];
    [_genderLabel release];
    [_photoView release];
    [_followButton release];
    [_atButton release];
    [_relationshipLabel release];
    [_nameLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.photoImageView = nil;
    self.genderLabel = nil;
    self.photoView = nil;
    self.followButton = nil;
    self.atButton = nil;
    self.relationshipLabel = nil;
    self.nameLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.cornerRadius = 5.0f;
}

+ (UserInfoViewController *)getUserInfoViewControllerWithType:(kUserInfoType)type {
    UserInfoViewController *vc;
    if(type == kRenrenUserInfo)
        vc = [[[RenrenUserInfoViewController alloc] initWithType:type] autorelease];
    else if(type == kWeiboUserInfo)
        vc = [[[WeiboUserInfoViewController alloc] initWithType:type] autorelease];
    return vc;
}

- (id)initWithType:(kUserInfoType)type {
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

@end
