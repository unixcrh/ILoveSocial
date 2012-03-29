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
@synthesize scrollView=_scrollView;
@synthesize pageImage=_pageImage;
@synthesize delegate=_delegate;

- (void)dealloc
{
    NSLog(@"SplashView Release");
    [_scrollView release];
    [_pageImage release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNumber=scrollView.contentOffset.x/SPLASHVIEWWIDTH+1;
    NSString* changingPage=[NSString stringWithFormat:@"pagecon%d",pageNumber];
    [_pageImage setImage:[UIImage imageNamed:changingPage]];
    if (scrollView.contentOffset.x==2*SPLASHVIEWWIDTH)
    {
        self.view.backgroundColor=[UIColor clearColor];
    }
    
    if (pageNumber==4)
    {
        UITapGestureRecognizer* gesture;
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.scrollView addGestureRecognizer:gesture];
        [gesture release];

    }
}

-(void)dismissView
{
  
    
  
        [UIView animateWithDuration:0.5f animations:^{
         //   self.view.frame = CGRectMake(-320, 0, 320, 460);
            self.view.alpha=0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [_delegate SplashViewDidRemoved];
            [self release];
        }];
   
    
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_pageImage setImage:[UIImage imageNamed:@"pagecon1"]];

    
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(4*SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    _scrollView.pagingEnabled=YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    UIImageView* view1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro1.png"]];
    view1.frame=CGRectMake(0, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro2.png"]];
    view1.frame=CGRectMake(SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro3.png"]];
    view1.frame=CGRectMake(2*SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    
    view1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro4.png"]];
    view1.frame=CGRectMake(3*SPLASHVIEWWIDTH, 0, SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
    [_scrollView addSubview:view1];
    [view1 release];
    self.view.alpha=0;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha=1;
    } completion:^(BOOL finished) {

    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
