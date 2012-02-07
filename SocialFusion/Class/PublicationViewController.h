//
//  PublicationViewController.h
//  SocialFusion
//
//  Created by Blue Bitch on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicationViewController : UIViewController {
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)didClickNewStatusButton:(id)sender;

@end
