//
//  CreateBillViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/6.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseViewController.h"
@class WareSku,Ware;

@interface CreateBillViewController : BaseViewController

@property (nonatomic, strong) WareSku * wareSku;
@property (nonatomic, strong) Ware * ware;
@end
