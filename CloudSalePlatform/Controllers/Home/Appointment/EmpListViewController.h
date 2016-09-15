//
//  EmpListViewController.h
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-25.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"

@interface EmpListViewController : BaseTableViewController

@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, strong) NSArray *sourceRootControllers;
@property (nonatomic) NSUInteger sourceSelectIndex;
@end
