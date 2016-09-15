//
//  RedEnvelopeViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/8.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseViewController.h"

@interface RedEnvelopeViewController : BaseViewController

@property (nonatomic) BOOL readingRedEnvelope;
@property (nonatomic) int  times;
@property (nonatomic,strong) NSString * shopId;

@property (nonatomic, strong) NSArray *gifts;
@end
