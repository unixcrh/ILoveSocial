//
//  LNRootViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNRootViewController.h"
#import "LabelConverter.h"

#define CONTENT_VIEW_OFFSET_X   7
#define CONTENT_VIEW_OFFSET_Y   64

@implementation LNRootViewController;

@synthesize labelBarViewController = _labelBarViewController;
@synthesize contentViewController = _contentViewController;

- (void)dealloc {
    [_labelBarViewController release];
    [_contentViewController release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.labelBarViewController.view];
    self.contentViewController.view.frame = CGRectMake(CONTENT_VIEW_OFFSET_X, CONTENT_VIEW_OFFSET_Y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
    [self.view addSubview:self.contentViewController.view];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didSelectFriend:) 
                   name:kDidSelectFriendNotification 
                 object:nil];
}

- (id)init {
    self = [super init];
    if(self) {
        NSArray *labelInfo = [LabelConverter getSystemDefaultLabelsInfo];
        _labelBarViewController = [[LNLabelBarViewController alloc] initWithLabelInfoArray:labelInfo];
        _contentViewController = [[LNContentViewController alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark handle notifications

- (void)didSelectFriend:(NSNotification *)notification {
    static int i = 0;
    //[_labelBarViewController createLabelWithInfo:[LabelInfo labelInfoWithName:[NSString stringWithFormat:@"何若运%d",i] status:PARENT_LABEL_CLOSE isSystem:NO]];
    i++;
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
