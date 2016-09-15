//
//  ActivityDetailViewController.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "Activity.h"

@interface ActivityDetailViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    Activity *activity;
}

@end

@implementation ActivityDetailViewController

-(id)init{
    self = [super init];
    if (self) {
//        webView = [[UIWebView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    webView = [[UIWebView alloc]init];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client findPromotionById:_activityId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -requestFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        if (list.count>0) {
            activity = [Activity objWithJsonDic:[list objectAtIndex:0]];
            
            [webView loadHTMLString:activity.content baseURL:nil];
            self.navigationItem.title = activity.title;
        }else{
            [self showAlert:@"未找到任何数据" isNeedCancel:YES];
        }
    }
    return YES;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
@end
