//
//  NewFeedListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedListController.h"
#import <QuartzCore/QuartzCore.h>
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NewFeedRootData+NewFeedRootData_Addition.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "NewFeedUploadPhoto+Addition.h"
#import "NewFeedShareAlbum+Addition.h"
#import "NewFeedSharePhoto+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "NewFeedBlog.h"
#import "StatusDetailController.h"
#import "UIImage+Addition.h"
#import "NewFeedTempImageView.h"
#import "NewFeedUserListController.h"
#import "NewFeedDetailBlogViewCell.h"
#import "NSNotificationCenter+Addition.h"
#import "User+Addition.h"

static NSInteger SoryArrayByTime(NewFeedRootData* data1, NewFeedRootData* data2, void *context)
{
    return ([data2.update_Time compare:data1.update_Time]);
}

@implementation NewFeedListController

- (void)dealloc {
    [super dealloc];
    [_cellHeightHelper release];
    }

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self=[super initWithNibName:@"NewFeedListController" bundle:nil];
    return self;
}

+(NewFeedListController*)getNewFeedListControllerwithStyle:(kUserFeed)style
{
    NewFeedListController* userList;
    if (style==kRenrenUserFeed)
    {
        userList=[[[NewFeedUserListController alloc] init] autorelease];
        [userList setStyle:kRenrenUserFeed];
    }
    else if (style==kWeiboUserFeed)
    {
        userList=[[[NewFeedUserListController alloc] init] autorelease];
        [userList setStyle:kWeiboUserFeed];        
    }
    else if (style==kAllSelfFeed)
    {
        userList=[[[NewFeedListController alloc] init] autorelease]; 
        [userList setStyle:kAllSelfFeed];
    }
    else if (style==kRenrenSelfFeed)
    {
        userList=[[[NewFeedListController alloc] init] autorelease]; 
        [userList setStyle:kRenrenSelfFeed];
    }
    else if (style==kWeiboSelfFeed)
    {
        userList=[[[NewFeedListController alloc] init] autorelease]; 
        [userList setStyle:kWeiboSelfFeed];
    }
    return userList;
}



-(void)setStyle:(int)style
{
    _style=style;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // if(_type == RelationshipViewTypeRenrenFriends && self.renrenUser.friends.count > 0)
    //  return;
    //return;
    _pageNumber=0;
    _indexPath=nil;
    self.tableView.allowsSelection=NO;
    
    _cellHeightHelper=[[NewFeedCellHeight alloc] init];
    [_cellHeightHelper myinit:self];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"clear all cache");
    [Image clearAllCacheInContext:self.managedObjectContext];
}

-(NSPredicate *)customPresdicate {
    NSPredicate *predicate;
    if(_style == kAllSelfFeed) {
        NSLog(@"renren name:%@ and weibo name:%@", self.processRenrenUser.name, self.processWeiboUser.name);
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@||SELF IN %@", self.processRenrenUser.newFeed, self.processWeiboUser.newFeed];
        
        NSLog(@"%@",self.processRenrenUser.newFeed);
    }
    else if(_style == kRenrenSelfFeed) {
        NSLog(@"renren name:%@", self.processRenrenUser.name);
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processRenrenUser.newFeed];
    }
    else if(_style == kWeiboSelfFeed) {
        NSLog(@"renren name:%@", self.processWeiboUser.name);
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processWeiboUser.newFeed];
    }
    return predicate;
}

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedRootData" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSSortDescriptor *sort;
    NSSortDescriptor *sort2;
    predicate = [self customPresdicate];
    //  sort = [[NSSortDescriptor alloc] initWithKey:@"1" ascending:YES];
    sort = [[NSSortDescriptor alloc] initWithKey:@"update_Time" ascending:NO];
    sort2 = [[NSSortDescriptor alloc] initWithKey:@"get_Time" ascending:YES];
    
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sort2, sort, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    //   [request setSortDescriptors:nil];
    [request setPredicate:predicate];
    // NSArray *descriptors = [NSArray arrayWithObject:sort]; 
    // [request setSortDescriptors:descriptors]; 
    [sort release];
    [sort2 release];
    [sortDescriptors release];
    request.fetchBatchSize = 5;
}

#pragma mark - EGORefresh Method
- (void)refresh {
        [self hideLoadMoreDataButton];
    _pageNumber=0;
    //  [self hideLoadMoreDataButton];
    if (_currentTime!=nil)
    {
        [_currentTime release];
    }
    [self clearData];
    [self loadMoreData];
}

- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            
            
            NSArray *array = client.responseJSONObject;
            [self processWeiboData:array];
            
            
        }
    }];
    
    [client getFriendsTimelineSinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
    
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

- (WeiboUser *)processWeiboUser {
    return self.currentWeiboUser;
}

- (RenrenUser *)processRenrenUser {
    return self.currentRenrenUser;
}

- (void)addNewWeiboData:(NewFeedRootData *)data {
    [self.processWeiboUser addNewFeedObject:data];
}

- (void)addNewRenrenData:(NewFeedRootData *)data {
    [self.processRenrenUser addNewFeedObject:data];
}

-(void)processWeiboData:(NSArray*)array
{
    for(NSDictionary *dict in array) {
        int scrollHeight =[_cellHeightHelper getHeight:dict style:1];
        
        NewFeedData* data = [NewFeedData insertNewFeed:1 height:scrollHeight getDate:_currentTime Owner:self.processWeiboUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
        
        [self addNewWeiboData:data];
        
    }
    
     
    [self showLoadMoreDataButton];
    [self doneLoadingTableViewData];
    
    _loading = NO;
}


-(void)processRenrenData:(NSArray*)array
{
    for(NSDictionary *dict in array) {
        
        
      //  NSLog(@"%@",dict);
        int scrollHeight =[_cellHeightHelper getHeight:dict style:0];
        NewFeedRootData *data;
        
        if (([[dict objectForKey:@"feed_type"] intValue]==20)||([[dict objectForKey:@"feed_type"] intValue]==21))
        {
          //  NSLog(@"%@",dict);
            data = [NewFeedBlog insertNewFeed:0  height:scrollHeight  getDate:_currentTime  Owner:self.processRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
        }
        else if ([[dict objectForKey:@"feed_type"] intValue]==30)
        {
            data = [NewFeedUploadPhoto insertNewFeed:0   getDate:_currentTime  Owner:self.processRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
            
        }
        else if ([[dict objectForKey:@"feed_type"] intValue]==33)
        {
            data = [NewFeedShareAlbum insertNewFeed:0  height:scrollHeight getDate:_currentTime  Owner:self.processRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
            
        }
        else if ([[dict objectForKey:@"feed_type"] intValue]==32)
        {
            
            //   NSLog(@"%@",dict);
            data = [NewFeedSharePhoto insertNewFeed:0    height:scrollHeight  getDate:_currentTime  Owner:self.processRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
        }
        else
        {
            data = [NewFeedData insertNewFeed:0  height:scrollHeight getDate:_currentTime  Owner:self.processRenrenUser  Dic:dict inManagedObjectContext:self.managedObjectContext];
        }
        [self addNewRenrenData:data];
    }
    [self showLoadMoreDataButton];
    [self doneLoadingTableViewData];
   // [self loadExtraDataForOnscreenRows];
    _loading = NO;
}


- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];
    
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!client.hasError) {
            //NSLog(@"dict:%@", client.responseJSONObject);
            
            NSArray *array = client.responseJSONObject;
            [self processRenrenData:array];
                
        }
    }];
    
    [renren getNewFeed:_pageNumber];
    
    
}

- (void)loadMoreData {
    if(_loading)
        return;
    
    _loading = YES;
    _pageNumber++;
    _currentTime=[[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    if (_style==kAllSelfFeed)
    {
        [self loadMoreRenrenData];
        [self loadMoreWeiboData];
    }
    else if (_style==kRenrenSelfFeed)
    {
        [self loadMoreRenrenData];
    }
    
    else if (_style==kWeiboSelfFeed)
    {
        [self loadMoreWeiboData];
    }
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    if (_indexPath==nil)
    {
        return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else
    {
        if ([indexPath compare:_indexPath])
            
        {
            return [NewFeedStatusCell heightForCell:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        }
        else
        {
            return 389;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}




-(void)showImage:(NSString*)smallURL bigURL:(NSString*)stringURL {
    Image* imageData = [Image imageWithURL:smallURL inManagedObjectContext:self.managedObjectContext];
    UIImage *image = [UIImage imageWithData:imageData.imageData.data];
    NewFeedTempImageView* tempImage = [NewFeedTempImageView tempImageViewWithImage:image BigURL:stringURL context:self.managedObjectContext];
    [tempImage show];
}


-(void)showImage:(NSString*)smallURL userID:(NSString*)userID photoID:(NSString*)photoID {
    Image* imageData = [Image imageWithURL:smallURL inManagedObjectContext:self.managedObjectContext];
    UIImage *image = [UIImage imageWithData:imageData.imageData.data];
    NewFeedTempImageView* tempImage = [NewFeedTempImageView tempImageViewWithImage:image userID:userID photoID:photoID context:self.managedObjectContext];
    [tempImage show];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *StatusCell = @"NewFeedStatusCell";
    


    if ([indexPath compare:_indexPath])
    {
        NewFeedStatusCell* cell;
        
        //  if ([self.fetchedResultsController objectAtIndexPath:indexPath])
        NewFeedRootData *data= [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        cell = (NewFeedStatusCell *)[tableView dequeueReusableCellWithIdentifier:StatusCell];
        if (cell == nil) {
            cell=[[NewFeedStatusCell alloc] init];
        }
        
        
        
        
        [cell configureCell:data];
        
        [cell setList:self];
        
        
   
        NSData *imageData = nil;
        if([Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext]) {
            imageData = [Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext].imageData.data;
        }
        if(imageData == nil) {
            if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                if(indexPath.row < 5) {
                    [cell.photoView loadImageFromURL:data.owner_Head completion:^{
                        [cell.photoView fadeIn];
                    } cacheInContext:self.managedObjectContext];
                }
            }
        }
        else {
            cell.photoView.image = [UIImage imageWithData:imageData];
        }
        
        
       
        

       
        
    
        
        
        
        return cell;
    }
    else//展开时的cell
    {

        NewFeedRootData* a= [self.fetchedResultsController objectAtIndexPath:indexPath];
        
      
            if ([a class]==[NewFeedBlog class])
            {
                NewFeedDetailBlogViewCell* cell;
                [[NSBundle mainBundle] loadNibNamed:@"NewFeedDetailBlogViewCell" owner:self options:nil];
                cell = _newFeedDetailBlogViewCel;
                
                [cell initWithFeedData:a context:self.managedObjectContext renren:self.currentRenrenUser weibo:self.currentWeiboUser];
                
                
                return cell; 
            }
            
        else if ([a class]==[NewFeedShareAlbum class])
        {
            NewFeedAlbumCell* cell;
            [[NSBundle mainBundle] loadNibNamed:@"NewFeedAlbumCell" owner:self options:nil];
            cell = _newFeedAlbumCel;
            
            [cell initWithFeedData:a context:self.managedObjectContext renren:self.currentRenrenUser weibo:self.currentWeiboUser];
            
            
            return cell;
        }
        else
        {
    
                NewFeedDetailViewCell* cell;
            [[NSBundle mainBundle] loadNibNamed:@"NewFeedDetailViewCell" owner:self options:nil];
            cell = _newFeedDetailViewCel;
            
            [cell initWithFeedData:a context:self.managedObjectContext renren:self.currentRenrenUser weibo:self.currentWeiboUser];
            
        
        return cell;
        }
    }
    
    
    
}







- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloading)
        return;
    
    
    
    
    
    NewFeedRootData *data = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:data.owner_Head inManagedObjectContext:self.managedObjectContext];
    if (!image)
    {
        NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [statusCell.photoView loadImageFromURL:data.owner_Head completion:^{
            [statusCell.photoView fadeIn];
        } cacheInContext:self.managedObjectContext];
        
    }


    
    
    

    if ([data class]==[NewFeedUploadPhoto class])
    {
        NewFeedUploadPhoto* data2=(NewFeedUploadPhoto*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
    if ([data class]==[NewFeedShareAlbum class])
    {
        NewFeedShareAlbum* data2=(NewFeedShareAlbum*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
    if ([data class]==[NewFeedSharePhoto class])
    {
        NewFeedSharePhoto* data2=(NewFeedSharePhoto*)data;
        image = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
        if (!image)
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIImage loadImageFromURL:data2.photo_url completion:^{
                Image *image1 = [Image imageWithURL:data2.photo_url inManagedObjectContext:self.managedObjectContext];
                
                [statusCell loadPicture:image1.imageData.data];
                
            } cacheInContext:self.managedObjectContext];
        }
        else
        {
            NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [statusCell loadPicture:image.imageData.data];
            
        }
        
    }
    
    if ([data class]==[NewFeedData class])
    {
        NewFeedData* data2=(NewFeedData*)data;
        if (data2.pic_URL!=nil)
        {
            image = [Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext];
            if (!image)
            {
                NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [UIImage loadImageFromURL:data2.pic_URL completion:^{
                    Image *image1 = [Image imageWithURL:data2.pic_URL inManagedObjectContext:self.managedObjectContext];
                    
                    [statusCell loadPicture:image1.imageData.data];
                    
                } cacheInContext:self.managedObjectContext];
            }
            else
            {
                NewFeedStatusCell *statusCell = (NewFeedStatusCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                [statusCell loadPicture:image.imageData.data];
                
            }
        }
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadExtraDataForOnscreenRows];
}

- (void)clearData
{
    
    _noAnimationFlag = YES;
    [self.processRenrenUser removeNewFeed:self.processRenrenUser.newFeed];
    
    [self.processWeiboUser removeNewFeed:self.processWeiboUser.newFeed];
    
}

-(void)exposeCell:(NSIndexPath*)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].selected=false;
    self.tableView.allowsSelection=false;
    _indexPath=[indexPath retain];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled=FALSE;
}

-(void)showImage:(NSIndexPath*)indexPath
{
    NewFeedRootData* _feedData=[self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([_feedData class] == [NewFeedUploadPhoto class]) {
        [self showImage:((NewFeedUploadPhoto*)_feedData).photo_url bigURL:((NewFeedUploadPhoto*)_feedData).photo_big_url];
    }
    else if ([_feedData class] == [NewFeedSharePhoto class]) {
        [self showImage:((NewFeedSharePhoto*)_feedData).photo_url userID:((NewFeedSharePhoto*)_feedData).fromID  photoID:((NewFeedSharePhoto*)_feedData).mediaID];
    }
    else {
        [self showImage:((NewFeedData*)_feedData).pic_URL bigURL:((NewFeedData*)_feedData).pic_big_URL];   
    }
    
}


-(void)selectUser:(NSIndexPath *)indexPath
{
    /*
    NewFeedRootData* _feedData=[self.fetchedResultsController objectAtIndexPath:indexPath];
    User *usr =[User userWithID:[_feedData getActor_ID] inManagedObjectContext:self.managedObjectContext];
    
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:self.currentUserDict];
    if([usr isMemberOfClass:[RenrenUser class]])
        [userDict setObject:usr forKey:kRenrenUser];
    else if([usr isMemberOfClass:[WeiboUser class]]) 
        [userDict setObject:usr forKey:kWeiboUser];
    [NSNotificationCenter postDidSelectFriendNotificationWithUserDict:userDict];
     */
}
-(IBAction)resetToNormalList
{
    
    self.tableView.allowsSelection=NO;
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.tableView.scrollEnabled=true;
    NSIndexPath* tempIndex=[_indexPath retain];
    [_indexPath release];
    _indexPath=nil;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempIndex] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:tempIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tempIndex release];
      [self loadExtraDataForOnscreenRows];
}

@end
