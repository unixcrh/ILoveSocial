//
//  CalculateHeight.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-6.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "CalculateHeight.h"

@implementation CalculateHeight

-(int)getHeight
{
    return _height;
}
-(id)initWithFeed:(NewFeedRootData*)feed;
{
    self=[super init];
    _webView=[[UIWebView alloc] init];
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
   
    
    
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
  //  [_webView performSelectorInBackground:@selector(loadHTMLString:baseURL:) withObject:nil];
    
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    
    _webView.delegate=self;
    

    _height=0;
    _feedData=feed;
    return self;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
    _height = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    //_height=10;
}

-(void)dealloc
{
    [_webView release];
    [super release];
}
    

@end
