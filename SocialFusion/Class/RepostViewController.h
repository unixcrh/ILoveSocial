//
//  RepostViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "WebStringToImageConverter.h"
#import "NewFeedRootData.h"
typedef  enum kShareStyle {
    kNewBlog           =1,
    kPhoto          =2,
    kAlbum          =6,
    kShare          =20,
    kRenrenStatus   =30,
    kWeiboStatus    =40,

    
} kShareStyle;
@interface RepostViewController : PostViewController<WebStringToImageConverterDelegate>
{
    BOOL _repostToRenren;
    BOOL _repostToWeibo;
    
    BOOL _comment;
    kShareStyle _style;
    NewFeedRootData* _feedData;
    
    NSString* _blogData;
    
    IBOutlet UIButton* _repostToRenrenBut;
    IBOutlet UIButton* _repostToWeiboBut;
    
    IBOutlet UIButton* _commentBut;
    IBOutlet UIButton* _commentLabelBut;
}


@property (nonatomic, retain) NewFeedRootData* feedData;
@property (nonatomic, retain) NSString* blogData;


-(void)setStyle:(kShareStyle)style;
- (IBAction)didClickPostToRenrenButton;
- (IBAction)didClickPostToWeiboButton;
- (IBAction)didClickComment;

@end
