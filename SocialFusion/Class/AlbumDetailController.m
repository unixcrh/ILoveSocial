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
#import "NewFeedTempImageView.h"


#define IMAGE_OUT_BEGIN_X 10
#define IMAGE_OUT_BEGIN_Y 5
#define IMAGE_OUT_V_SPACE 20
#define IMAGE_OUT_WIDTH 83
#define IMAGE_OUT_H_SPACE 17
#define IMAGE_OUT_HEIGHT 66



@implementation AlbumDetailController


-(void)dealloc
{
    for (int i=0;i<27;i++)
    {
         [_photoInAlbum[i] release];
    }

    
    for (int i=0;i<9;i++)
    {
        [_photoID[i] release];
        [_bigURL[i]  release];

    }
    [super release];
    
}
-(void)setFixedInfo
{
    [super setFixedInfo];
    _contentScrollView.delegate=self;
    _selectedPhoto=-1;
    

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
                        
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];
                       
                        
  
                    }
                    
                    
                    if (_albumPageNumber*9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])
                    {
                        for (int i=9;i<18;i++)
                        {
                            _photoInAlbum[i].frame=CGRectMake(0, 0, 0, 0);
                        [_photoInAlbum[i].imageView setImage:nil];
  
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
                         
                         _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                         [_photoInAlbum[i].imageView setImage:nil];
                         
                    
                     }

                     
                     
                     for (int i=leftNumber+9;i<18;i++)
                     {
                         
                         int wid=i%3;
                         int hei=(i-9)/3;
                         
                         _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                         [_photoInAlbum[i].imageView setImage:nil];
                     }

                 }
                    else
                 {
                    for (int i=9;i<18;i++)
                    {
                        int wid=i%3;
                        int hei=(i-9)/3;
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];                    }
                }
                    
         
                }
                else
                {
    
                    
                    for (int i=0;i<27;i++)
                    {
                       
                       
                        [_photoInAlbum[i].imageView setImage:nil];
                       
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
                        int wid=i%3;
                        int hei=(i-18)/3;
                        
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];
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
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];                        
                    }

                    for (int i=leftNumber+18;i<27;i++)
                    {
                        int wid=i%3;
                        int hei=(i-18)/3;
                        
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];
                    }
                    
                }
                
                
                else   
                {
                for (int i=18;i<27;i++)
                {
                    int wid=i%3;
                    int hei=(i-18)/3;
                    _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                    [_photoInAlbum[i].imageView setImage:nil];     
                }
                }
                
        
                for (int i=0;i<9;i++)
                {
                    int wid=i%3;
                    int hei=i/3;
                    _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                    [_photoInAlbum[i].imageView setImage:nil];                }
                
                break;
            }
            case 2:
            {
                
                              
                for (int i=9;i<18;i++)
                {
                    int wid=i%3;
                    int hei=(i-9)/3;
                    _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                    [_photoInAlbum[i].imageView setImage:nil];                }
                
                if (_albumPageNumber*9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])
                {
                    for (int i=0;i<9;i++)
                    {
                        int wid=i%3;
                        int hei=(i-9)/3;
                        
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];                    }
                }
                else if (_albumPageNumber*9+9>[((NewFeedShareAlbum*)self.feedData).album_count intValue])  
                {
                    int count=[((NewFeedShareAlbum*)self.feedData).album_count intValue];
                    int leftNumber=count%9;
                    for (int i=0;i<leftNumber;i++)
                    {
                        int wid=i%3;
                        int hei=i/3;
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];
                    }
                    
                    
                    for (int i=leftNumber;i<9;i++)
                    {
                        
                        int wid=i%3;
                        int hei=(i)/3;
                        
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];
                    }
                    
                }
                
                else   
                {
                for (int i=0;i<9;i++)
                {
                    int wid=i%3;
                    int hei=i/3;
                    _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                    [_photoInAlbum[i].imageView setImage:nil];                }
                
                }
                
                break;
            }
            default:
                break;
        }
            
     
            
            for (int i=0;i<27;i++)
            {
               
                [_photoInAlbum[i].captian setText:nil];
            }
    [self loadPhotoData];

        }
    }

}

-(void)returnToAlbum
{
    [_contentScrollView zoomToRect:CGRectMake(0, 0, 306, 255) animated:YES];
    [_infoTextView removeFromSuperview];
    [_infoTextView release];
    
    [_returnToAlbum removeFromSuperview];
    [_returnToAlbum release];
    _selectedPhoto=-1;
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
  if (_selectedPhoto!=-1)
  {
   _infoTextView =[[UITextView alloc] init];
    _infoTextView.frame=CGRectMake(17, 300, 270,40);
    _infoTextView.editable=NO;
    _infoTextView.backgroundColor=[UIColor clearColor];
    _infoTextView.text=_photoInAlbum[_selectedPhoto].captian.text;
    
    _returnToAlbum=[[UIButton alloc] init];
    _returnToAlbum.frame=CGRectMake(225 ,67, 72, 21);
    [_returnToAlbum setTitle:@"return" forState:UIControlStateNormal];
    [_returnToAlbum setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     [_returnToAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_returnToAlbum addTarget:self action:@selector(returnToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_returnToAlbum];
    [self.view addSubview:_infoTextView];

    Image *image = [Image imageWithURL:_bigURL[_selectedPhoto%9] inManagedObjectContext:self.managedObjectContext];
    if (image == nil)
    {
        [_photoInAlbum[_selectedPhoto].imageView loadImageFromURL:_bigURL[_selectedPhoto%9] completion:^{
                    
          
        } cacheInContext:self.managedObjectContext];

    }
    else
    {
        [_photoInAlbum[_selectedPhoto].imageView setImage:[UIImage imageWithData:image.imageData.data]];

    }
  }
}


-(IBAction)showImageDetail:(id)sender
{
 
    
    if (_selectedPhoto==-1)
    {
    for (int i=0;i<27;i++)
    {
        if (_photoInAlbum[i].imageOut==sender)
        {
            _selectedPhoto=i;
            break;
        }
    }
    _photoInAlbum[_selectedPhoto].captian.frame=CGRectMake(0, 0, 0, 0);
    [_photoInAlbum[_selectedPhoto].imageOut setImage:[UIImage imageNamed:@"detail_photo.png"] forState:UIControlStateNormal];
    [_contentView bringSubviewToFront:_photoInAlbum[1].imageOut];
    
    CGRect zoomingRect=((UIButton*)sender).superview.frame;

    [_contentScrollView zoomToRect:zoomingRect animated:YES];
    _contentScrollView.scrollEnabled=NO;
    }
    else
    {
        Image* imageData = [Image imageWithURL:_bigURL[_selectedPhoto%9] inManagedObjectContext:self.managedObjectContext];
        UIImage *image = [UIImage imageWithData:imageData.imageData.data];
        NewFeedTempImageView* tempImage = [NewFeedTempImageView tempImageViewWithImage:image];
        [tempImage show];
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
                    [_photoInAlbum[i].imageView loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_photoInAlbum[i].imageView fadeIn];
                    } cacheInContext:self.managedObjectContext];
                    _photoInAlbum[i].imageView.clipsToBounds=YES;
                }
                else
                {
                    [_photoInAlbum[i].imageView setImage:[UIImage imageWithData:image.imageData.data]];
                    [_photoInAlbum[i].imageView fadeIn];
                    
                }
                
                [_photoInAlbum[i].captian setText:[dict objectForKey:@"caption"]];
                
                
                int j=i%9;
                [_photoID[j] release];
               _photoID[j] =[[NSString alloc ] initWithString:[[dict objectForKey:@"pid"] stringValue]];
                [_bigURL[j] release];
                _bigURL[j]=[[NSString alloc] initWithString:[dict objectForKey:@"url_large"]];
                
                i++;
                
                
                
            } 
            [_activity stopAnimating];
            
            [_activity release];
            _contentScrollView.scrollEnabled=YES;

        }
    }];
    [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];
    

    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _contentView;
}
-(void)loadMainView
{
    _albumPageNumber=1;
    _contentScrollView.pagingEnabled=YES;
    _contentScrollView.directionalLockEnabled=YES;
    _contentScrollView.maximumZoomScale=10.0;
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* ([((NewFeedShareAlbum*)self.feedData).album_count intValue]/9+1))];
    [_contentView setFrame:CGRectMake(0, 0,_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* ([((NewFeedShareAlbum*)self.feedData).album_count intValue]/9+1))];
    for (int j=0;j<3;j++)
    {
    for (int i=0;i<9;i++)
    {
        
        _photoInAlbum[i+9*j]=[[PhotoInAlbum alloc] init];
        
        int wid=i%3;
        int hei=i/3;
        _photoInAlbum[i+9*j].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), 255*j+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
             
        [ _photoInAlbum[i+9*j].imageOut addTarget:self action:@selector(showImageDetail:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_photoInAlbum[i+9*j]];
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
                    [_photoInAlbum[i].imageView loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_photoInAlbum[i].imageView fadeIn];
                    } cacheInContext:self.managedObjectContext];
                 
                }
             else
                {
                    [_photoInAlbum[i].imageView setImage:[UIImage imageWithData:image.imageData.data]];
             
                }
                
                  [_photoInAlbum[i].captian setText:[dict objectForKey:@"caption"]];
                
                
                _photoID[i]=[[NSString alloc ] initWithString:[[dict objectForKey:@"pid"] stringValue]];
                _bigURL[i]=[[NSString alloc] initWithString:[dict objectForKey:@"url_large"]];
            
                i++;
                
     
                
            } 
            [_activity stopAnimating];
            
            [_activity release];
        }
    }];
    [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];

}
@end
