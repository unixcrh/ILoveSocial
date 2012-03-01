//
//  CardBrowserViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-3-1.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardBrowserViewController : UIViewController {
    BOOL _isIpodPlaying;
}

- (void)loadLink:(NSString*)link;

- (IBAction)didClickCloseButton:(id)sender;
- (IBAction)didClickSafariButton:(id)sender;

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
