//
//  UserTypeViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"

@interface UserTypeViewController : BaseTableViewController

@property (nonatomic) BOOL gotoQhtShopList;
@property (nonatomic, strong) NSArray * userTypes;
@property (nonatomic, strong) NSArray * qhtMembers;
@property (nonatomic, strong) NSArray * recommendMembers;
@end
