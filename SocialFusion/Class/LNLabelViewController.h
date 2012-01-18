//
//  LNLabelViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNLabelViewControllerDelegate;
@interface LNLabelViewController : UIViewController {
    UIButton *_button;
    NSUInteger _index;
    id<LNLabelViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
@property NSUInteger index;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;

- (IBAction)clickButton:(id)sender;

@end

@protocol LNLabelViewControllerDelegate <NSObject>

- (void)labelViewDidSelectLabelAtIndex:(NSUInteger)index;

@end