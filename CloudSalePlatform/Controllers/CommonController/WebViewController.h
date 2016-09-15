//
//  WebViewController.h
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController{
     IBOutlet UIWebView *webView;
      UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSString      * url;
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) id            item;
@property (nonatomic, strong) NSString      * nid;

-(void)webViewDidStartLoad:(UIWebView *)web;
-(void)webViewDidFinishLoad:(UIWebView *)web;
@end
