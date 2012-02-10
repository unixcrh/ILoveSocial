//
//  BlogDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "BlogDetailController.h"
#import "NewFeedData.h"
#import "Image+Addition.h"
#import "CommonFunction.h"
#import "RenrenClient.h"
#import "NSString+HTMLSet.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
@implementation BlogDetailController

-(void)loadWebView
{
    
    
    [_blogTitle setText:((NewFeedBlog*)self.feedData).title];
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSDictionary *dic = client.responseJSONObject;
            NSString* content=[dic objectForKey:@"content"];
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcelldetail" ofType:@"html"];
            NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText=[infoText setWeibo:content];
            [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
            [infoText release];
            
        }
    }];
    [renren getBlog:[self.feedData getActor_ID] status_ID:[self.feedData getSource_ID]];
    _webView.scrollView.delegate=self;
    _beginY=0;

    
    
}


-(void)loadData
{
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array;
            if  (((NewFeedBlog*)self.feedData).shareID!=nil)
            {
                array=[client.responseJSONObject objectForKey:@"comments"];
                
            }
            else
            {
                array   = client.responseJSONObject;
            }
            //    NSLog(@"%@",array);
            [self ProcessRenrenData:array];
            
        }
    }];
    
    if  (((NewFeedBlog*)self.feedData).shareID!=nil)
    {
        [renren getShareComments:((NewFeedBlog*)self.feedData).sharePersonID share_ID:((NewFeedBlog*)self.feedData).shareID pageNumber:_pageNumber];
    }
    else
    {
        
        [renren getBlogComments:[self.feedData getActor_ID] status_ID:[self.feedData getSource_ID] pageNumber:_pageNumber];
    }       
    
}
-(IBAction)upTheName
{
   
    
    if (_pageControl.currentPage==0)
    {
    if (_titleView.center.y<-41)
    {
           _beginY=_webView.scrollView.contentOffset.y;
        [UIView animateWithDuration:0.3f animations:^{
            _titleView.center=CGPointMake(152, 50);
            _webView.frame=CGRectMake(0, 92, 306, 260);
          
        }];
    }
    else
    {
    [UIView animateWithDuration:0.3f animations:^{
        _titleView.center=CGPointMake(152, -42);
        _webView.frame=CGRectMake(0, 0, 306, 352);
        
    }];
    }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==_webView.scrollView)
    {
        if (_titleView.center.y<-41)
        {
            _beginY=0;
            if (scrollView.contentOffset.y<0)
            {
                _titleView.center=CGPointMake(152, _titleView.center.y-scrollView.contentOffset.y);
                _webView.frame=CGRectMake(0, _webView.frame.origin.y-scrollView.contentOffset.y, 306, _webView.frame.size.height+scrollView.contentOffset.y);
                scrollView.contentOffset=CGPointMake(0, 0);
            }
  
        }
        else if (_titleView.center.y>49)
        {
            
            if ((scrollView.contentOffset.y>_lastY)&&scrollView.contentOffset.y>0)
            {
  
                    _titleView.center=CGPointMake(152, 50-scrollView.contentOffset.y+_beginY);
               
                    _webView.frame=CGRectMake(0, 92-scrollView.contentOffset.y+_beginY, 306, 260+scrollView.contentOffset.y-_beginY);
                _beginY=scrollView.contentOffset.y;
                
            }
            
        
            if (_titleView.center.y>49)
            {
                _titleView.center=CGPointMake(152, 50);
                _webView.frame=CGRectMake(0, 92, 306, 260);
                
            }
            
            
        }
        else
        {
            _titleView.center=CGPointMake(152, _titleView.center.y-scrollView.contentOffset.y+_beginY);
                     _webView.frame=CGRectMake(0, _webView.frame.origin.y-scrollView.contentOffset.y+_beginY, 306, _webView.frame.size.height+scrollView.contentOffset.y-_beginY);
            scrollView.contentOffset=CGPointMake(0, _beginY);
            
            if (_titleView.center.y<-42)
            {
                _titleView.center=CGPointMake(152, -42);
                _webView.frame=CGRectMake(0, 0, 306, 352);
            }

            
        }
        
        
        
        _lastY=scrollView.contentOffset.y;
    }
}



@end
