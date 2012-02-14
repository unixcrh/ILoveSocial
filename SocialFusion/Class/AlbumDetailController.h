//
//  AlbumDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "StatusDetailController.h"

@interface AlbumDetailController : StatusDetailController
{
        IBOutlet UILabel* _albumTitle;
    IBOutlet UIScrollView* _contentScrollView;
    UIImageView* _imageView[27];
    UIButton* _imageOut[27];
    int _albumPageNumber;
    
    IBOutlet UIView* _contentView;

  
}

-(void)loadPhotoData;
-(IBAction)showImageDetail:(id)sender;
@end
