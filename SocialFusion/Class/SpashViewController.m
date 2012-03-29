//
//  SpashViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-3-27.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "SpashViewController.h"

#define SPLASHVIEWWIDTH 320
#define SPLASHVIEWHEIGHT 460

@implementation SpashViewController

@synthesize scrollView = _scrollView;
@synthesize pageImage = _pageImage;
@synthesize delegate = _delegate;

- (void)dealloc
{
    NSLog(@"SplashView Release");
    [_scrollView release];
    [_pageImage release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_pageImage setImage:[UIImage imageNamed:@"pagecon1"]];
    
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(5 * SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    UIImageView* view1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro1.png"]];
    view1.frame = CGRectMake(0, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro2.png"]];
    view1.frame=CGRectMake(SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro3.png"]];
    view1.frame = CGRectMake(2 * SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro4.png"]];
    view1.frame = CGRectMake(3 * SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pageImage = nil;
    self.scrollView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNumber=scrollView.contentOffset.x/SPLASHVIEWWIDTH + 1;
    int pageNumberToChange = pageNumber >= 5 ? 4 : pageNumber;
    NSString* changingPage = [NSString stringWithFormat:@"pagecon%d.png", pageNumberToChange];
    [_pageImage setImage:[UIImage imageNamed:changingPage]];
    
    if (scrollView.contentOffset.x == 2*SPLASHVIEWWIDTH)
    {
        self.view.backgroundColor = [UIColor clearColor];
    }
        
    if(pageNumber == 5) {
        [self dismissView];
    }
}

- (void)dismissView
{
    [self.delegate splashViewWillRemove];
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self release];
    }];
}

@end
