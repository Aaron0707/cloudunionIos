//
//  CreateBillViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/29.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"
@class WareSku;



@interface PaymentViewController : BaseTableViewController

@property (nonatomic, strong) NSString * billId;
@property (nonatomic) BOOL isAppointmentPay;
@property (nonatomic, strong) NSDictionary * appointmentDic;

@end
