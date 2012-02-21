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
#import "NSNotificationCenter+Addition.h"
#import "LabelConverter.h"

#define WEIBO_USER_INFO_SCROLL_VIEW_HEIGHT 530.0f

@interface WeiboUserInfoViewController()
- (void)setRelationshipState;
@end

@implementation WeiboUserInfoViewController

@synthesize blogLabel = _blogLabel;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize locationLabel = _locationLabel;
@synthesize statusCountLabel = _statusCountLabel;
@synthesize friendCountLabel = _friendCountLabel;
@synthesize followerCountLabel = _followerCountLabel;
@synthesize statusCountButton = _statusCountButton;
@synthesize friendCountButton = _friendCountButton;
@synthesize followerCountButton = _followerCountButton;


- (void)dealloc {
    [_blogLabel release];
    [_descriptionTextView release];
    [_locationLabel release];
    
    [_statusCountLabel release];
    [_friendCountLabel release];
    [_followerCountLabel release];
    
    [_statusCountButton release];
    [_followerCountButton release];
    [_friendCountButton release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.blogLabel = nil;
    self.descriptionTextView = nil;
    self.locationLabel = nil;
    
    self.statusCountLabel = nil;
    self.friendCountLabel = nil;
    self.followerCountLabel = nil;
    
    self.statusCountButton = nil;
    self.friendCountButton = nil;
    self.followerCountButton = nil;
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
    
    self.friendCountLabel.text = self.weiboUser.detailInfo.friendsCount;
    self.followerCountLabel.text = self.weiboUser.detailInfo.followersCount;
    self.statusCountLabel.text = self.weiboUser.detailInfo.statusesCount;
    
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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, WEIBO_USER_INFO_SCROLL_VIEW_HEIGHT);
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
                                    
            NSString *state = nil;
            if (followingMe) {
                state = [NSString stringWithFormat:@"%@正关注你。", self.weiboUser.name];
            }
            else {
                state = [NSString stringWithFormat:@"%@未关注你。", self.weiboUser.name];
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

- (IBAction)didClickBasicInfoButton:(id)sender {
    NSString *identifier = nil;
    if([sender isEqual:self.statusCountButton]) {
        identifier = kChildWeiboNewFeed;
    }
    else if([sender isEqual:self.friendCountButton]) {
        identifier = kChildWeiboFriend;
    }
    else if([sender isEqual:self.followerCountButton]) {
        identifier = kChildWeiboFollower;
    }
    [NSNotificationCenter postSelectChildLabelNotificationWithIdentifier:identifier];
}

@end
