//
//  EmployeeDetailViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/31.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"
@class Employee;

@interface EmployeeDetailViewController : BaseTableViewController

//@property (nonatomic,strong) Employee *employee;
@property (nonatomic, strong) NSString *employeeId;
@end
