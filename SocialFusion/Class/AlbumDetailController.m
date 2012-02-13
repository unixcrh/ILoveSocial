//
//  AlbumDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "AlbumDetailController.h"
#import "NewFeedShareAlbum+Addition.h"
#import "RenrenClient.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
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


}

-(void)loadMainView
{
    _albumPageNumber=1;
    _contentScrollView.pagingEnabled=YES;
    _contentScrollView.directionalLockEnabled=YES;
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* ([((NewFeedShareAlbum*)self.feedData).album_count intValue]/9+1))];
    
    for (int j=0;j<3;j++)
    {
    for (int i=0;i<9;i++)
    {
        _imageOut[i+9*j]=[[UIButton alloc] init];
        _imageView[i+9*j]=[[UIImageView alloc] init];
        int wid=i%3;
        int hei=i/3;
        _imageOut[i+9*j].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*j+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
        [_imageOut[i+9*j] setImage:[UIImage imageNamed:@"detail_album"] forState:UIControlStateNormal];
        [_contentScrollView addSubview:_imageOut[i+9*j]];
        
        _imageView[i+9*j].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*j+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
        [_contentScrollView addSubview:_imageView[i+9*j]];
        _imageView[i+9*j].contentMode=UIViewContentModeScaleAspectFill;
    }
    
    }
      
    
    [_albumTitle setText:((NewFeedShareAlbum*)self.feedData).album_title];
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
           NSArray *array = client.responseJSONObject;
            int i=0;
            for(NSDictionary *dict in array) {
                
                Image *image = [Image imageWithURL:[dict objectForKey:@"url_head"] inManagedObjectContext:self.managedObjectContext];
                if (image == nil)
                {
                    [_imageView[i] loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_imageView[i] fadeIn];
                    } cacheInContext:self.managedObjectContext];
                    _imageView[i].clipsToBounds=YES;
                }
                i++;
                
            //    [_activity stopAnimating];
              //  [_activity removeFromSuperview];
              //  [_activity release];
                
            } 
        }
    }];
    [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];

}
@end
