//
//  ManagerAddressViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/29.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol ManagerAddressDelegate<NSObject>

-(void)managerAddressCheckedAddress:(AddressItem *)address;

@end

@interface ManagerAddressViewController : BaseTableViewController

@property (nonatomic, strong) id<ManagerAddressDelegate> delegate;
@end
