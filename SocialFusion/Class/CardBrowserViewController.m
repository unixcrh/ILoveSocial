//
//  CardBrowserViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-3-1.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "CardBrowserViewController.h"
#import "UIApplication+Addition.h"
#import <MediaPlayer/MPMusicPlayerController.h>

@interface CardBrowserViewController ()

@end

@implementation CardBrowserViewController
@synthesize webView = _webView;
@synthesize loadingIndicator = _loadingIndicator;

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView release];
    [_loadingIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MPMusicPlayerController* ipodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if ([ipodMusicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        _isIpodPlaying = YES;
    }
    else {
        _isIpodPlaying = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
    self.loadingIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)loadLink:(NSString*)link
{
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[[[NSURL alloc] initWithString:link] autorelease]];
    [_webView loadRequest:request];
	[request release];
}

- (IBAction)didClickCloseButton:(id)sender
{
    [[UIApplication sharedApplication] dismissModalViewController];
    [self.webView loadRequest:[[[NSURLRequest alloc] initWithURL:[[[NSURL alloc] initWithString:@"about:blank"] autorelease]] autorelease]];
    if (_isIpodPlaying) {
        MPMusicPlayerController* ipodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        NSLog(@"%@", [[ipodMusicPlayer nowPlayingItem] description]);
        [ipodMusicPlayer play];
    }
    [self release];
}

- (IBAction)didClickSafariButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[[self.webView request] URL]];
}

#pragma mark - 
#pragma mark UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator stopAnimating];
}

@end
