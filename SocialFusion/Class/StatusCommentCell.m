//
//  StatusCommentCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "StatusCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h"
@implementation StatusCommentCell

@synthesize userName = _userName;
@synthesize status = _status;
@synthesize time = _time;


+(float)heightForCell:(StatusCommentData*)feedData
{
    NSString* tempString=[feedData getText];
    CGSize size = CGSizeMake(243, 1000);
    CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]
                              constrainedToSize:size];
    if (labelSize.height<50)
    {
        return 70;
    }
    return labelSize.height+20;
}



- (void)awakeFromNib
{

    // [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");

    [_userName release];
    [_status release];
    [_time release];
    
    
    
    
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}




-(void)configureCell:(StatusCommentData*)feedData colorStyle:(BOOL)bo
{
    
    

    
    //状态
    self.status.text=[feedData getText];
    
//    NSLog(@"%@",self.status.text);
    
    CGSize size = CGSizeMake(243, 1000);
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
    [self.userName setTitle:[feedData getOwner_Name] forState:UIControlStateNormal];
    
    
    
    [self.userName sizeToFit];
    
    
    //时间
    NSDate* FeedDate=[feedData getUpdateTime];
    

    
    //NSString* tempString=[CommonFunction getTimeBefore:FeedDate];
    

    [self.time setText:[CommonFunction getTimeBefore:FeedDate]];

 //   self.time.text=tempString ;
  //  [tempString release];
    
    
    if (bo==YES)
    {
  
     //  self.backgroundColor=[UIColor colorWithRed:254 green:248 blue:206 alpha:1];
      self.backgroundColor=[UIColor colorWithRed:10 green:248 blue:206 alpha:1];
    }
    else
    {
        self.backgroundColor=[UIColor colorWithRed:1 green:248 blue:206 alpha:1];
        //self.backgroundColor=[UIColor colorWithRed:100 green:248 blue:206 alpha:1];
     //   self.contentView.backgroundColor=[UIColor colorWithRed:254 green:248 blue:206 alpha:1];
    }
    
}






@end
