//
//  LNRootViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNRootViewController.h"
#import "LabelConverter.h"
#import "User.h"

#define CONTENT_VIEW_OFFSET_X   7
#define CONTENT_VIEW_OFFSET_Y   64

#define USER_NOT_OPEN   0

@implementation LNRootViewController;

@synthesize labelBarViewController = _labelBarViewController;
@synthesize contentViewController = _contentViewController;

- (void)dealloc {
    [_labelBarViewController release];
    [_contentViewController release];
    [_openedUserHeap release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *labelIdentifier = [LabelConverter getSystemDefaultLabelsIdentifier];
    _contentViewController = [[LNContentViewController alloc] initWithlabelIdentifiers:labelIdentifier andUsers:self.userDict];
    
    [self.view addSubview:self.contentViewController.view];
    
    [self.view addSubview:self.labelBarViewController.view];
    self.contentViewController.view.frame = CGRectMake(CONTENT_VIEW_OFFSET_X, CONTENT_VIEW_OFFSET_Y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
    
    
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
        _labelBarViewController.delegate = self;
        _openedUserHeap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger)getOpenedUserIndex:(User *)user {
    NSUInteger result = USER_NOT_OPEN;
    NSNumber *storediIndex = [_openedUserHeap objectForKey:user.userID];
    if(storediIndex) {
        result = storediIndex.unsignedIntValue;
    }
    return result;
}

#pragma mark -
#pragma mark LNLabelBarViewController delegate

- (void)labelBarView:(LNLabelBarViewController *)labelBar didSelectParentLabelAtIndex:(NSUInteger)index {
    self.contentViewController.currentContentIndex = index;
}

- (void)labelBarView:(LNLabelBarViewController *)labelBar didSelectChildLabelWithIndentifier:(NSString *)identifier inParentLabelAtIndex:(NSUInteger)index {
    [self.contentViewController setContentViewAtIndex:index forIdentifier:identifier];
}

- (void)labelBarView:(LNLabelBarViewController *)labelBar didRemoveParentLabelAtIndex:(NSUInteger)index {
    [self.contentViewController removeContentViewAtIndex:index];
    [_openedUserHeap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSNumber *openedUserIndex = obj;
        if(openedUserIndex.unsignedIntValue == index) {
            [_openedUserHeap removeObjectForKey:key];
            return;
        }
    }];
}

#pragma mark -
#pragma mark handle notifications

- (void)didSelectFriend:(NSNotification *)notification {
    //[_labelBarViewController createLabelWithInfo:[LabelInfo labelInfoWithName:[NSString stringWithFormat:@"何若运%d",i] status:PARENT_LABEL_CLOSE isSystem:NO]];
    
    NSDictionary *userDict = notification.object;
    NSString *identifier;
    User *selectedUser;
    
    if([userDict objectForKey:kWeiboUser]) {
        identifier = kParentWeiboUser;
        selectedUser = [userDict objectForKey:kWeiboUser];
    }
    else if([userDict objectForKey:kRenrenUser]) {
        identifier = kParentRenrenUser;
        selectedUser = [userDict objectForKey:kRenrenUser];
    }
    
    NSUInteger openedUserIndex = [self getOpenedUserIndex:selectedUser];
    if(openedUserIndex != USER_NOT_OPEN) {
        [self.labelBarViewController selectParentLabelAtIndex:openedUserIndex];
        return;
    }
    else {
        [_openedUserHeap setObject:[NSNumber numberWithUnsignedInt:self.labelBarViewController.labelInfoArray.count] forKey:selectedUser.userID];
    }
    
    [self.contentViewController addUserContentViewWithIndentifier:identifier andUsers:userDict];
    LabelInfo *labelInfo = [LabelConverter getLabelInfoWithIdentifier:identifier];
    labelInfo.isRemovable = YES;
    labelInfo.labelName = selectedUser.name;
    [self.labelBarViewController createLabelWithInfo:labelInfo];
}

@end
