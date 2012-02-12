//
//  FriendListWeiboViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-31.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "FriendListWeiboViewController.h"
#import "FriendListTableViewCell.h"
#import "WeiboUser.h"

@implementation FriendListWeiboViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"FriendListViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_type == RelationshipViewTypeWeiboFriends && self.weiboUser.friends.count == 0) 
        [self refresh];
    if(_type == RelationshipViewTypeWeiboFollowers && self.weiboUser.followers.count == 0) 
        [self refresh];
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_wb.png"];
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.latestStatus.text = usr.latestStatus;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext != managedObjectContext) {
        [_managedObjectContext release];
        _managedObjectContext = [managedObjectContext retain];
        [self clearData];
    }
}

@end
