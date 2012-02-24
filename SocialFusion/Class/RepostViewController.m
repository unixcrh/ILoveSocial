//
//  RepostViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-22.
//  Copyright (c) 2012年 TJU. All rights reserved.
//

#import "RepostViewController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NewFeedData.h"
#import "User.h"
#import "WeiboClient.h"
#import "UIButton+Addition.h"
#import "Image+Addition.h"
#import "NewFeedBlog.h"
@implementation RepostViewController
@synthesize feedData=_feedData;
@synthesize blogData=_blogData;


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _repostToRenren=NO;
    _repostToWeibo=NO;
    
    if (_style==kRenrenStatus)
    {
        [self didClickPostToRenrenButton];
        if (((NewFeedData*)_feedData).repost_ID!=nil)
        {
            self.textView.text=[NSString stringWithFormat:@"//%@:%@", ((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message];
        }
        self.textView.selectedRange=NSMakeRange(0, 0);
        [self updateTextCount];
    }
    
    if (_style==kWeiboStatus)
    {
        [self didClickPostToWeiboButton];
        if (((NewFeedData*)_feedData).repost_ID!=nil)
        {
            self.textView.text=[NSString stringWithFormat:@"//%@:%@", ((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message];
        }
        self.textView.selectedRange=NSMakeRange(0, 0);
        [self updateTextCount];
    }
    
    if (_style==kNewBlog)
    {
        [self didClickPostToRenrenButton];
    }
    
}

-(void)forwardWeibo:(NSString*)statusID
{
    WeiboClient* client2=[WeiboClient client];
    [client2 setCompletionBlock:^(WeiboClient *client) {
        [self postStatusCompletion];
    }];
    
    [client2 repost:statusID text:self.textView.text commentStatus:YES commentOrigin:NO];
}
#pragma mark -
#pragma mark IBAction

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    if (_style==kRenrenStatus)
    {
        if (_repostToRenren==YES)
        {
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            if (((NewFeedData*)_feedData).repost_ID!=nil)
            {
                [client forwardStatus:((NewFeedData*)_feedData).repost_ID statusID:((NewFeedData*)_feedData).repost_StatusID andStatusString:self.textView.text];
            }
            else
            {
                [client forwardStatus:((NewFeedData*)_feedData).author.userID statusID:((NewFeedData*)_feedData).source_ID andStatusString:self.textView.text];
                
            }
        }
        if (_repostToWeibo==YES)
        {
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                else
                {
                    NSDictionary* dict=client.responseJSONObject;
                    NSString* statusID=[[dict objectForKey:@"id"] stringValue];
                    [self performSelector:@selector(forwardWeibo:) withObject:statusID afterDelay:1];
                    
                }
            }];
            _postCount++;
            if (((NewFeedData*)_feedData).repost_ID!=nil)
            {
                [client postStatus:[NSString stringWithFormat:@"%@:%@ [来自人人]",((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status]];
            }
            else
            {
                [client postStatus:[NSString stringWithFormat:@"%@:%@ [来自人人]",((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message]];
            }
        }
    }
    
    
    else if (_style==kWeiboStatus)
    {
        if (_repostToRenren==YES)
        {
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                else
                {
                    NSDictionary* dict=client.responseJSONObject;
                    NSLog(@"%@",dict);
                    
                    //  NSString* statusID=[[dict objectForKey:@"id"] stringValue];
                   // [self performSelector:@selector(forwardWeibo:) withObject:statusID afterDelay:1];
                    
                }

                [self postStatusCompletion];
            }];
            _postCount++;
            
            if (((NewFeedData*)_feedData).pic_URL==nil)
            {
                if (((NewFeedData*)_feedData).repost_ID!=nil)
                {
                    
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@ [来自微博]",self.textView.text,((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status]];
                }
                else
                {
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@[来自微博]",self.textView.text,((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message]];
                }
            }
            else
            {
                NSData *imageData = nil;
                Image *image = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                if (image==nil)
                {
                    imageData = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL  inManagedObjectContext:self.managedObjectContext].imageData.data;
                    
                }
                else
                {
                    imageData=image.imageData.data;
                }
                if (((NewFeedData*)_feedData).repost_ID!=nil)
                {
                    
                  
                   
                 
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@ [来自微博]",self.textView.text,((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status] withImage:[UIImage imageWithData:imageData]];
                    
                }
                else
                {
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@[来自微博]",self.textView.text,((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message] withImage:[UIImage imageWithData:imageData]];
                }

            }
        }
        
        if (_repostToWeibo==YES)
        {
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                [self postStatusCompletion];
            }];
            _postCount++;
           
            [client repost:((NewFeedData*)_feedData).source_ID text:self.textView.text commentStatus:YES commentOrigin:NO];
            
        }
    }
    
    else if (_style==kNewBlog)
    {
        if (_repostToRenren==YES)
        {
            
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            if (((NewFeedBlog*)_feedData).shareID==nil)
            {
            [client share:kNewBlog share_ID:((NewFeedBlog*)_feedData).source_ID user_ID:((NewFeedBlog*)_feedData).author.userID comment:self.textView.text];
            }
            else
            {
                [client share:kShare share_ID:((NewFeedBlog*)_feedData).shareID user_ID:((NewFeedBlog*)_feedData).sharePersonID comment:self.textView.text];
            }
        }
        if (_repostToWeibo==YES)
        {
            
            
            WebStringToImageConverter* webStringConverter=[WebStringToImageConverter webStringToImage];
            webStringConverter.delegate=self;
            [webStringConverter startConvertBlogWithTitle:((NewFeedBlog*)_feedData).title detail:_blogData];
        }
    }
    [self dismissView];
}


- (IBAction)didClickPostToRenrenButton
{
    _repostToRenren = !_repostToRenren;
    [_repostToRenrenBut setPostPlatformButtonSelected:_repostToRenren];
}
- (IBAction)didClickPostToWeiboButton
{
    _repostToWeibo = !_repostToWeibo;
    [_repostToWeiboBut setPostPlatformButtonSelected:_repostToWeibo];
}

-(void)setStyle:(kShareStyle)style
{
    _style=style;
}

- (void)webStringToImageConverter:(WebStringToImageConverter *)converter  didFinishLoadWebViewWithImage:(UIImage*)image
{
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if(client.hasError)
        {
            _postStatusErrorCode |= PostStatusErrorRenren;
        }
        [self postStatusCompletion];
    }];
    _postCount++;
    
    [client postStatus:self.textView.text withImage:image];
    

}

@end
