//
//  AlbumDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "AlbumDetailController.h"
#define IMAGE_OUT_V_SPACE 7
#define IMAGE_OUT_WIDTH 83
#define IMAGE_OUT_H_SPACE 15
#define IMAGE_OUT_HEIGHT 63
#define IMAGE_OUT_BEGIN_X 22
#define IMAGE_OUT_BEGIN_Y 15

@implementation AlbumDetailController

-(void)setFixedInfo
{
    [super setFixedInfo];
    _contentScrollView.delegate=self;
    _contentScrollView.delegate=self;

}
-(void)loadMainView
{
    for (int i=0;i<12;i++)
    {
        _imageOut[i]=[[UIButton alloc] init];
        int wid=i%3;
        int hei=i/3;
        _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
        [_imageOut[i] setImage:[UIImage imageNamed:@"detail_album"] forState:UIControlStateNormal];
        [_contentScrollView addSubview:_imageOut[i]];
    }
}
@end
