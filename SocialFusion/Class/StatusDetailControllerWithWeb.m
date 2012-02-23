//
//  StatusDetailControllerWithWeb.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-11.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "StatusDetailControllerWithWeb.h"
#import "UIImage+Addition.h"
#import "NSData+NsData_Base64.h"
#import "NSString+DataURI.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "Image+Addition.h"
#import "NSString+HTMLSet.h"
#import "RepostViewController.h"
#import "UIApplication+Addition.h"
@implementation StatusDetailControllerWithWeb


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_webView.scrollView)
    {
        
        
        if (_titleView.frame.origin.y+_titleView.frame.size.height>0)
        {
            if (_titleView.frame.origin.y>=0)
            {
                if (scrollView.contentOffset.y<0)
                {
                    _titleView.center=CGPointMake(152, _titleView.frame.size.height/2);
                    _webView.frame=CGRectMake(0, _titleView.frame.size.height+1, 306, 352-_titleView.frame.size.height-1);
                    
                    
                    return;
                }
            }
            
            if (scrollView.contentSize.height==_webView.frame.size.height)
            {
                return;
            }
            _titleView.center=CGPointMake(152, _titleView.center.y-scrollView.contentOffset.y);
            _webView.frame=CGRectMake(0, _webView.frame.origin.y-scrollView.contentOffset.y, 306, _webView.frame.size.height+scrollView.contentOffset.y);
            scrollView.contentOffset=CGPointMake(0, 0); 
        }
        else
        {
            if (scrollView.contentOffset.y<0)
            {
                _titleView.center=CGPointMake(152, _titleView.center.y-scrollView.contentOffset.y);
                _webView.frame=CGRectMake(0, _webView.frame.origin.y-scrollView.contentOffset.y, 306, _webView.frame.size.height+scrollView.contentOffset.y);
                scrollView.contentOffset=CGPointMake(0, 0); 
            }
        }
    }
    else
    {
        [super scrollViewDidScroll:scrollView];
    }
}




- (void)loadMainView
{
    _activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.center=CGPointMake(153, 300);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    [self loadWebView];
}
- (void)loadWebView
{
    
    
    
    if ([(NewFeedData*)self.feedData getPostName]==nil)
    {
        if (((NewFeedData*)self.feedData).pic_URL!=nil)
        {
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"photocelldetail" ofType:@"html"];
            NSString *infoText = [[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText = [infoText setWeibo:[(NewFeedData*)self.feedData getName]];
            
            Image* image = [Image imageWithURL:((NewFeedData*)self.feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
            if (!image)
            {
                [UIImage loadImageFromURL:((NewFeedData*)self.feedData).pic_big_URL completion:^{
                    Image *image1 = [Image imageWithURL:((NewFeedData*)self.feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                    
                    _photoData=[[NSData alloc] initWithData: image1.imageData.data];
                    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                    
                    
                } cacheInContext:self.managedObjectContext];
            }
            else
            {
                _photoData=[[NSData alloc] initWithData: image.imageData.data];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                
            }
            
            
            
            
            [infoText release];
        }
        else
        {
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcelldetail" ofType:@"html"];
            NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText=[infoText setWeibo:[(NewFeedData*)self.feedData getName]];
            [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
            [infoText release];
        }
    }
    else
    {
        if (((NewFeedData*)self.feedData).pic_URL!=nil)
        {
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcellwithphotodetail" ofType:@"html"];
            NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText=[infoText setWeibo:[(NewFeedData*)self.feedData getName]];
            infoText=[infoText setRepost:[(NewFeedData*)self.feedData getPostMessage]];
            Image* image = [Image imageWithURL:((NewFeedData*)self.feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
            if (!image)
            {
                [UIImage loadImageFromURL:((NewFeedData*)self.feedData).pic_big_URL completion:^{
                    Image *image1 = [Image imageWithURL:((NewFeedData*)self.feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                    
                    _photoData=[[NSData alloc] initWithData: image1.imageData.data];
                    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                    
                    
                } cacheInContext:self.managedObjectContext];
            }
            else
            {
                _photoData=[[NSData alloc] initWithData: image.imageData.data];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                
            }
            [infoText release];
        }
        else
        {
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcelldetail" ofType:@"html"];
            NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText=[infoText setWeibo:[(NewFeedData*)self.feedData getName]];
            infoText=[infoText setRepost:[(NewFeedData*)self.feedData getPostMessage]];
            [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
            [infoText release];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    UIImage* image1=[UIImage imageWithData:_photoData];
    
    
    
    NSData* imagedata=UIImageJPEGRepresentation(image1, 10);
    
    
    
    NSString *imgB64 = [[imagedata base64Encoding] jpgDataURIWithContent];
    
    
    
    
    
    NSString* javascript = [NSString stringWithFormat:@"document.getElementById('upload').src='%@'", imgB64];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
    
    
    [_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];

    
    [_photoData release];
    
    [_activity stopAnimating];
    //[_activity removeFromSuperview];
    [_activity release];
    
    if( webView.scrollView.contentSize.height<_titleView.frame.size.height+_webView.frame.size.height)
    {
        _webView.scrollView.delegate=nil;
    }
    
}
- (void)setFixedInfo
{
    [super setFixedInfo];
for (UIView *aView in [_webView subviews])  
{ 
    if ([aView isKindOfClass:[UIScrollView class]])  
    { 
        for (UIView *shadowView in aView.subviews)  
        { 
            if ([shadowView isKindOfClass:[UIImageView class]]) 
            { 
                shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
            } 
        } 
    } 
}  
    _webView.delegate=self;
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    _webView.scrollView.delegate=self;

}

-(IBAction)repost
{
    RepostViewController *vc = [[RepostViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    
    if ([self.feedData getStyle]==0)
    {
    [vc setStyle:kRenrenStatus];
    }
    else
    {
         [vc setStyle:kWeiboStatus];
    }
    vc.feedData=self.feedData;
   
    
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}




@end
