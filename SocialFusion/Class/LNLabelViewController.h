//
//  LNLabelViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNLabelViewControllerDelegate;

typedef enum {
    PARENT_LABEL,
    CHILD_LABEL,
} LabelType;

@interface LNLabelViewController : UIViewController {
    UIButton *_titleButton;
    UIButton *_plusButton;
    NSUInteger _index;
    LabelType _labelType;
    BOOL _isSelected;
    id<LNLabelViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) LabelType labelType;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;

- (IBAction)clickTitleButton:(id)sender;
- (IBAction)clickPlusButton:(id)sender;

@end

@protocol LNLabelViewControllerDelegate <NSObject>

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didSelectPlusAtIndex:(NSUInteger)index;

@end