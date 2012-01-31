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




+(float)heightForCell:(StatusCommentData*)feedData
{
    NSString* tempString=[feedData getText];
    CGSize size = CGSizeMake(243, 1000);
    CGSize labelSize = [tempString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]
                              constrainedToSize:size];
    if (labelSize.height<20)
    {
        return 60;
    }
    return labelSize.height+40;
}



- (void)awakeFromNib
{

    // [self.commentButton setImage:[UIImage imageNamed:@"messageButton-highlight.png"] forState:UIControlStateHighlighted];
}

- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");


    
    
    
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
    _status.text=[feedData getText];
    
    
    CGSize size = CGSizeMake(243, 1000);
    CGSize labelSize = [_status.text sizeWithFont:_status.font 
                                    constrainedToSize:size];
    _status.frame = CGRectMake(_status.frame.origin.x, _status.frame.origin.y,
                                   _status.frame.size.width, labelSize.height);
    _status.lineBreakMode = UILineBreakModeWordWrap;
    _status.numberOfLines = 0;
    
    

        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height+40);
    
    //名字
    [_userName setTitle:[feedData getOwner_Name] forState:UIControlStateNormal];
    
    
    
    [_userName sizeToFit];
    
    
    //时间
    NSDate* FeedDate=[feedData getUpdateTime];
    

    

    [_time setText:[CommonFunction getTimeBefore:FeedDate]];


    
    _commentButton.center=CGPointMake(_commentButton.center.x, self.frame.size.height/2+10);
    
    if ([feedData.secret boolValue]==YES)
    {
        [_secret setImage:[UIImage imageNamed:@"detail_rev_private.png"]];
        _secret.center=CGPointMake(_commentButton.center.x-20, _commentButton.center.y-3);
    }
    else
    {
         [_secret setImage:nil];
    }
    
    if (feedData)
    if (bo==YES)
    {
       self.contentView.backgroundColor=[UIColor colorWithRed:0.99608 green:0.97255 blue:0.80784 alpha:1];

        
    }
 
    else
    {
        self.contentView.backgroundColor=[UIColor clearColor];
    }
    
}






@end
