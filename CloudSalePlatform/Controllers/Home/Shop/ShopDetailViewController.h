//
//  ShopDetailViewController.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"
@class BusinessShop, ShopDetail;

@interface ShopDetailViewController : BaseTableViewController

@property (nonatomic, strong) NSString * sid;
@property (nonatomic, strong) BusinessShop * businessShop;
@end
