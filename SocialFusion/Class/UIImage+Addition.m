//
//  UIImage+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIImage+Addition.h"
#import "Image+Addition.h"
@implementation UIImage (Addition)


+(void)loadImageFromURL:(NSString *)urlString 
              completion:(void (^)())completion 
          cacheInContext:(NSManagedObjectContext *)context
{
    
	
    NSURL *url = [NSURL URLWithString:urlString];    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{ 
        //NSLog(@"download image:%@", urlString);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if(!imageData) {
            NSLog(@"download image failed:%@", urlString);
            return;
        }
        //    UIImage *img = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([Image imageWithURL:urlString inManagedObjectContext:context] == nil) {
                [Image insertImage:imageData withURL:urlString inManagedObjectContext:context];
                //NSLog(@"cache image url:%@", urlString);
                //  self.image = img;
                if (completion) {
                    completion();
                }			
            }
        });
    });
    dispatch_release(downloadQueue);
}

@end
