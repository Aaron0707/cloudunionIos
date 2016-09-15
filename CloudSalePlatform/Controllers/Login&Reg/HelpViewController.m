//
//  HelpViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-14.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -back
-(void)popViewController{
    [self.navigationController setNavigationBarHidden:YES];
    [super popViewController];
}



@end
