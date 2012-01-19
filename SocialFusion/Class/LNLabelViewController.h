//
//  LNLabelViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNLabelViewControllerDelegate;

#define kDidSelectFriendNotification @"kDidSelectFriendNotification"

typedef enum {
    PARENT_LABEL_CLOSE,
    PARENT_LABEL_OPEN,
    CHILD_LABEL,
} LabelStatus;

@interface LabelInfo : NSObject {
@private
    NSString *_labelName;
    LabelStatus _labelStatus;
    BOOL _isSystemLabel;
}

@property (nonatomic, copy) NSString *labelName;
@property (nonatomic) LabelStatus labelStatus;
@property (nonatomic) BOOL isSystemLabel;

+ (LabelInfo *)labelInfoWithName:(NSString *)name status:(LabelStatus)status isSystem:(BOOL)isSystem;

@end

@interface LNLabelViewController : UIViewController {
    UIButton *_titleButton;
    UIButton *_plusButton;
    NSUInteger _index;
    BOOL _isSelected;
    id<LNLabelViewControllerDelegate> _delegate;
    UILabel *_titleLabel;
    LabelInfo *_info;
}

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL isParentLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) LabelInfo *info;

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