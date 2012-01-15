//
//  NewFeedStatusWithRepostcell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-13.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusWithRepostcell.h"
#import "CommonFunction.h"

@implementation NewFeedStatusWithRepostcell




- (void)dealloc
{
    

    
    [super dealloc];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setStyle(%d)",[_feedData.style  intValue]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData getDate]]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepostData('%@')",[(NewFeedData*)_feedData getPostMessage]]];
    int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
    
    
    
    _webView.frame=CGRectMake(_webView.frame.origin.x, _webView.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
}


-(void)configureCell:(NewFeedData*)feedData
{

  
    if (feedData.pic_URL==nil)
    {
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }
    else
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcellwithphoto" ofType:@"html"];
        NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }
        _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    
   //  _webView.userInteractionEnabled=NO;
    _webView.delegate=self;
   
    _webView.scrollView.scrollEnabled=FALSE;
    
    _feedData=feedData;
    /*
    [super configureCell:feedData];

     [_picView setImage:nil];
    
    

    
    //NSLog(@"%@",tempString);
    
    [self.repostUserName setTitle:[feedData getPostName]  forState:UIControlStateNormal];
    
    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,self.repostAreaButton.frame.size.height); 
    
    
    
    
    self.repostStatus.text=[feedData getPostMessage];
    
    
    
   CGSize size = CGSizeMake(200, 1000);
    
    
    CGSize labelSize1 = [self.repostStatus.text sizeWithFont:self.repostStatus.font 
                                           constrainedToSize:size];
    
    self.repostStatus.frame = CGRectMake(self.repostAreaButton.frame.origin.x+5, self.repostAreaButton.frame.origin.y+5,
                                         self.repostStatus.frame.size.width, labelSize1.height);
    
    self.repostStatus.lineBreakMode = UILineBreakModeWordWrap;
    self.repostStatus.numberOfLines = 0;
    
    
    self.repostAreaButton.contentMode=UIViewContentModeScaleToFill;
    self.repostUserName.frame=  CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y-1,
                                           self.repostUserName.frame.size.width, self.repostUserName.frame.size.height);
    

    self.repostAreaButton.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height+10,
                                             self.repostAreaButton.frame.size.width,labelSize1.height+10); 
    
    
    
    self.repostAreaButtonCursor.frame = CGRectMake(self.repostAreaButton.frame.origin.x+20, self.repostAreaButton.frame.origin.y-7,
                                                   self.repostAreaButtonCursor.frame.size.width, self.repostAreaButtonCursor.frame.size.height); 
    

 //   self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+labelSize1.height+50);
    
    
    [self.repostUserName sizeToFit];

    
    
    //时间
    NSDate* FeedDate=[feedData getDate];
    
    
    NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    
    //NSLog(@"%@",tempString);
    
    
    
    
    self.time.frame = CGRectMake(self.repostStatus.frame.origin.x, self.repostStatus.frame.origin.y+self.repostStatus.frame.size.height+10,
                                 self.time.frame.size.width,self.time.frame.size.height); 
    
    self.time.text=tempString ;
    [tempString release];
    
    
    
    //回复数量
    NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
    _commentCount.text=countSting;
    [countSting release];
    [_commentCount sizeToFit];
    [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
    

    
    */
}





@end
