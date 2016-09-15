//
//  RedEnvelopeViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/8.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "RedEnvelopeViewController.h"
#import "ImageTouchView.h"
#import "UIImage+FlatUI.h"
#import "Gift.h"
#import "RedEnvelopeRecordViewController.h"
#import "RedEnvelopeTypeViewController.h"

@interface RedEnvelopeViewController ()<ImageTouchViewDelegate>{
    UILabel * text3;
    Gift * gift;
    UIView * redView;
}

@end

@implementation RedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"天天领红包";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height*2/3)];
    [redView setBackgroundColor:MyPinkColor];
    [self.view addSubview:redView];
    
    [self showDefaultIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        gift = [Gift objWithJsonDic:[list objectAtIndex:0]];
        
//        [self showResultInView];
        
        UIView * view = VIEWWITHTAG(redView, 100);
        [self createAnimation:view];
        _times--;
        text3.text = @"";
        text3.text = [NSString stringWithFormat:@"你今天还有%i次机会哦！",_times];
    }
    return YES;
}


#pragma  mark - image touch delegate

-(void)imageTouchViewDidSelected:(id)sender{
    if (!_readingRedEnvelope) {
        return;
    }
    
    RedEnvelopeTypeViewController *con = [[RedEnvelopeTypeViewController alloc]init];
    con.gifts = _gifts;
    [self pushViewController:con];
}


#pragma mark animation delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self showResultInView];
}

#pragma mark Util and Private
- (void)getRedEnvelope:(UIButton *)button{
    [self showDefaultIndex];
    if ([super startRequest]) {
        [client pickRedEnvelope:_shopId];
    }
}

- (void)showDefaultIndex{
    [redView removeAllSubviews];
    
    UIImageView * jaggedLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height*2/3-20, Main_Screen_Width, 20)];
    [jaggedLine setImage:[UIImage imageNamed:@"jaggedLine_1"]];
    [redView addSubview:jaggedLine];
    
    UIView * animationView = [[UIView alloc] initWithFrame:redView.frame];
    [animationView setBackgroundColor:[UIColor clearColor]];
    animationView.tag =100;
    [redView addSubview:animationView];
    
    UIImageView * boxBack = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width-135)/2, (Main_Screen_Height*2/3-60)/2, 135, 10)];
    [boxBack setImage:[UIImage imageNamed:@"box_back"]];
    [animationView addSubview:boxBack];
    
    UIImageView * lightView = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left-66, Main_Screen_Height*1/3-140, 265, 155)];
    [lightView setImage:[UIImage imageNamed:@"light"]];
    [animationView addSubview:lightView];
    
    if (_readingRedEnvelope) {
        UIImageView * redEnvelope1 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left-4, boxBack.bottom-50, 70, 80)];
        [redEnvelope1 setImage:[UIImage imageNamed:@"red_envelope_right"]];
        [animationView addSubview:redEnvelope1];
        UIImageView * redEnvelope2 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left+70, boxBack.bottom-50, 70, 80)];
        [redEnvelope2 setImage:[UIImage imageNamed:@"red_envelope_left"]];
        
        [animationView addSubview:redEnvelope2];
        
        
        UIImageView * coin5 = [[UIImageView alloc] initWithFrame:CGRectMake(redEnvelope2.left+10, redEnvelope2.top-30, 18, 16)];
        [coin5 setImage:[UIImage imageNamed:@"coin_2"]];
        [redView addSubview:coin5];
        
        UIImageView * redEnvelope3 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left+40, boxBack.bottom-60, 58, 70)];
        [redEnvelope3 setImage:[UIImage imageNamed:@"red_envelope_center"]];
        [animationView addSubview:redEnvelope3];
        
        UIImageView * coin1 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left-10, lightView.top+55, 6, 5)];
        [coin1 setImage:[UIImage imageNamed:@"coin_6"]];
        [redView addSubview:coin1];
        
        UIImageView * coin2 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.right-10, lightView.top+30, 6, 5)];
        [coin2 setImage:[UIImage imageNamed:@"coin_5"]];
        [redView addSubview:coin2];
        
        UIImageView * coin3 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left+60, lightView.top+20, 9, 8)];
        [coin3 setImage:[UIImage imageNamed:@"coin_4"]];
        [redView addSubview:coin3];
        
        UIImageView * coin4 = [[UIImageView alloc] initWithFrame:CGRectMake(redEnvelope3.left-5, redEnvelope3.top-25, 15, 13)];
        [coin4 setImage:[UIImage imageNamed:@"coin_3"]];
        [redView addSubview:coin4];
        
        
        UIImageView * coin6 = [[UIImageView alloc] initWithFrame:CGRectMake(boxBack.left-10, boxBack.bottom+70, 22, 13)];
        [coin6 setImage:[UIImage imageNamed:@"coin_1"]];
        [redView addSubview:coin6];
        
        
        UILabel * text1 = [[UILabel alloc] initWithFrame:CGRectMake(20, coin6.bottom+20, 280,22)];
        [text1 setTextColor:[UIColor whiteColor]];
        [text1 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:24]];
        [text1 setTextAlignment:NSTextAlignmentCenter];
        text1.text = @"店铺发红包，不捡白不捡";
        [redView addSubview:text1];
        
        UILabel * text2 = [[UILabel alloc] initWithFrame:CGRectMake(40, coin6.bottom+50, 240,22)];
        [text2 setTextColor:[UIColor yellowColor]];
        [text2 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:16]];
        [text2 setTextAlignment:NSTextAlignmentCenter];
        text2.text = @"点击箱子可查看店铺红包类型";
        [redView addSubview:text2];
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40, redView.bottom, 240,40)];
        [button setTitle:@"抢红包 得大礼" forState:UIControlStateNormal];
        [button pinkStyle];
        [button addTarget:self action:@selector(getRedEnvelope:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (!text3) {
            text3 = [[UILabel alloc] initWithFrame:CGRectMake(60, button.bottom+10, 200,22)];
        }
        [text3 setTextColor:MyPinkColor];
        [text3 setFont:[UIFont  systemFontOfSize:14]];
        [text3 setTextAlignment:NSTextAlignmentCenter];
        text3.text = [NSString stringWithFormat:@"你今天还有%i次机会哦！",_times];
        [self.view addSubview:text3];
        
        UIButton * redEnvelopeRecord = [[UIButton alloc]initWithFrame:CGRectMake(40, text3.bottom, 240,20)];
        [redEnvelopeRecord setTitle:@"我的红包记录" forState:UIControlStateNormal];
//        [redEnvelopeRecord pinkStyle];
        [redEnvelopeRecord setTitleColor:kBlueColor forState:UIControlStateNormal];
        [redEnvelopeRecord.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [redEnvelopeRecord addTarget:self action:@selector(getRedEnvelopeRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:redEnvelopeRecord];
    }else{
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40, redView.bottom+10, 240,40)];
        [button setTitle:@"抢红包" forState:UIControlStateNormal];
        [button cancelStyle];
        [button setBackgroundImage:[UIImage imageWithColor:MygrayColor cornerRadius:1] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:MygrayColor cornerRadius:1] forState:UIControlStateHighlighted];
        [self.view addSubview:button];
        
        UILabel * text1 = [[UILabel alloc] initWithFrame:CGRectMake(20, boxBack.bottom+100, 280,22)];
        [text1 setTextColor:[UIColor whiteColor]];
        [text1 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:24]];
        [text1 setTextAlignment:NSTextAlignmentCenter];
        text1.text = @"店铺正在准备红包中...";
        [redView addSubview:text1];
    }
    
    ImageTouchView * boxFront = [[ImageTouchView alloc] initWithFrame:CGRectMake(boxBack.left, boxBack.bottom, 135, 67)];
    boxFront.delegate = self;
    [boxFront setImage:[UIImage imageNamed:@"box_front"]];
    [animationView addSubview:boxFront];
}

- (void)showResultInView{
    [redView removeAllSubviews];
    
    UIImageView * jaggedLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height*2/3-20, Main_Screen_Width, 20)];
    [jaggedLine setImage:[UIImage imageNamed:@"jaggedLine_1"]];
    [redView addSubview:jaggedLine];
    
    if ([gift.win isEqualToString:@"1"]) {
        UIImageView * lightView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width-265)/2-10, Main_Screen_Height*1/3-90, 265, 218)];
        [lightView setImage:[UIImage imageNamed:@"redEnvelope_detial"]];
        [redView addSubview:lightView];
        
        UILabel * text1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280,22)];
        [text1 setTextColor:[UIColor whiteColor]];
        [text1 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:24]];
        [text1 setTextAlignment:NSTextAlignmentCenter];
        text1.text =gift.remark;
        [redView addSubview:text1];
        
        UILabel * text5 = [[UILabel alloc] initWithFrame:CGRectMake(100, lightView.top+lightView.height/2-60, 120,50)];
        [text5 setTextColor:MyPinkColor];
        text5.numberOfLines = 2;
        [text5 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:16]];
        [text5 setTextAlignment:NSTextAlignmentCenter];
        text5.text =[gift.type isEqualToString:@"WARE"]?gift.targetName:gift.content;
        [redView addSubview:text5];
 
    }else{
        
        UIImageView * cryView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width-100)/2, Main_Screen_Height*1/3-80, 99, 62)];
        [cryView setImage:[UIImage imageNamed:@"crying_1"]];
        [redView addSubview:cryView];
        
        
        UILabel * text1 = [[UILabel alloc] initWithFrame:CGRectMake(20, cryView.bottom+30, 280,22)];
        [text1 setTextColor:[UIColor whiteColor]];
        [text1 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:24]];
        [text1 setTextAlignment:NSTextAlignmentCenter];
        text1.text = gift.remark;
        [redView addSubview:text1];
        
        UILabel * text2 = [[UILabel alloc] initWithFrame:CGRectMake(20, text1.bottom+10, 280,22)];
        [text2 setTextColor:[UIColor yellowColor]];
        [text2 setFont:[UIFont  fontWithName:@"Helvetica-Bold" size:18]];
        [text2 setTextAlignment:NSTextAlignmentCenter];
        text2.text = @"明天早点来抢哦！";
        [redView addSubview:text2];
    }
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(40, redView.bottom, 240,40)];
    [button setTitle:@"抢红包 得大礼" forState:UIControlStateNormal];
    [button pinkStyle];
    [button addTarget:self action:@selector(getRedEnvelope:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


-(void)createAnimation:(UIView *)view{
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = view.center;
    //设置各个关键帧位置
    
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x-20, point.y)],
                        [NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointMake(point.x+20, point.y)],
                        [NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointMake(point.x-20, point.y)],
                        [NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointMake(point.x+20, point.y)],
                        [NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointMake(point.x-20, point.y)]];

    //动画持续时间
    keyFrame.duration = 0.5;
    //恢复到最初位置
    view.layer.position = point;
    
    keyFrame.delegate = self;
    //密码输入框图层加入动画
    [view.layer addAnimation:keyFrame forKey:@"keyFrame"];

}

-(void)getRedEnvelopeRecord:(UIButton *)button{
    RedEnvelopeRecordViewController * con = [[RedEnvelopeRecordViewController alloc] init];
    [self pushViewController:con];
}

@end


