//
//  BusinessShopViewCell.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewCell.h"
@class BusinessShop;

@interface BusinessShopViewCell : BaseTableViewCell
@property (nonatomic, copy) BusinessShop * item;

@end
