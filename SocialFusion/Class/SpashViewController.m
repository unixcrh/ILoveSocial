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

- (void)dealloc
{
    NSLog(@"SplashView Release");
    [_scrollView release];
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
    if (scrollView.contentOffset.x==0)
    {
        self.view.backgroundColor=[UIColor blackColor];
    } 
    if (scrollView.contentOffset.x==2*SPLASHVIEWWIDTH)
    {
        self.view.backgroundColor=[UIColor clearColor];

    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static BOOL remove=NO;
    
    if (scrollView.contentOffset.x>2*SPLASHVIEWWIDTH+10)
    {
        if (remove==NO)
        {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(-320, 0, 320, 460);
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self release];
        }];
            remove=YES;

        }
    }
    
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
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(3*SPLASHVIEWWIDTH, SPLASHVIEWHEIGHT);
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
