//
//  DetailImageViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageViewController : UIViewController<UIScrollViewDelegate> {
    UIImageView* _imageView;
    UIButton* _saveButton;
    UIScrollView* _scrollView;
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)didClickSaveButton:(id)sender;

+ (void)showDetailImageWithURL:(NSString*)bigURL context:(NSManagedObjectContext *)context;
+ (void)showDetailImageWithRenrenUserID:(NSString*)userID photoID:(NSString *)photoID context:(NSManagedObjectContext *)context;
+ (void)showDetailImageWithImage:(UIImage *)image;

@end

