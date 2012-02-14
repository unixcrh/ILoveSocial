//
//  AlbumDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "StatusDetailController.h"
#import "PhotoInAlbum.h"
@interface AlbumDetailController : StatusDetailController
{
        IBOutlet UILabel* _albumTitle;
    IBOutlet UIScrollView* _contentScrollView;

    int _albumPageNumber;
    
    PhotoInAlbum* _photoInAlbum[27];
    NSString* _photoID[9];
    NSString* _bigURL[9];
    
    IBOutlet UIView* _contentView;
    
    int _selectedPhoto;

  
}

-(void)loadPhotoData;
-(IBAction)showImageDetail:(id)sender;
@end
