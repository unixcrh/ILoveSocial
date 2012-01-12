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
#import "NewFeedUploadPhoto.h"
#import "NewFeedListController.h"
#import "Base64Transcoder.h"
#import "NSData+NsData_Base64.m"
#import "NSString+DataURI.h"
#import "NewFeedShareAlbum+Addition.h"
@implementation NewFeedStatusCell


 - (void)awakeFromNib
{

}

- (void)dealloc {

    
    
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
    else if ([feedData class]==[NewFeedUploadPhoto class] )
    {
        return 165;
    }
    else if ([feedData class]==[NewFeedShareAlbum class] )
    {
        return 165;
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

-(void)loadPicture:(NSData*)image
{
    
    UIImage* image1=[UIImage imageWithData:image];
    CGSize size;
    
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
   // NSString *javascript1 = [NSString stringWithFormat:@"setPhotoPos(%f,%f)",image1.size.width,image1.size.height];
    
    
   // NSLog(@"%@",javascript1);
   // [_webView stringByEvaluatingJavaScriptFromString:javascript1];

    
    NSString *imgB64 = [[imagedata base64Encoding] jpgDataURIWithContent];
    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('upload').src='%@'", imgB64];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
}


-(void)loadImage:(NSData*)image
{
    
    NSString *imgB64 = [[image base64Encoding] jpgDataURIWithContent];

    
                    
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('head').src='%@'", imgB64];
       
    
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
    
    
      if ([_feedData class]==[NewFeedUploadPhoto class])
      {
          [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
          [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
       
          
          if (((NewFeedUploadPhoto*)_feedData).photo_comment!=nil)
          {
          [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setComment('%@')",((NewFeedUploadPhoto*)_feedData).photo_comment]];
          }
          else
          {
              [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setComment('%@')",@"那个人很懒，没有写介绍噢"]];
  
          }
          
           [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTitle('%@')",[((NewFeedUploadPhoto*)_feedData) getTitle]]];
          [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData get_Time]]]];
          
      }
    
    else if ([_feedData class]==[NewFeedShareAlbum class])
    {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[((NewFeedShareAlbum*)_feedData) getShareComment]]];
        
   
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData get_Time]]]];
            
           [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumTitle('相册：《%@》')",((NewFeedShareAlbum*)_feedData).album_title]];
           [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumQuantity('共%d张照片')",[(NewFeedShareAlbum*)_feedData getAlbumQuan]]];
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumAuthor('来自：%@')",((NewFeedShareAlbum*)_feedData).fromName]];
    }
      
    
    
    else{

    
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('%@')",[_feedData getFeedName]]];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",[(NewFeedData*)_feedData getName]]];
    
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTime('%@')",[CommonFunction getTimeBefore:[_feedData get_Time]]]];
     
      }
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
    
    if ([feedData class]==[NewFeedUploadPhoto class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"uploadphotocell" ofType:@"html"];
        NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        
    }
    else if ([feedData class]==[NewFeedShareAlbum class])
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharealbum" ofType:@"html"];
        NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }
    else
    {
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    }
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    

    _webView.scrollView.scrollEnabled=FALSE;
    _webView.delegate=self;

    

    
    _feedData=feedData;
    
    
  }



@end
