//
//  QhtShopListViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"
@class QhtShop;
@protocol QhtShopListDelegate <NSObject>

- (void)qhtShopListDidSelect:(QhtShop *)shop;
@end

@interface QhtShopListViewController : BaseTableViewController

@property (nonatomic, strong) NSArray *qhtShops;
@property (nonatomic, strong) NSArray *recommendShops;
@property (nonatomic) id<QhtShopListDelegate>  qhtShopListDelegate;
@end
