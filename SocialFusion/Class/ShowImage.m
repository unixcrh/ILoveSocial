//
//  ShowImage.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "ShowImage.h"
#import  <QuartzCore/QuartzCore.h>
#import "Image+Addition.h"
#import "UIImage+Addition.h"
@implementation ShowImage

-(id)initWithImage:(UIImage*)image BigURL:(NSString*)bigURL
{
    self=[super init];
    
    _bigURL=[[NSString alloc] initWithString:bigURL];
    _imageView=[[UIImageView alloc] initWithImage:image];
    
    _imageView.frame=CGRectMake(0, 0, 220, image.size.height/image.size.width*220);
    _scrollView=[[UIScrollView alloc] init];
    if (_imageView.frame.size.height>300)
    {
        
        _rect=CGRectMake(0, 0, 220, 300);
    }
    else
    {
        _rect=CGRectMake(0, 0, 220, _imageView.frame.size.height);
    }
    _scrollView.frame=CGRectMake(0 , 0, 1, 1);
    _scrollView.contentSize=_imageView.frame.size;
    
    [_scrollView addSubview:_imageView];
    
  //  _imageView.center=CGPointMake(0, 0);
    _scrollView.maximumZoomScale=1.8;

    
    _scrollView.center=CGPointMake(160, 240);
    
    
    [self addSubview:_scrollView];
    
    
    _scrollView.delegate=self;
    

    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    
    
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


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type=kCATransitionFade;
    animation.removedOnCompletion = NO;
    self.alpha=0;
    
    [self.layer addAnimation:animation forKey:@"animationID"]; 
    
    
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
    [self release];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)setContext:(NSManagedObjectContext*)context
{
    _context=context;
}
-(void)startAnimation
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        _scrollView.frame=_rect;
        _scrollView.center=CGPointMake(160, 240);
        
    } completion:nil];

    

    Image* image = [Image imageWithURL:_bigURL inManagedObjectContext:_context];
    if (!image)
    {
        [UIImage loadImageFromURL:_bigURL completion:^{
            Image *image1 = [Image imageWithURL:_bigURL inManagedObjectContext:_context];
            [_imageView setImage:[UIImage imageWithData:image1.imageData.data]];

        } cacheInContext:_context];
     }
    else
    {
             [_imageView setImage:[UIImage imageWithData:image.imageData.data]];
    }
     
    
}

- (void)didMoveToWindow
{
    [self startAnimation];
}


-(void)show
{
     
}
-(void)dealloc
{
    [_bigURL release];
    [_imageView release];
    [_scrollView release];
    [super dealloc];
}



@end
