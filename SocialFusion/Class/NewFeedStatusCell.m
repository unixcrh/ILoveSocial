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


- (void)dealloc {
    NSLog(@"webview release");

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

-(void)loadPicture:(NSData*)image
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


-(void)loadImage:(NSData*)image
{
    
    NSString *imgB64 = [[image base64Encoding] jpgDataURIWithContent];

    
                    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('head').src='%@'", imgB64];
       
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
}






- (void)webViewDidFinishLoad:(UIWebView *)webView{
    



    int scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
    

    
    _webView.frame=CGRectMake(0, 0,_webView.scrollView.contentSize.width, scrollHeight);
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setStyle(%d)",_style]];
  

}


-(void)showBigImage
{
    
    NSIndexPath* indexpath=[_listController.tableView indexPathForCell:self];
    //    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController showImage:indexpath];
    
    

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString* tempString=[NSString stringWithFormat:@"%@",[request URL]];
    //NSLog(@"%@",tempString);

    NSString* commandString=[tempString substringFromIndex:7];
    if ([commandString isEqualToString:@"showimage"])
    {
        [self showBigImage];
        return NO;
    }
    else if ([commandString isEqualToString:@"gotoDetail"])
    {
        [self exposeCell];
    }

    return YES;
}
-(void)exposeCell
{
    
    NSIndexPath* indexpath=[_listController.tableView indexPathForCell:self];
//    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController exposeCell:indexpath];
}

-(void)setList:(NewFeedListController*)list
{
    _listController=list;
}


-(id)init
{

    self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewFeedStatusCell"];

    _webView=[[UIWebView alloc] init];
    _webView.frame=CGRectMake(0, 0, 320, 100);
    [self.contentView addSubview:_webView];
    
    return  self;
}

-(void)configureCell:(NewFeedRootData*)feedData
{    
    [_webView removeFromSuperview];
    [_webView release];
    
    _webView=[[UIWebView alloc] init];
    _webView.frame=CGRectMake(0, 0, 320, 100);
    [self.contentView addSubview:_webView];

    if ([feedData class]==[NewFeedUploadPhoto class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"uploadphotocell" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        infoText=[infoText setName:[feedData getFeedName]];
        infoText=[infoText setWeibo:[(NewFeedUploadPhoto*)feedData getName]];
        infoText=[infoText setComment:[(NewFeedUploadPhoto*)feedData getPhoto_Comment]];
        infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
       
        infoText=[infoText setAlbum:[(NewFeedUploadPhoto*)feedData getTitle]];
        
        infoText=[infoText setCount:[feedData getCountString]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];
        
      
        
    }
    else if ([feedData class]==[NewFeedShareAlbum class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharealbum" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        
        infoText=[infoText setName:[feedData getFeedName]];
        infoText=[infoText setWeibo:[((NewFeedShareAlbum*)feedData) getShareComment]];
        infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
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
        
        infoText=[infoText setName:[feedData getFeedName]];
        infoText=[infoText setWeibo:[((NewFeedSharePhoto*)feedData) getShareComment]];
        infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
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
        
        infoText=[infoText setName:[feedData getFeedName]];
        infoText=[infoText setWeibo:[((NewFeedBlog*)feedData) getName]];
        infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
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
            
                infoText=[infoText setName:[feedData getFeedName]];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
                   infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            else
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                infoText=[infoText setName:[feedData getFeedName]];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
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
                
                infoText=[infoText setName:[feedData getFeedName]];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
                infoText=[infoText setRepost:[(NewFeedData*)feedData getPostMessage]];
                       infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            else
            {
                NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcellwithphoto" ofType:@"html"];
                NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                
                infoText=[infoText setName:[feedData getFeedName]];
                infoText=[infoText setWeibo:[(NewFeedData*)feedData getName]];
                infoText=[infoText setTime:[CommonFunction getTimeBefore:[feedData getDate]]];
                infoText=[infoText setRepost:[(NewFeedData*)feedData getPostMessage]];
       infoText=[infoText setCount:[feedData getCountString]];
                [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                [infoText release];
            }
            
            
            
        }
    }
    
    _webView.dataDetectorTypes=UIDataDetectorTypeLink;
    _webView.userInteractionEnabled=YES;
    _style=[feedData.style intValue];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    _webView.scrollView.scrollEnabled=NO;
    _webView.delegate=self;
    
   
    

    // [_feedData release];
    
    
  }







@end
