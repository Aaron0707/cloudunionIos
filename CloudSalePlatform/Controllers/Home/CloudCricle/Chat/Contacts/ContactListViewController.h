//
//  ContactListViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ContactListViewController : BaseTableViewController

@property (nonatomic, strong) NSArray *sourceRootControllers;
@property (nonatomic) NSUInteger sourceSelectIndex;
@end
