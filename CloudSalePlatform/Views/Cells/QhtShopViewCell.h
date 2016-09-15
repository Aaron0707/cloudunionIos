//
//  QhtShopViewCell.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewCell.h"
@class QhtShop;
@interface QhtShopViewCell : BaseTableViewCell

-(void)setItem:(QhtShop *)shop;
-(void)setImageViewForCoume:(NSInteger)row mark:(BOOL)mark;
@end
