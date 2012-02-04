//
//  StatusDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//
#import "StatusDetailController.h"
#import "WeiboClient.h"
#import "RenrenClient.h"
#import "StatusCommentData.h"
#import "NewFeedStatusCell.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "StatusDetailController.h"
#import "StatusCommentData+StatusCommentData_Addition.h"
#import "CommonFunction.h"
#import "NSString+HTMLSet.h"
#import "RenrenUser.h"
#import "WeiboUser.h"
#import "UIImage+Addition.h"
#import "NSData+NsData_Base64.h"
#import "NSString+DataURI.h"
#import "NewFeedTempImageView.h"
@implementation StatusDetailController

@synthesize feedData=_feedData;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}


-(void)showBigImage
{
    
    //Image* imageData = [Image imageWithURL:smallURL inManagedObjectContext:self.managedObjectContext];
    //UIImage *image = [UIImage imageWithData:imageData.imageData.data];
    //NewFeedTempImageView* tempImage = [NewFeedTempImageView tempImageViewWithImage:image BigURL:stringURL context:self.managedObjectContext];
    //[tempImage show];
    
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

    return YES;
}




- (void)clearData
{
    
    _firstLoadFlag = YES;
  //  NSLog(@"%@",self.feedData.comments);
    [self.feedData removeComments:self.feedData.comments];
    
    [StatusCommentData deleteAllObjectsInManagedObjectContext:self.managedObjectContext];
 
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    UIImage* image1=[UIImage imageWithData:_photoData];
  
    
    
    NSData* imagedata=UIImageJPEGRepresentation(image1, 10);
    
    
    
    NSString *imgB64 = [[imagedata base64Encoding] jpgDataURIWithContent];
    
    

    
    
    NSString* javascript = [NSString stringWithFormat:@"document.getElementById('upload').src='%@'", imgB64];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
    

    [_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    //NSLog(@"Height:%d",height);
  //  NSLog(@"爱如完成");
    [_photoData release];
 
    [_activity stopAnimating];
    [_activity removeFromSuperview];
    [_activity release];

}
-(void)loadWebView
{
    

  if ([(NewFeedData*)_feedData getPostName]==nil)
  {
                if (((NewFeedData*)_feedData).pic_URL!=nil)
                {
                    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"photocelldetail" ofType:@"html"];
                    NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
                    infoText=[infoText setWeibo:[(NewFeedData*)_feedData getName]];
                    
                    Image* image = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                    if (!image)
                    {
                        [UIImage loadImageFromURL:((NewFeedData*)_feedData).pic_big_URL completion:^{
                            Image *image1 = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                            
                            _photoData=[[NSData alloc] initWithData: image1.imageData.data];
                            [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                            
  
                        } cacheInContext:self.managedObjectContext];
                    }
                    else
                    {
                        _photoData=[[NSData alloc] initWithData: image.imageData.data];
                        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
                        
                    }
                    
                    
                  
                  
                    [infoText release];
                }
      else
      {
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcelldetail" ofType:@"html"];
    NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    infoText=[infoText setWeibo:[(NewFeedData*)_feedData getName]];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [infoText release];
      }
  }
  else
    {
        NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcelldetail" ofType:@"html"];
        NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
        infoText=[infoText setWeibo:[(NewFeedData*)_feedData getName]];
         infoText=[infoText setRepost:[(NewFeedData*)_feedData getPostMessage]];
        [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        [infoText release];
    }
}


-(void)setFixedInfo
{
    
    for (UIView *aView in [_webView subviews])  
        
    { 
        
        if ([aView isKindOfClass:[UIScrollView class]])  
            
        { 
            
                    
            for (UIView *shadowView in aView.subviews)  
                
            { 
                
                
                
                if ([shadowView isKindOfClass:[UIImageView class]]) 
                    
                { 
                    
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                    
                } 
                
            } 
            
        } 
        
    }  
    
    
    _webView.delegate=self;
    _nameLabel.text=[_feedData getFeedName];
    NSData *imageData = nil;
    if([Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:_feedData.owner_Head inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData != nil) {
        _headImage.image = [UIImage imageWithData:imageData];
    }
    _time.text=[CommonFunction getTimeBefore:_feedData.update_Time]; 
    [(UIScrollView*)self.view setContentSize:CGSizeMake(self.view.frame.size.width*2,390)];
    ((UIScrollView*)self.view).pagingEnabled=YES;
    ((UIScrollView*)self.view).showsVerticalScrollIndicator=NO;
    ((UIScrollView*)self.view).directionalLockEnabled=YES;
    ((UIScrollView*)self.view).delegate=self;
    self.tableView.frame=CGRectMake(306, 0, 306, 350);
    [((UIScrollView*)self.view) addSubview:self.tableView];
    _pageControl.currentPage=0;
    self.tableView.allowsSelection=NO;    
    if ([_feedData.style intValue]==0)
    {
        [_style setImage:[UIImage imageNamed:@"detail_renren.png"]];
    }
    else
    {
        [_style setImage:[UIImage imageNamed:@"detail_weibo.png"]];
    }
    
    
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    _activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.center=CGPointMake(153, 300);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
}
-(void)addOriStatus
{
    [self setFixedInfo];
    [self loadWebView];


    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // _commentArray=[[NSMutableArray alloc] init];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      [self addOriStatus ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    _pageNumber=0;
   [self refresh];
}
- (void)viewDidUnload
{
 
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[_feedStatusCel removeFromSuperview];
    //[_feedStatusCel release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}


- (void)dealloc {
    [self.feedData release];
    //[_feedStatusCel release];
    [super dealloc];
}


- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
  
    predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",self.feedData.comments];
   // NSLog(@"%@",self.feedData.comments);
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:YES];
    [request setPredicate:predicate];
    NSArray *descriptors = [NSArray arrayWithObject:sort];

    [request setSortDescriptors:descriptors]; 
    [sort release];
    request.fetchBatchSize = 5;

}

#pragma mark - EGORefresh Method
- (void)refresh {
           [self hideLoadMoreDataButton];
    [self clearData];

    if ([_feedData getStyle]==0)
    {
        _pageNumber=[_feedData getComment_Count]/10+1;
    }
    else
    {
        _pageNumber=1;
    }
    
    

    
    if(_loading)
        return;
    _loading = YES;

    [self loadData];
    
    


}


- (void)loadMoreData {
    if(_loading)
        return;
    _loading = YES;
    
    
    if ([_feedData getStyle]==0)
    {
        _pageNumber--;
    }
    else
    {
        _pageNumber++;
    }
    [self loadData]    ;
}



-(void)ProcessRenrenData:(NSArray*)array
{
    for(NSDictionary *dict in array) {
        StatusCommentData* commentsData=[StatusCommentData insertNewComment:0 Dic:dict inManagedObjectContext:self.managedObjectContext];
      
    
        if ([self.currentRenrenUser.userID isEqualToString:commentsData.actor_ID] )
        {
            commentsData.actor_ID=[NSString stringWithString:@"self"];
        }
        [_feedData addCommentsObject:commentsData];
     
        
    }
    if (_pageNumber!=1)
    {
        _showMoreButton=YES;
    }
    else
    {
        _showMoreButton=NO;
    }
    
    _loading=NO;
    [self doneLoadingTableViewData];
     [self.tableView reloadData];
}

-(void)ProcessWeiboData:(NSArray*)array
{
    for(NSDictionary *dict in array) {
        
        StatusCommentData* commentsData=[StatusCommentData insertNewComment:1 Dic:dict inManagedObjectContext:self.managedObjectContext];
        
        if ([self.currentWeiboUser.userID isEqualToString:commentsData.actor_ID] )
        {
            commentsData.actor_ID=[NSString stringWithString:@"self"];
        }
        [_feedData addCommentsObject:commentsData]; 
    }
    
    
    
    if ([_feedData.comments count]<[_feedData getComment_Count])
    {
        _showMoreButton=YES;
    }
    else
    {
        _showMoreButton=NO;
    }
    _loading=NO;
    [self doneLoadingTableViewData];
    [self.tableView reloadData];

}

-(void)loadData
{
    if ([_feedData getStyle]==0)
    {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                [self ProcessRenrenData:array];
              //[self.tableView reloadData];
            }
            
            
            
        }];
    
            [renren getComments:[_feedData getActor_ID] status_ID:[_feedData getSource_ID] pageNumber:_pageNumber];

    }
    
    else
    {
        WeiboClient *weibo = [WeiboClient client];
        [weibo setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                
  
                NSArray *array = client.responseJSONObject;
                [self ProcessWeiboData:array];
                
            }

        }];

        [weibo getCommentsOfStatus:[_feedData getSource_ID] page:_pageNumber count:10];
    }
    
    
    
    
}




- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSTimeInterval i = 0;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        i += 0.05;
        [self performSelector:@selector(loadExtraDataForOnScreenRowsHelp:) withObject:indexPath afterDelay:i];
    }
}







-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        if (_showMoreButton==YES)
        {
            
            if (indexPath.row==0)
            {
                return 60;
            }
            else
            {
                NSIndexPath* index=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                
               // indexPath=[[indexPath indexPathByRemovingLastIndex] indexPathByRemovingLastIndex];
                return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:index]];
            }
        }
        else
        {
       //     indexPath=[indexPath indexPathByRemovingLastIndex];
            return [StatusCommentCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        }


    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int number=[super tableView:tableView numberOfRowsInSection:section];
    if (_showMoreButton==NO)
    {
        return number;
    }
    else
    {
        return number+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StatusComentCell = @"StatusCommentCell";
     if (_showMoreButton==NO)
     {
        StatusCommentCell* cell;
        cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
            cell = _commentCel;
        }
         
         if (indexPath.row %2 ==0)
         {
             [cell configureCell:[self.fetchedResultsController objectAtIndexPath:indexPath] colorStyle:YES];
            
         }
         else
         {
             [cell configureCell:[self.fetchedResultsController objectAtIndexPath:indexPath] colorStyle:NO];
         }
         
        return cell;
     }
    else
    {
        if (indexPath.row==0)
        {
          UITableViewCell* cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 306, 60)]; 
           [cell.contentView addSubview:self.loadMoreDataButton];
            return cell;
        }
        else
        {
            StatusCommentCell* cell;
            
            cell = (StatusCommentCell *)[tableView dequeueReusableCellWithIdentifier:StatusComentCell];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"StatusCommentCell" owner:self options:nil];
                cell = _commentCel;
            }
            
            NSIndexPath* index=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            
            if (index.row %2 ==0)
            {
            [cell configureCell:[self.fetchedResultsController objectAtIndexPath:index] colorStyle:YES];
            }
            else
            {
            [cell configureCell:[self.fetchedResultsController objectAtIndexPath:index] colorStyle:NO];
            }
            return cell;
        }
    };  
  
    
}





    @end
