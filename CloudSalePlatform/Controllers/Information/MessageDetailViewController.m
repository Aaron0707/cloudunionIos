//
//  MessageDetailViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageOfPush.h"

@interface MessageDetailViewController () {
    UIWebView * webView;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation MessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"";
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    UIScrollView  *scroller = [webView.subviews objectAtIndex:0];
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    
    UIView *view = [[UIView alloc] initWithFrame:webView.frame];
    [view setBackgroundColor:[UIColor clearColor]];
    view.tag = 999;
    [view setAlpha:0.8];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    activityIndicator.color = BkgSkinColor;
    [view addSubview:activityIndicator];
    needToLoad = NO;
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSString * type =_message.type;
    
    if ([type isEqualToString:@"CONSUME"]) {
        self.navigationItem.title = @"消费信息";
    }else if ([type isEqualToString:@"RECHARGE"]) {
        self.navigationItem.title =@"充值信息";
    }else if ([type isEqualToString:@"WARE"]) {
        self.navigationItem.title = @"商品推荐";
    }else if ([type isEqualToString:@"ACTIVITY"]) {
        self.navigationItem.title = @"活动推荐";
    }else if ([type isEqualToString:@"GROUPSMS"]) {
        self.navigationItem.title = @"群发消息";
    }else{
        self.navigationItem.title = @"生日祝福";
    }
    
    if (self.message.contentDisplay && self.message.contentDisplay.hasValue) {
        [webView loadHTMLString:[self.message contentDisplay] baseURL:nil];
    }else{
        [webView loadHTMLString:[self.message.aps objectForKey:@"alert"] baseURL:nil];
    }
}

@end
