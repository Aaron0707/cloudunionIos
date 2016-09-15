//
//  WorksOfEmployeeDetailViewViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 15/2/10.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"

@interface WorksOfEmployeeDetailViewController : BaseTableViewController

@property (nonatomic ,strong) NSString * workId;

-(instancetype)initWithWorkId:(NSString *)workId;
@end
