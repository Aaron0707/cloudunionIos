//
//  ContactDetailViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 11/28/14.
//  Copyright (c) 2014 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ContactDetailViewController : BaseTableViewController

@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) User *user;
@property (nonatomic) BOOL myFriend;
@end
