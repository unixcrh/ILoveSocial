//
//  NewFeedBlogCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedBlogCell.h"
#import "CommonFunction.h"

@implementation NewFeedBlogCell


- (void)dealloc
{

        [super dealloc];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('%@')",[_feedData getBlog]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData getDate]]]];
    
   
    int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
    
    
    
    _webView.frame=CGRectMake(_webView.frame.origin.x, _webView.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
}




-(void)configureCell:(NewFeedData*)feedData
{
    
    
    
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    
    _webView.delegate=self;
    
    
    _webView.scrollView.scrollEnabled=NO;

    _feedData=feedData;

    
 
    
}




@end
