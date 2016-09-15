//
//  WareDetailViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/23.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "WareDetailWebViewController.h"
#import "Ware.h"

@interface WareDetailWebViewController (){
    
    UIWebView *webView;
    UILabel *nameLabel;
}


@end

@implementation WareDetailWebViewController
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
    self.navigationItem.title = @"商品详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    webView = [[UIWebView alloc]init];
    nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = kBlueColor;
    nameLabel.numberOfLines = 0;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:nameLabel];
    webView.frame = self.view.frame;
    [self.view addSubview:webView];
    if (_ware) {
        [webView loadHTMLString:_ware._description baseURL:nil];
        CGSize size = [_ware.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(self.view.width-10, MAXFLOAT)];
        nameLabel.text = _ware.name;
        nameLabel.frame = CGRectMake(5, 0,size.width, size.height);
        webView.top+=size.height;
        webView.height-=size.height;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear &&!_ware && [super startRequest]) {
        [client findWareWithId:_wareId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -requestFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray *list  = [obj objectForKey:@"list"];
//        if (list.count>0) {
            _ware = [Ware objWithJsonDic:[obj objectForKey:@"ware"]];
            nameLabel.text = _ware.name;
            CGSize size = [_ware.name sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(self.view.width-10, MAXFLOAT)];
            [webView loadHTMLString:_ware._description baseURL:nil];
            nameLabel.frame = CGRectMake(5, 0,size.width, size.height);
            webView.top+=size.height;
            webView.height-=size.height;
//        }
    }
    return YES;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
@end
