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


-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_contentScrollView)
    {
        scrollView.scrollEnabled=NO;
    }
}
 
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    if (scrollView==_contentScrollView)
    {
        int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
        
        if (index+1!=_albumPageNumber)
        {
        _albumPageNumber= index+1;
        
 
        switch (index%3) {
            case 0:
            {
                if (index!=0)
                {
                    for (int i=18;i<27;i++)
                    {
                        int wid=i%3;
                        int hei=(i-18)/3;
                        _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
                        
  
                    }
                    
                    
                    if (_albumPageNumber*9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])
                    {
                        for (int i=9;i<18;i++)
                        {
                        _imageOut[i].frame=CGRectMake(0,0,0,0);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(0,0,0,0);
                        }
                    }
                    else if (_albumPageNumber*9+9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])  
                 {
                     int count=[((NewFeedShareAlbum*)self.feedData).album_count intValue];
                     int leftNumber=count%9;
                     
                     for (int i=9;i<9+leftNumber;i++)
                     {
                         int wid=i%3;
                         int hei=(i-9)/3;
                         _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                         [_imageView[i] setImage:nil];
                         _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
                         
                     }

                     
                     
                     for (int i=leftNumber+9;i<18;i++)
                     {
                         _imageOut[i].frame=CGRectMake(0,0,0,0);
                         [_imageView[i] setImage:nil];
                         _imageView[i].frame=CGRectMake(0,0,0,0);
                     }

                 }
                    else
                 {
                    for (int i=9;i<18;i++)
                    {
                        int wid=i%3;
                        int hei=(i-9)/3;
                        _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
             
                    }
                }
                    
         
                }
                else
                {
    
                    
                    for (int i=0;i<27;i++)
                    {
                       
                        [_imageView[i] setImage:nil];
                       
                    }
              
                }
                break;
            }
            case 1:
            {
                
                if (_albumPageNumber*9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])
                {
                    for (int i=18;i<27;i++)
                    {
                        _imageOut[i].frame=CGRectMake(0,0,0,0);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(0,0,0,0);
                    }
                }
                
                else if (_albumPageNumber*9+9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])  
                {
                    int count=[((NewFeedShareAlbum*)self.feedData).album_count intValue];
                    int leftNumber=count%9;
                    
                    for (int i=18;i<leftNumber+18;i++)
                    {
                        int wid=i%3;
                        int hei=(i-18)/3;
                        _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
                        
                        
                    }

                    for (int i=leftNumber+18;i<27;i++)
                    {
                        _imageOut[i].frame=CGRectMake(0,0,0,0);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(0,0,0,0);
                    }
                    
                }
                
                
                else   
                {
                for (int i=18;i<27;i++)
                {
                    int wid=i%3;
                    int hei=(i-18)/3;
                    _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                    [_imageView[i] setImage:nil];
                    _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
                    
     
                }
                }
                
        
                for (int i=0;i<9;i++)
                {
                    int wid=i%3;
                    int hei=i/3;
                    _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                    [_imageView[i] setImage:nil];
                    _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
         
                }
                
                break;
            }
            case 2:
            {
                
                              
                for (int i=9;i<18;i++)
                {
                    int wid=i%3;
                    int hei=(i-9)/3;
                    _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                    [_imageView[i] setImage:nil];
                    _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index-1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
           
                }
                
                if (_albumPageNumber*9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])
                {
                    for (int i=0;i<9;i++)
                    {
                        _imageOut[i].frame=CGRectMake(0,0,0,0);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(0,0,0,0);
                    }
                }
                else if (_albumPageNumber*9+9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])  
                {
                    int count=[((NewFeedShareAlbum*)self.feedData).album_count intValue];
                    int leftNumber=count%9;
                    for (int i=0;i<leftNumber;i++)
                    {
                        int wid=i%3;
                        int hei=i/3;
                        _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
                        
                    }
                    
                    
                    for (int i=leftNumber;i<9;i++)
                    {
                        _imageOut[i].frame=CGRectMake(0,0,0,0);
                        [_imageView[i] setImage:nil];
                        _imageView[i].frame=CGRectMake(0,0,0,0);
                    }
                    
                }
                
                else   
                {
                for (int i=0;i<9;i++)
                {
                    int wid=i%3;
                    int hei=i/3;
                    _imageOut[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
                    [_imageView[i] setImage:nil];
                    _imageView[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+3+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 250*(index+1)+IMAGE_OUT_BEGIN_Y+3+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-6);
   
                }
                
                }
                
                break;
            }
            default:
                break;
        }
            
     
    [self loadPhotoData];

        }
                 scrollView.scrollEnabled=YES;
    }

}


-(void)loadPhotoData
{
    
    _activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.center=CGPointMake(153, 300);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            int i=(_albumPageNumber+2)%3*9;
            for(NSDictionary *dict in array) {
                
                Image *image = [Image imageWithURL:[dict objectForKey:@"url_head"] inManagedObjectContext:self.managedObjectContext];
                if (image == nil)
                {
                    [_imageView[i] loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_imageView[i] fadeIn];
                    } cacheInContext:self.managedObjectContext];
                    _imageView[i].clipsToBounds=YES;
                }
                else
                {
                    [_imageView[i] setImage:[UIImage imageWithData:image.imageData.data]];
                    [_imageView[i] fadeIn];
                    
                }
                i++;
                
                
                
            } 
            [_activity stopAnimating];
            
            [_activity release];
        }
    }];
    [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];
    

    
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
        _imageView[i+9*j].clipsToBounds=YES;
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
             else
                {
                    [_imageView[i] setImage:[UIImage imageWithData:image.imageData.data]];
             
                }
                i++;
                
     
                
            } 
            [_activity stopAnimating];
            
            [_activity release];
        }
    }];
    [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];

}
@end
