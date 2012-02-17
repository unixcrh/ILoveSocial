//
//  WeiboUserInfoViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-2-17.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "WeiboUserInfoViewController.h"
#import "UIImageView+Addition.h"
#import "Image+Addition.h"
#import "WeiboUser+Addition.h"

@implementation WeiboUserInfoViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if(!self.weiboUser.detailInfo.headURL) {
//        self.weiboUser.detailInfo.headURL = [self.weiboUser.tinyURL stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
//    }
    
    Image *image = [Image imageWithURL:self.weiboUser.detailInfo.headURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.photoImageView loadImageFromURL:self.weiboUser.detailInfo.headURL completion:^{
            [self.photoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else 
        self.photoImageView.image = [UIImage imageWithData:image.imageData.data];
    if([self.weiboUser.detailInfo.gender isEqualToString:@"m"]) 
        self.genderLabel.text = @"汉子";
    else if([self.weiboUser.detailInfo.gender isEqualToString:@"f"]) 
        self.genderLabel.text = @"妹子";
    else
        self.genderLabel.text = @"未知";
    self.locationLabel.text = self.weiboUser.detailInfo.location;
    self.blogLabel.text = self.weiboUser.detailInfo.blogURL;
    self.descriptionTextView.text = self.weiboUser.detailInfo.selfDescription;
}

@end
