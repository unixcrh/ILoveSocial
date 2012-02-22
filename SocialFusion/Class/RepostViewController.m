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
@implementation RepostViewController
@synthesize feedData=_feedData;



-(void)viewDidLoad
{
    [super viewDidLoad];
    if (_style==kRenrenStatus)
    {
         if (((NewFeedData*)_feedData).repost_ID!=nil)
         {
        self.textView.text=[NSString stringWithFormat:@"//%@:%@",      ((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message];
         }
        else
        {
         //   self.textView.text=[NSString stringWithFormat:@"//%@:",      ((NewFeedData*)_feedData).author.name  ];

        }
             self.textView.selectedRange=NSMakeRange(0, 0);
    }
}


#pragma mark -
#pragma mark IBAction

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;



  

    if (_style==kRenrenStatus)
    {
        
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
        
        
        {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if(client.hasError)
             //   _postStatusErrorCode |= PostStatusErrorRenren;
            [self postStatusCompletion];
        }];
        _postCount++;
        
        if (((NewFeedData*)_feedData).repost_ID!=nil)
        {
            [client postStatus:[NSString stringWithFormat:@"%@ 来自人人:%@:%@",self.textView.text,((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status]];
        }
        else
        {
           // [client forwardStatus:((NewFeedData*)_feedData).author.userID statusID:((NewFeedData*)_feedData).source_ID andStatusString:self.textView.text];
            
        }
        }
        
    }
    [self dismissView];
}




-(void)setStyle:(kShareStyle)style
{
    _style=style;
}

@end
