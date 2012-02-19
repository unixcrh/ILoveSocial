//
//  NewFeedStatusCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "NewFeedUploadPhoto+Addition.h"
#import "NewFeedListController.h"
#import "Base64Transcoder.h"
#import "NSData+NsData_Base64.m"
#import "NSString+DataURI.h"
#import "NewFeedShareAlbum+Addition.h"
#import "NewFeedSharePhoto+Addition.h"
#import "NSString+HTMLSet.h"

@implementation NewFeedStatusCell
@synthesize photoView=_photoView;

- (void)dealloc {
    NSLog(@"NewFeedStatusCell release");
    
    [_time release];
    [_photoView release];
    [_defaultphotoView release];
    [_photoOut release];
    
    [_name release];
    
    [_upCutline release];
    
    
    _webView.delegate=nil;    
    [_webView release];
    [super dealloc];
}

- (void)awakeFromNib
{
    
}

+ (float)heightForCell:(NewFeedData*)feedData
{
    if ([feedData class]==[NewFeedUploadPhoto class] )
    {
        return 162;
    }
    else
    {
        return [feedData.cellheight intValue];
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

- (void)loadPicture:(NSData*)image
{
    
    UIImage* image1=[UIImage imageWithData:image];
    CGSize size;
    //改变图片大小
    float a=image1.size.width/98;
    float b=image1.size.height/73;
    if (a>b)
    {
        size=CGSizeMake(image1.size.width/image1.size.height*73, 73);
    }
    else
    {
        size=CGSizeMake(98, image1.size.height/image1.size.width*98);
    }
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //  return newImage;
    
    
    NSData* imagedata=UIImageJPEGRepresentation(newImage, 10);
    
    
    
    NSString *imgB64 = [[imagedata base64Encoding] jpgDataURIWithContent];
    
    
    NSString *javascript = [NSString stringWithFormat:@"setPhotoPos(%f,%f)", size.width,size.height];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
    
    javascript = [NSString stringWithFormat:@"document.getElementById('upload').src='%@'", imgB64];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
}


- (void)setData:(NSData*)image
{
    _photoData =[[NSData alloc] initWithData:image];
}

- (void)loadImage:(NSData*)image
{
    
    NSString *imgB64 = [[image base64Encoding] jpgDataURIWithContent];
    
    
    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('head').src='%@'", imgB64];
    
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
}






- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_photoData!=nil)
    {
        [self loadImage:_photoData];
        [_photoData release];
    }
    int scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
    _webView.frame=CGRectMake(0, 0,_webView.scrollView.contentSize.width, scrollHeight);
}


- (void)showBigImage
{
    
    NSIndexPath* indexpath=[_listController.tableView indexPathForCell:self];
    //    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController showImage:indexpath];
    
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString* tempString=[NSString stringWithFormat:@"%@",[request URL]];
    
  //  NSLog(@"%@",tempString);
    NSString* commandString=[tempString substringFromIndex:7];
    NSString* startString=[tempString substringToIndex:5];
    if ([commandString isEqualToString:@"showimage"])//点击图片
    {
        [self showBigImage];
        return NO;
    }
    else if ([commandString isEqualToString:@"gotoDetail"])//进入detail页面
    {
        [self exposeCell];
        return NO;
    }
    else if ([startString isEqualToString:@"file:"])//本地request读取
    {
        return YES;
    }
    else//其他url，调用safari
    {
    [[UIApplication sharedApplication] openURL:[request URL]];
    return NO;
    }
}
- (void)exposeCell
{
    
    NSIndexPath* indexpath=[_listController.tableView indexPathForCell:self];
    //    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController exposeCell:indexpath];
}

- (void)setList:(NewFeedListController*)list
{
    _listController=list;
}


- (id)init
{
    
    self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewFeedStatusCell"];
    
    _webView=[[UIWebView alloc] init];
    _webView.frame=CGRectMake(0, 0, 320, 100);
    [self.contentView addSubview:_webView];
    
    
    
    _time=[[UILabel alloc] init];
    _time.frame=CGRectMake(246, 11, 50, 18);
    _time.backgroundColor=[UIColor clearColor];
    _time.textAlignment=UITextAlignmentRight;
    _time.font=[UIFont fontWithName:@"Helvetica" size:9.0f];
    //_time.text=@"365天前";
    _time.textColor=[UIColor colorWithRed:0.5647f green:0.55686f blue:0.47059 alpha:1];
    
    
    
    
    
    _photoView=[[UIImageView alloc] init];
    _photoView.frame=CGRectMake(8, 12, 37, 37);
    
    
    
    _photoOut=[[UIButton alloc] init];
    _photoOut.frame=CGRectMake(4, 8, 46, 46);
    _photoOut.adjustsImageWhenHighlighted = NO;
    [_photoOut addTarget:self action:@selector(didClickPhotoOutButton) forControlEvents:UIControlEventTouchUpInside];
    
    _defaultphotoView=[[UIImageView alloc] init];
    _defaultphotoView.frame=CGRectMake(8, 12, 37, 37);
    [_defaultphotoView setImage:[UIImage imageNamed:@"default_renren_tiny.png"]];
    
    _name=[[UIButton alloc] init];
    _name.frame=CGRectMake(57, 9, 210, 18);
    [_name setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_name setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_name addTarget:self action:@selector(didClickPhotoOutButton) forControlEvents:UIControlEventTouchUpInside];
    // [_name setTitle:@"RoyHeRoyHeRoyHeRoyHeRoy" forState:UIControlStateNormal];
    
    [_name setTitleColor:[UIColor colorWithRed:0.32157f green:0.31373 blue:0.26666667 alpha:1] forState:UIControlStateNormal];
    [_name.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    
    [_photoOut setImage:[UIImage imageNamed:@"head_renren.png"] forState:UIControlStateNormal];
    
    _upCutline=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]];
    _upCutline.frame=CGRectMake(8, 3, 290, 1);
    
    
    [self.contentView addSubview:_upCutline];
    
    [self.contentView addSubview:_defaultphotoView];
    
    [self.contentView addSubview:_photoView];
    
    [self.contentView addSubview:_photoOut];
    
    [self.contentView addSubview:_name];
    
    [self.contentView addSubview:_time];
    
    
    return  self;
}



- (void)configureCell:(NewFeedRootData*)feedData
{    
    _photoData=nil;
    [_webView removeFromSuperview];
    [_webView release];
    
    _webView=[[UIWebView alloc] init];
    _webView.frame=CGRectMake(0, 0, 320, 100);
    [self.contentView addSubview:_webView];
    
    
    [self.contentView sendSubviewToBack:_webView];
    
  //  _webView.alpha=0;
    [_photoView setImage:nil];
    
    if ([feedData getStyle]==0)
    {
        [_photoOut setImage:[UIImage imageNamed:@"head_renren.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_photoOut setImage:[UIImage imageNamed:@"head_wb.png"] forState:UIControlStateNormal];
    }
    if ([feedData class]==[NewFeedUploadPhoto class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"uploadphotocell" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        
        infoText=[infoText setWeibo:[(NewFeedUploadPhoto*)feedData getName]];
        infoText=[infoText setComment:[(NewFeedUploadPhoto*)feedData getPhoto_Comment]];
        
        [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
        [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
        infoText=[infoText setAlbum:[(NewFeedUploadPhoto*)feedData getTitle]];
        
        infoText=[infoText setCount:[feedData getCountString]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];
        
        
        
    }
    else if ([feedData class]==[NewFeedShareAlbum class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharealbum" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
        [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];  
        infoText=[infoText setWeibo:[((NewFeedShareAlbum*)feedData) getShareComment]];
        infoText=[infoText setAlbum:[(NewFeedShareAlbum*)feedData getAubumName]];
        infoText=[infoText setPhotoMount:[(NewFeedShareAlbum*)feedData getAblbumQuantity]];
        infoText=[infoText setAuthor:[(NewFeedShareAlbum*)feedData getFromName]];
        infoText=[infoText setCount:[feedData getCountString]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];

    }
    
    
    else if ([feedData class]==[NewFeedSharePhoto class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharephotocell" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
        [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
        infoText=[infoText setWeibo:[((NewFeedSharePhoto*)feedData) getShareComment]];
        
        infoText=[infoText setComment:[(NewFeedSharePhoto*)feedData getPhotoComment]];
        infoText=[infoText setAlbum:[(NewFeedSharePhoto*)feedData getTitle]];
        infoText=[infoText setAuthor:[(NewFeedSharePhoto*)feedData getFromName]];
        infoText=[infoText setCount:[feedData getCountString]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];
        
    }
    
    else if ([feedData class]==[NewFeedBlog class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcell" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
        [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
        infoText=[infoText setWeibo:[((NewFeedBlog*)feedData) getName]];
        
        infoText=[infoText setRepost:[(NewFeedBlog*)feedData getBlog]];
        infoText=[infoText setCount:[feedData getCountString]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];
        
    }
    
    else
    {
        
        if ([(NewFeedData*)feedData getPostName]==nil)
        {
            if (((NewFeedData*)feedData).pic_URL!=nil)
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"photocell" ofType:@"html"];
                
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                
                [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
                NSLog(@"feed data:%@", feedData);
                NSLog(@"author data:%@", feedData.author);
                [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                
                infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            else
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                
                [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
                [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                
                infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
        }
        else
        {
            if (((NewFeedData*)feedData).pic_URL==nil)
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcell" ofType:@"html"];
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                
                [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
                [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                
                infoText=[infoText setRepost:[(NewFeedData*)feedData getPostMessage]];
                infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            else
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcellwithphoto" ofType:@"html"];
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                
                [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
                [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                
                infoText=[infoText setRepost:[(NewFeedData*)feedData getPostMessage]];
                infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            
            
            
        }
    }
    
    _webView.dataDetectorTypes=UIDataDetectorTypeLink;
    _webView.userInteractionEnabled=YES;
    
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    _webView.scrollView.scrollEnabled=NO;
    _webView.delegate=self;
    
    
    
    
    // [_feedData release];
    
    
}

#pragma mark -
#pragma mark UI actions

- (void)didClickPhotoOutButton {
    NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    [_listController selectUser:indexpath];
}

@end
