//
//  LNRootViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "LNLabelBarViewController.h"

@interface LNRootViewController : CoreDataViewController {
    LNLabelBarViewController *_labelBarViewController;
}

@property (nonatomic, retain) LNLabelBarViewController *labelBarViewController;

@end
