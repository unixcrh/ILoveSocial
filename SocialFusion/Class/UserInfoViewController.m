//
//  UserInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "UIImageView+Addition.h"
#import "Image+Addition.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"

@implementation UserInfoViewController

@synthesize scrollView = _scrollView;
@synthesize photoImageView = _photoImageView;
@synthesize user = _user;

- (void)dealloc {
    [_scrollView release];
    [_photoImageView release];
    [_user release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.photoImageView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    
    self.photoImageView.layer.masksToBounds = YES;
    self.photoImageView.layer.cornerRadius = 5.0f;
        
    if(!self.weiboUser.midURL) {
        self.weiboUser.midURL = [self.weiboUser.tinyURL stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
    }
    
    Image *image = [Image imageWithURL:self.weiboUser.midURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.photoImageView loadImageFromURL:self.weiboUser.midURL completion:^{
            [self.photoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
}

+ (UserInfoViewController *)getUserInfoViewControllerWithType:(kUserInfoType)type {
    UserInfoViewController *vc = [[[UserInfoViewController alloc] initWithType:type] autorelease];
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
