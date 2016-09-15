//
//  SenchaManagerViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/26.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "SenchaManagerViewController.h"
#import "JSON.h"

@interface SenchaManagerViewController ()<UIWebViewDelegate>{
    NSString *js;
}
@end

@implementation SenchaManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarButton:@"刷新" selector:@selector(refreshView:)];
    
    NSString *token = [BSEngine currentEngine].token;
    NSArray *certifications = [BSEngine currentEngine].user.certifications;
    NSString * tempstr = [certifications JSONString];
    js = [NSString stringWithFormat:@"var script = document.createElement('script');"
          "script.type = 'text/javascript';"
          "script.text = \' window.T = {};T.getCertifications = function(){return %@;}; T.getToken = function(){return \"%@\";}\';"
          "document.getElementsByTagName('head')[0].appendChild(script);",tempstr,token];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =RGBCOLOR(127, 49, 151);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)refreshView:(UIButton *)sender{
    [webView stopLoading];
    [webView reload];
}

-(void)webViewDidStartLoad:(UIWebView *)web{
    [super webViewDidFinishLoad:web];
    NSLog(@"开始加载");
}
-(void)webViewDidFinishLoad:(UIWebView *)web{
    [super webViewDidFinishLoad:web];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"iosNotify('methodIdentifier')"];
}

@end
