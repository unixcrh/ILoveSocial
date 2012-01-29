//
//  FriendListViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 11-10-4.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"
#import "RenrenUser+Addition.h"
#import "RenrenStatus+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+DispatchLoad.h"
#import "User+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"


#import "NSNotificationCenter+Addition.h"

#define kCustomRowCount 7

@implementation FriendListViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"friend list view did load");
    self.egoHeaderView.textColor = [UIColor grayColor];
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headImageView.image = nil;
    relationshipCell.latestStatus.text = nil;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.userName.text = usr.name;

    if(_type == RelationshipViewTypeRenrenFriends) {
        relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_renren.png"];
    }
    else {
        relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_wb.png"];
    }
    
    if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.latestStatus.text = usr.latestStatus;
    }
    
    NSData *imageData = nil;
    if([Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData == nil) {
        if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
                    [self showHeadImageAnimation:relationshipCell.headImageView];
                } cacheInContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.headImageView.image = [UIImage imageWithData:imageData];
    }
}

- (NSString *)customCellClassName
{
    return @"FriendListTableViewCell";
}

- (NSString *)customSectionNameKeyPath {
    if(_type == RelationshipViewTypeRenrenFriends)
        return @"nameFirstLetter";
    else
        return @"updateDate";
}

#pragma mark -
#pragma mark UITableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // 清空选中状态
    cell.highlighted = NO;
    cell.selected = NO;
    [self.tableView reloadData];
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:self.currentUserDict];
    if([usr isMemberOfClass:[RenrenUser class]])
        [userDict setObject:usr forKey:kRenrenUser];
    else if([usr isMemberOfClass:[WeiboUser class]]) 
        [userDict setObject:usr forKey:kWeiboUser];
    [NSNotificationCenter postDidSelectFriendNotificationWithUserDict:userDict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] autorelease];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:0.6f]];
    NSString *section_name = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 306, 18)];
    label.text = section_name;
    label.font = [UIFont fontWithName:@"MV Boli" size:16.0f];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [label release];
    return headerView;
}

#pragma mark -
#pragma mark Animations

- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil)
    {
        FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
            [self showHeadImageAnimation:relationshipCell.headImageView];
        } cacheInContext:self.managedObjectContext];
    }
    if(_type == RelationshipViewTypeRenrenFriends && !usr.latestStatus) {
        [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //NSLog(@"update user name:%@", usr.name);
    if(![relationshipCell.latestStatus.text isEqualToString:usr.latestStatus]) {
        relationshipCell.latestStatus.text = usr.latestStatus;
        relationshipCell.latestStatus.alpha = 0.3f;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            relationshipCell.latestStatus.alpha = 1;
        } completion:nil];
    }
}

@end
