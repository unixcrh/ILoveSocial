//
//  ShowImage.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImage : UIView<UIScrollViewDelegate>
{
    UIImageView* _imageView;
    UIScrollView* _scrollView;
    CGRect _rect;
    NSString* _bigURL;
    NSManagedObjectContext *_context;

    NSString* _userID;
    NSString* _photoID;
}
-(void)setContext:(NSManagedObjectContext*)context;
-(id)initWithImage:(UIImage*)image BigURL:(NSString*)bigURL;
-(id)initWithImage:(UIImage*)image userID:(NSString*)userID photoID:(NSString*)photoID;
-(void)show;
@end
