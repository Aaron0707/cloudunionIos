//
//  ChatListViewController.h
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ChatListViewController : BaseTableViewController

//@property (nonatomic, strong)  NSMutableDictionary *allContact;
@property (nonatomic, strong) NSArray *sourceRootControllers;
@property (nonatomic) NSUInteger sourceSelectIndex;
@end
