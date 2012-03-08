//
//  OAuthHTTPRequest.m
//  PushboxHD
//
//  Created by Xie Hasky on 11-7-23.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "OAuthHTTPRequest.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+URLEncoding.h"
#import "Base64Transcoder.h"

@implementation OAuthHTTPRequest

@synthesize authNeeded = _authNeeded;

@synthesize extraOAuthParams = _extraOAuthParams;
@synthesize requestParams = _requestParams;
@synthesize access_token=_access_token;



- (id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    
 
    
    return self;
}




- (void)signatureBaseString
{
    /*
    NSMutableArray *parameterPairs = [NSMutableArray array];
    
    [parameterPairs addObject:[NSString stringWithFormat:@"%@=%@", 
                               [@"access_token" URLEncodedString], 
                               [_access_token URLEncodedString]]];
    
  
    
    
    [[self.requestParams allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = obj;
        [parameterPairs addObject:[NSString stringWithFormat:@"%@=%@", 
                                   [key URLEncodedString], 
                                   [[self.requestParams objectForKey:key] URLEncodedString]]];
    }];
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
    NSLog(@"normal:%@",normalizedRequestParameters);
    NSArray *parts = [[self.url absoluteString] componentsSeparatedByString:@"?"];
    NSString *urlStringWithoutQuery = [parts objectAtIndex:0];
    NSLog(@"urlStringWithoutQuery:%@",urlStringWithoutQuery);

    
    NSString *ret = [NSString stringWithFormat:@"%@&%@?%@",
					 self.requestMethod,
					 [urlStringWithoutQuery URLEncodedString],
					 [normalizedRequestParameters URLEncodedString]];
    
    
    NSLog(@"ret:%@",ret);

    [self addRequestHeader:@"Authorization" value:ret];
	*/
//	return ret;
}


- (void)dealloc
{

    [_extraOAuthParams release];
    [_requestParams release];

    [super dealloc];
}

@end
