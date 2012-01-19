//
//  LNRootViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNRootViewController.h"

@implementation LNRootViewController;

@synthesize labelBarViewController = _labelBarViewController;

- (void)dealloc {
    [_labelBarViewController release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.labelBarViewController = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.labelBarViewController.view];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didSelectFriend:) 
                   name:kDidSelectFriendNotification 
                 object:nil];
}

- (id)init {
    self = [super init];
    if(self) {
        _labelBarViewController = [[LNLabelBarViewController alloc] init];
        _labelBarStack = [[NSMutableArray alloc] initWithObjects:_labelBarViewController, nil];
        NSArray *labelInfo = [NSArray arrayWithObjects:
                              [LabelInfo labelInfoWithName:@"新鲜事" status:PARENT_LABEL_CLOSE isSystem:YES],
                              [LabelInfo labelInfoWithName:@"通讯录" status:PARENT_LABEL_CLOSE isSystem:YES],
                              [LabelInfo labelInfoWithName:@"个人档" status:PARENT_LABEL_CLOSE isSystem:YES],
                              [LabelInfo labelInfoWithName:@"收件箱" status:PARENT_LABEL_CLOSE isSystem:YES],
                              [LabelInfo labelInfoWithName:@"人人测试" status:PARENT_LABEL_CLOSE isSystem:NO],
                              [LabelInfo labelInfoWithName:@"微博测试" status:PARENT_LABEL_CLOSE isSystem:NO],
                              [LabelInfo labelInfoWithName:@"新标签测试" status:CHILD_LABEL isSystem:NO], nil];
        [_labelBarViewController.labelInfoArray setArray:labelInfo];
    }
    return self;
}

#pragma mark -
#pragma mark handle notifications

- (void)didSelectFriend:(NSNotification *)notification {
    [_labelBarViewController createLabelWithInfo:[LabelInfo labelInfoWithName:@"何若运" status:PARENT_LABEL_CLOSE isSystem:NO]];
    /*
    User* user = notification.object;
    NSNumber *typeContainer = ((NSNumber *)[notification.userInfo objectForKey:kDisSelectFirendType]);
    RelationshipViewType type = typeContainer.intValue;
    DisplayViewController *displayViewController;
    if(type == RelationshipViewTypeRenrenFriends) {
        displayViewController = [self getDisplayViewControllerWithType:DisplayViewTypeRenren andUser:user];
        [self pushLabelViewControllerWithType:DisplayViewTypeRenren withBackLabelName:user.name];
    }
    else if(type == RelationshipViewTypeWeiboFollowers || type == RelationshipViewTypeWeiboFriends){
        displayViewController = [self getDisplayViewControllerWithType:DisplayViewTypeWeibo andUser:user];
        [self pushLabelViewControllerWithType:DisplayViewTypeWeibo withBackLabelName:user.name];
    }
    else {
        NSLog(@"error while receiving notification");
        return;
    }
    self.delegate = displayViewController;
    [_navigationController pushViewController:displayViewController animated:YES];*/
}

@end
