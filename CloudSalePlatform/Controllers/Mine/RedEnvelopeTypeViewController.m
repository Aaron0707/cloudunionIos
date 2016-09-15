//
//  RedEnvelopeTypeViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/12.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "RedEnvelopeTypeViewController.h"

@interface RedEnvelopeTypeViewController ()

@end

@implementation RedEnvelopeTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺提供的红包";
    
    [self.view setBackgroundColor:MyPinkColor];
    
    UIImageView * headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, Main_Screen_Width-20, 47)];
    
    [headerView setImage:[UIImage imageNamed:@"jaggedLine_2"]];
    [self.view addSubview:headerView];

    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, Main_Screen_Width-20, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"红包";
    [title setTextColor:MygrayColor];
    [title setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:18]];
    [self.view addSubview:title];
    
    CGFloat height = 0;
    for (int i = 0; i<_gifts.count; i++) {
        NSDictionary * dic = _gifts[i];
        NSString *content = [dic getStringValueForKey:@"content" defaultValue:@""];
        if (!content.hasValue) {
            continue;
        }
        
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] maxWidth:Main_Screen_Width-40 maxNumberLines:3];
        height +=size.height;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 57+i*40, Main_Screen_Width-20, size.height+20)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, view.width-10, 1)];
        [line setImage:[UIImage imageNamed:@"change_card_cellline"]];
        [view addSubview:line];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((Main_Screen_Width-size.width)/2, 9, size.width, size.height)];
        contentLabel.numberOfLines = 3;
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = MygrayColor;
        [view addSubview:contentLabel];
        
        contentLabel.text = content;
        
    }
    
    
    UIButton * popBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 87+height, Main_Screen_Width-40, 40)];
    
    [popBtn setTitle:@"回去抽奖了" forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [popBtn pinkBorderStyle];
    [self.view addSubview:popBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end
