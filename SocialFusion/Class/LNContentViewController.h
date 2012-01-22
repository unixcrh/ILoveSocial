//
//  LNContentViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNContentViewController : UIViewController {
    NSMutableArray *_contentViewControllerHeap;
    NSUInteger _currentContentIndex;
}

@property (nonatomic, retain, readonly) NSMutableArray *contentViewControllerHeap;
@property (nonatomic) NSUInteger currentContentIndex;

- (id)initWithlabelIdentifiers:(NSArray *)identifers andUsers:(NSDictionary *)userDict;

@end
