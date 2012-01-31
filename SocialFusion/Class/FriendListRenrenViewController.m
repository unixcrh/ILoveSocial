//
//  FriendListRenrenViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-31.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "FriendListRenrenViewController.h"
#import "FriendListTableViewCell.h"
#import "RenrenStatus+Addition.h"

@implementation FriendListRenrenViewController

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
    if(self.renrenUser.friends.count == 0) 
        [self refresh];
}



#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_renren.png"];
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(!usr.latestStatus) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.latestStatus.text = usr.latestStatus;
    }
}

- (NSString *)customSectionNameKeyPath {
    return @"nameFirstLetter";
}

#pragma mark -
#pragma mark UITableView delegates

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
    [super loadExtraDataForOnScreenRowsHelp:indexPath];
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(!usr.latestStatus) {
        [RenrenStatus loadLatestStatus:usr inManagedObjectContext:self.managedObjectContext];
    }
}

@end
