//
//  BlogDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "StatusDetailController.h"

@interface BlogDetailController : StatusDetailController
{
    IBOutlet UILabel* _blogTitle;
    IBOutlet UIView* _titleView;
    IBOutlet UIButton* _changeButton;
    int _beginY;
}
-(IBAction)upTheName;
@end
