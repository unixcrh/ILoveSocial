//
//  ShowImage.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "ShowImage.h"
#import  <QuartzCore/QuartzCore.h>
@implementation ShowImage

-(id)initWithImage:(UIImage*)image
{
    self=[super init];
    _imageView=[[UIImageView alloc] initWithImage:image];
    
    _imageView.frame=CGRectMake(0, 0, 220, image.size.height/image.size.width*220);
    _scrollView=[[UIScrollView alloc] init];
    if (_imageView.frame.size.height>300)
    {
        _scrollView.frame=CGRectMake(0, 0, 220, 300);
    }
    else
    {
        _scrollView.frame=CGRectMake(0, 0, 220, _imageView.frame.size.height);
    }
    _scrollView.contentSize=_imageView.frame.size;
    
    [_scrollView addSubview:_imageView];
    
    _scrollView.maximumZoomScale=1.8;

    
    _scrollView.center=CGPointMake(153, 190);
    
    
    [self addSubview:_scrollView];
    
    
    _scrollView.delegate=self;
    

    self.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4];
    
    
    //设置layer
    CALayer *layer=[_imageView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:10.0];
    //设置边框线的宽
    //
    [layer setBorderWidth:2];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    

    
    
    
    return self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


-(void)show
{
     
}
-(void)dealloc
{
    [_imageView release];
    [_scrollView release];
    [super dealloc];
}



@end
