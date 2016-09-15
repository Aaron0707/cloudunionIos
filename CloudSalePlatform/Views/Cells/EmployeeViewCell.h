//
//  EmployeeViewCell.h
//  CloudSalePlatform
//
//  Created by cloud on 15/2/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewCell.h"
@class Employee;

@interface EmployeeViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *produceLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

-(void)setItem:(Employee *)employee;
@end
