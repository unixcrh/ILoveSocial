//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "UIApplication+Addition.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "UIButton+Addition.h"

@interface LeaveMessageViewController()

@end

@implementation LeaveMessageViewController

@synthesize secretWordsTitleButton = _secretWordsTitleButton;
@synthesize secretWordsLightButton = _secretWordsLightButton;

- (void)dealloc {
    [_secretWordsTitleButton release];
    [_secretWordsLightButton release];
    [_dialogist release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.secretWordsTitleButton = nil;
    self.secretWordsLightButton = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        _useSecretWords = NO;
    }
    return self;
}

- (id)initWithUser:(User *)usr{
    self = [self init];
    if(self) {
        _dialogist = [usr retain];
        self.managedObjectContext = usr.managedObjectContext;
        if([usr isMemberOfClass:[RenrenUser class]]) {
            _platformCode = kPlatformRenren;
        }
        else if([usr isMemberOfClass:[WeiboUser class]]) {
            _platformCode = kPlatformWeibo;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_platformCode == kPlatformWeibo) {
        self.secretWordsLightButton.hidden = YES;
        self.secretWordsTitleButton.hidden = YES;
    }
    else if(_platformCode == kPlatformRenren) {
        
    }
}

#pragma mark - 
#pragma mark IBAction

- (IBAction)didClickSecretWordsButton:(id)sender {
    _useSecretWords = !_useSecretWords;
    [self.secretWordsLightButton setPostPlatformButtonSelected:_useSecretWords];
}

@end
