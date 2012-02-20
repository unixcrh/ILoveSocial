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
#import "WeiboClient.h"
#import "UIApplication+Addition.h"
#import "LeaveMessageViewController.h"

@interface WeiboUserInfoViewController()
- (void)setRelationshipState;
@end

@implementation WeiboUserInfoViewController

@synthesize blogLabel = _blogLabel;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize locationLabel = _locationLabel;


- (void)dealloc {
    [_blogLabel release];
    [_descriptionTextView release];
    [_locationLabel release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.blogLabel = nil;
    self.descriptionTextView = nil;
    self.locationLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    Image *image = [Image imageWithURL:self.weiboUser.detailInfo.headURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.photoImageView loadImageFromURL:self.weiboUser.detailInfo.headURL completion:^{
            [self.photoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else 
        self.photoImageView.image = [UIImage imageWithData:image.imageData.data];
    if([self.weiboUser.detailInfo.gender isEqualToString:@"m"]) 
        self.genderLabel.text = @"男";
    else if([self.weiboUser.detailInfo.gender isEqualToString:@"f"]) 
        self.genderLabel.text = @"女";
    else
        self.genderLabel.text = @"未知";
    self.locationLabel.text = self.weiboUser.detailInfo.location;
    self.blogLabel.text = self.weiboUser.detailInfo.blogURL;
    self.descriptionTextView.text = self.weiboUser.detailInfo.selfDescription;
    self.nameLabel.text = self.weiboUser.name;
    
    [self setRelationshipState];
}

- (void)adjustFollowButtonHeightImage:(BOOL)followedByMe {
    NSString *highlightImageName = nil;
    if(followedByMe) {
        highlightImageName = @"user_info_btn_not_follow@2x.png";
    }
    else {
        highlightImageName = @"user_info_btn_follow@2x.png";
    }
    [self.followButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
}

- (void)setRelationshipState
{
    if ([self.weiboUser isEqualToUser:self.currentWeiboUser]) {
        self.followButton.hidden = YES;
        self.relationshipLabel.text = @"";
        self.atButton.hidden = YES;
    }
    else {
        [self.followButton setUserInteractionEnabled:NO];
        WeiboClient *client = [WeiboClient client];
        
        [client setCompletionBlock:^(WeiboClient *client) {
            [self.followButton setUserInteractionEnabled:YES];
            NSDictionary *dict = client.responseJSONObject;
            dict = [dict objectForKey:@"target"];
            
            BOOL followedByMe = [[dict objectForKey:@"followed_by"] boolValue];
            BOOL followingMe = [[dict objectForKey:@"following"] boolValue];
            
            [self.followButton setSelected:followedByMe];
            [self adjustFollowButtonHeightImage:followedByMe];
            
            NSString *gender = nil;
            if([self.weiboUser.detailInfo.gender isEqualToString:@"m"]) 
                gender = @"他";
            else if([self.weiboUser.detailInfo.gender isEqualToString:@"f"]) 
                gender = @"她";
                        
            NSString *state = nil;
            if (followingMe) {
                state = [NSString stringWithFormat:@"%@正在关注你", gender];
            }
            else {
                state = [NSString stringWithFormat:@"%@没有关注你", gender];
            }
            self.relationshipLabel.text = state;
        }];
        
        [client getRelationshipWithUser:self.weiboUser.userID];
    }
}

- (void)setFollowButtonSelected {
    [self.followButton setSelected:!self.followButton.isSelected];
    [self adjustFollowButtonHeightImage:self.followButton.isSelected];
}

- (IBAction)didClickFollowButton {
    WeiboClient *client = [WeiboClient client];
    [self.followButton setUserInteractionEnabled:NO];
    [self setFollowButtonSelected];
    if(!self.followButton.isSelected) {
        [client setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                [[UIApplication sharedApplication] presentToast:@"已取消关注。" withVerticalPos:kToastBottomVerticalPosition];
            }
            else {
                [[UIApplication sharedApplication] presentToast:@"取消关注失败。" withVerticalPos:kToastBottomVerticalPosition];
                [self setFollowButtonSelected];
            }
            [self.followButton setUserInteractionEnabled:YES];
        }];
        [client unfollow:self.weiboUser.userID];
    }
    else {
        [client setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                [[UIApplication sharedApplication] presentToast:@"已添加关注。" withVerticalPos:kToastBottomVerticalPosition];
            }
            else {
                [[UIApplication sharedApplication] presentToast:@"添加关注失败。" withVerticalPos:kToastBottomVerticalPosition];
                [self setFollowButtonSelected];
            }
            [self.followButton setUserInteractionEnabled:YES];
        }];
        [client follow:self.weiboUser.userID];
    }
}    

- (IBAction)didClickAtButton {
    User *usr = (User *)self.weiboUser;
    LeaveMessageViewController *vc = [[LeaveMessageViewController alloc] initWithUser:usr];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

@end
