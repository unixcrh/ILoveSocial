//
//  WebStringToImageConverter.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-17.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "WebStringToImageConverter.h"
#import "NSString+HTMLSet.h"
#import <QuartzCore/QuartzCore.h>
@implementation WebStringToImageConverter
@synthesize delegate=_delegate;
-(void)dealloc
{
    [super dealloc];
}
-(void)startConvertBlogWithTitle:(NSString*)title detail:(NSString*)string
{
     UIWebView* webView=[[UIWebView alloc] init];
    webView.frame=CGRectMake(0, 0, 420 , 480);
    webView.delegate=self;
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogtemplate" ofType:@"html"];
    
    NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    
    string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    infoText=[infoText setBlogTitle:title];
    infoText=[infoText setBlogDetail:string];
    [webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [infoText release];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   float width= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] floatValue];
    
    float height= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    //  float height=_webView.scrollView.contentSize.height;
    
    [webView setFrame:CGRectMake(0, 0, width, height)];
    UIGraphicsBeginImageContext(webView.frame.size); 
    
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    webView.delegate=nil;
    [webView release];

    [_delegate webStringToImageConverter:self didFinishLoadWebViewWithImage:viewImage];

    
}
@end
