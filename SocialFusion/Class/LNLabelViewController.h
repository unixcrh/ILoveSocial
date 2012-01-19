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
    PARENT_LABEL_CLOSE,
    PARENT_LABEL_OPEN,
    CHILD_LABEL,
} LabelStatus;

@interface LNLabelViewController : UIViewController {
    UIButton *_titleButton;
    UIButton *_plusButton;
    NSUInteger _index;
    LabelStatus _labelStatus;
    BOOL _isSelected;
    id<LNLabelViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) LabelStatus labelStatus;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL isParentLabel;

- (IBAction)clickTitleButton:(id)sender;
- (IBAction)clickPlusButton:(id)sender;
- (id)initWithStatus:(LabelStatus)status;

@end

@protocol LNLabelViewControllerDelegate <NSObject>

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didSelectOpenAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didSelectCloseAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didRemoveLabelAtIndex:(NSUInteger)index;

@end