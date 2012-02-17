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
    
    if(!self.weiboUser.midURL) {
        self.weiboUser.midURL = [self.weiboUser.tinyURL stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
    }
    
    Image *image = [Image imageWithURL:self.weiboUser.midURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.photoImageView loadImageFromURL:self.weiboUser.midURL completion:^{
            [self.photoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else 
        self.photoImageView.image = [UIImage imageWithData:image.imageData.data];
}

@end
