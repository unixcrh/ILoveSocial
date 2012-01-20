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
    BOOL _isSelected;
}

@property (nonatomic, copy) NSString *labelName;
@property (nonatomic) LabelStatus labelStatus;
@property (nonatomic) BOOL isSystemLabel;
@property (nonatomic) BOOL isSelected;


+ (LabelInfo *)labelInfoWithName:(NSString *)name status:(LabelStatus)status isSystem:(BOOL)isSystem;

@end

@interface LNLabelViewController : UIViewController {
    UIButton *_titleButton;
    NSUInteger _index;
    id<LNLabelViewControllerDelegate> _delegate;
    UILabel *_titleLabel;
    LabelInfo *_info;
}

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL isParentLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) LabelInfo *info;

- (IBAction)clickTitleButton:(id)sender;
- (id)initWithStatus:(LabelStatus)status;

@end

@protocol LNLabelViewControllerDelegate <NSObject>

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didOpenLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didCloseLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didRemoveLabelAtIndex:(NSUInteger)index;

@end