//
//  WebViewByStringViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/2.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "WebViewByStringViewController.h"

@interface WebViewByStringViewController (){
    UIWebView * webView;
}

@end

@implementation WebViewByStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    
    [webView loadHTMLString:_viewString baseURL:nil];
    self.navigationItem.title = _viewTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
