//
//  NewFeedStatusCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 TJU. All rights reserved.
//

#import "NewFeedStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h"
#import "NewFeedBlog.h"
#import "NewFeedListController.h"
#import "Base64Transcoder.h"
#import "NSData+NsData_Base64.m"
#import "NSString+DataURI.h"
@implementation NewFeedStatusCell

/*
@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;
@synthesize status = _status;
@synthesize time = _time;
@synthesize picView=_picView;
*/
 - (void)awakeFromNib
{
    /*self.defaultHeadImageView.layer.masksToBounds = YES;
    self.defaultHeadImageView.layer.cornerRadius = 5.0f;  
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0f;*/
   // [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    /*
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_status release];
    [_time release];
    */
    
    
    _webView.delegate=nil;
    
    
    [super dealloc];
}


+(float)heightForCell:(NewFeedData*)feedData
{
    
    
    if ([feedData class]==[NewFeedData class] )
    {
        if ([feedData getPostName]==nil)
        {
            NSString* tempString=[feedData getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]
                                      constrainedToSize:size];
            
            

                return labelSize.height*1.45+85;
            
        }
        else
        {
            NSString* tempString=[feedData getName];
            CGSize size = CGSizeMake(212, 1000);
            CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]
                                      constrainedToSize:size];
            
            
            NSString* tempString1=[feedData getPostMessage];
            CGSize size1 = CGSizeMake(200, 1000);
            CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]
                                        constrainedToSize:size1];
            return (labelSize.height+labelSize1.height)*1.45+85;
        }
    }
    
    else if ([feedData class]==[NewFeedBlog class] )
    {
        NSString* tempString=[feedData getName];
        CGSize size = CGSizeMake(212, 1000);
        CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]
                                  constrainedToSize:size];
        
        
        NSString* tempString1=[feedData getBlog];
        CGSize size1 = CGSizeMake(200, 1000);
        CGSize labelSize1 = [tempString1 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10]
                                    constrainedToSize:size1];
        return (labelSize.height+labelSize1.height)*1.45+85;
        
        
    }
     
    return 0;
    
    
 
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    //    _buttonViewShowed=NO;
    }
    return self;
}

-(void)loadImage:(NSData*)image
{
    
    NSString *imgB64 = [[image base64Encoding] jpgDataURIWithContent];

    
    
  //  NSString *html = [NSString stringWithFormat:@"setHeadImage('%@')",imgB64];
                      
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('head').src='%@'", imgB64];
  //  NSLog(@"%@",html);       
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    //NSLog(@"highlight:%d", highlighted);
    if(highlighted == NO && self.selected == YES)
        return;
 //   self.userName.highlighted = highlighted;
   
}   



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"selected:%d", selected);
   // self.userName.highlighted = selected;

}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
    
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData get_Time]]]];

    int scrollHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
  
    
    
    _webView.frame=CGRectMake(_webView.frame.origin.x, _webView.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
   
    
    

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString* tempString=[NSString stringWithFormat:@"%@",[request URL]];
    if ([tempString isEqualToString:@"file:///Users/RoyHe/Library/Application%20Support/iPhone%20Simulator/5.0/Applications/EBB5A096-6C24-446E-8719-D6CE74B256DE/Pocket%20Social.app/www.baidu.com"])
    {
    [self exposeCell];
        return NO;
    }
    return YES;
}
-(void)exposeCell
{
    
    NSIndexPath* indexpath=[_listController.tableView indexPathForCell:self];
//    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController exposeCell:indexpath];
}
/*
-(IBAction) cancelButton:(id)sender
{
    
    _buttonView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setType:@"kCATransitionFade"];
    //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
    [self.layer addAnimation:animation forKey:@"animationID"]; 
    
    
    [_buttonView removeFromSuperview];
    _buttonViewShowed=NO;
}
 */


-(void)setList:(NewFeedListController*)list
{
    _listController=list;
}


-(NewFeedRootData*) getFeedData
{
    return _feedData;
}


-(void)configureCell:(NewFeedData*)feedData
{
    //_webView=[[UIWebView alloc] init];
    
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    
    
    
   // [_webView removeFromSuperview];
    _webView.scrollView.scrollEnabled=FALSE;
    _webView.delegate=self;

    
   //   [[_webView nextResponder] becomeFirstResponder];
    
    
    //  NSLog(@"%@",a);
    
    //NSLog(@"%@",[NSString stringWithFormat:@"setName(abcd)",[feedData getName]]);
    //[self.contentView addSubview:_webView];
    //[super addSubview:_webView];
    
    
    _feedData=feedData;
    
    
    /*
    //  修改人人／weibo小标签
    [_picView setImage:nil];
    if ([feedData getStyle]==0)
    {
        [_styleView setImage:[UIImage imageNamed:@"Renren12.png"]];
    }
    else
    {
        [_styleView setImage:[UIImage imageNamed:@"Weibo12.png"]];
    }
    //头像
        [self.headImageView setImage:nil];
   
    
    //状态
    self.status.text=[feedData getName];
    
    CGSize size = CGSizeMake(212, 1000);
    CGSize labelSize = [self.status.text sizeWithFont:self.status.font 
                                    constrainedToSize:size];
    self.status.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y,
                                   self.status.frame.size.width, labelSize.height);
    self.status.lineBreakMode = UILineBreakModeWordWrap;
    self.status.numberOfLines = 0;
    
    
    if (self.frame.size.height<50)
    {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+20);
    }
    
    
    //名字
    [self.userName setTitle:[feedData getFeedName] forState:UIControlStateNormal];
    
   
    
      [self.userName sizeToFit];
    
    if ([feedData class]==[NewFeedData class])
    {
        if (feedData.pic_URL!=nil)
        {
            self.picView.frame=CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                          self.picView.frame.size.width,self.picView.frame.size.height); 
            
            
            //时间
            NSDate* FeedDate=[feedData getDate];
            
            //NSLog(@"%@",FeedDate);
            
            
            NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
            
            //NSLog(@"%@",tempString);
            
            
            
            self.time.frame = CGRectMake(self.status.frame.origin.x, self.picView.frame.origin.y+self.picView.frame.size.height,
                                         self.time.frame.size.width,self.time.frame.size.height); 
            self.time.text=tempString ;
            [tempString release];
            
            
            
            //回复数量
            NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
            _commentCount.text=countSting;
            [countSting release];
            [_commentCount sizeToFit];
            [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
        }
        else
        {
            //时间
            NSDate* FeedDate=[feedData getDate];
            
            //NSLog(@"%@",FeedDate);
            
            
            NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
            
            //NSLog(@"%@",tempString);
            
            
            
            self.time.frame = CGRectMake(self.status.frame.origin.x, self.status.frame.origin.y+self.status.frame.size.height,
                                         self.time.frame.size.width,self.time.frame.size.height); 
            self.time.text=tempString ;
            [tempString release];
            
            
            
            //回复数量
            NSString* countSting=[[NSString alloc] initWithFormat:@"回复:%d",[feedData getComment_Count]];
            _commentCount.text=countSting;
            [countSting release];
            [_commentCount sizeToFit];
            [_commentCount setFrame:CGRectMake(self.status.frame.origin.x+self.status.frame.size.width-_commentCount.frame.size.width, self.time.frame.origin.y, _commentCount.frame.size.width, _commentCount.frame.size.height)];
            
        }
        

    }
    */
  }


-(void)setUserHeadImage:(UIImage*)image
{
    /*
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setType:@"kCATransitionFade"];
    //    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animationID"]; 
 */
   //  [_headImageView setImage:image];
    
}
@end
