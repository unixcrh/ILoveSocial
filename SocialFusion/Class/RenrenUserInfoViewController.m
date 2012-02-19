//
//  RenrenUserInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-17.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "RenrenUserInfoViewController.h"
#import "UIImageView+Addition.h"
#import "Image+Addition.h"
#import "RenrenUser+Addition.h"
#import "RenrenClient.h"

#define PHOTO_FRAME_SIDE_LENGTH 100.0f

@implementation RenrenUserInfoViewController

@synthesize birthDayLabel = _birthDayLabel;
@synthesize hometownLabel = _hometownLabel;
@synthesize highSchoolLabel = _highSchoolLabel;
@synthesize universityLabel = _universityLabel;
@synthesize companyLabel = _companyLabel;

- (void)dealloc {
    [_birthDayLabel release];
    [_hometownLabel release];
    [_companyLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.birthDayLabel = nil;
    self.hometownLabel = nil;
    self.highSchoolLabel = nil;
    self.universityLabel = nil;
    self.companyLabel = nil;
}

- (void)configureUI {
    Image *image = [Image imageWithURL:self.renrenUser.detailInfo.mainURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.photoImageView loadImageFromURL:self.renrenUser.detailInfo.mainURL completion:^{
            [self.photoImageView centerizeWithSideLength:PHOTO_FRAME_SIDE_LENGTH];
            [self.photoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else {
        self.photoImageView.image = [UIImage imageWithData:image.imageData.data];
        [self.photoImageView centerizeWithSideLength:PHOTO_FRAME_SIDE_LENGTH];
    }
    if([self.renrenUser.detailInfo.gender isEqualToString:@"m"]) 
        self.genderLabel.text = @"男";
    else if([self.renrenUser.detailInfo.gender isEqualToString:@"f"]) 
        self.genderLabel.text = @"女";
    else
        self.genderLabel.text = @"未知";
    self.birthDayLabel.text = self.renrenUser.detailInfo.birthday;
    self.hometownLabel.text = self.renrenUser.detailInfo.hometownLocation;
    self.universityLabel.text = self.renrenUser.detailInfo.universityHistory;
    self.companyLabel.text = self.renrenUser.detailInfo.workHistory;
    self.highSchoolLabel.text = self.renrenUser.detailInfo.highSchoolHistory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!renren.hasError) {
            NSArray *result = client.responseJSONObject;
            NSDictionary* dict = [result lastObject];
            NSLog(@"renren user info:%@", dict);
            self.renrenUser = [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            [self configureUI];
        };
    }];
	[renren getUserInfoWithUserID:self.renrenUser.userID];
}

@end
