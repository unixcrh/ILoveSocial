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
}

-(void)show;
@end
