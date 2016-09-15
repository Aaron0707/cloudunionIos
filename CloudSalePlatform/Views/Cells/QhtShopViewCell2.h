//
//  QhtShopViewCell2.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/28.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewCell.h"
@class QhtShop;
@interface QhtShopViewCell2 : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myLine;


-(void)setItem:(QhtShop *)shop;
-(void)setImageViewForCoume:(NSInteger)row mark:(BOOL)mark;
@end
