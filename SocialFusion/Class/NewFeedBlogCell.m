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
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData get_Time]]]];
    
   
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
    
  //  _webView.userInteractionEnabled=NO;
    _feedData=feedData;

    
    
    
    /*
    
    [super configureCell:feedData];
    
 
    
    
    
    self.blog.text=[feedData getBlog];
    
    
    CGSize size1 = CGSizeMake(212, 1000);
    
    
    CGSize labelSize1 = [self.blog.text sizeWithFont:self.blog.font 
                                    constrainedToSize:size1];
    
    self.blog.frame = CGRectMake(self.blog.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                   212, labelSize1.height);
    
    self.blog.lineBreakMode = UILineBreakModeWordWrap;
    self.blog.numberOfLines = 0;
    
   
    NSDate* FeedDate=[feedData getDate];
    
    //NSLog(@"%@",FeedDate);
    
    NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    
    
    //NSLog(@"%@",tempString);
    
    self.time.frame = CGRectMake(self.status.frame.origin.x, self.blog.frame.origin.y+self.blog.frame.size.height,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    self.time.text=tempString ;
    [tempString release];
    
    NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
    _commentCount.text = countSting;
    [countSting release];
    [_commentCount sizeToFit];
    [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
    
    
*/
    
}




@end
