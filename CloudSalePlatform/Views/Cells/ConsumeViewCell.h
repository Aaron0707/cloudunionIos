//
//  ConsumeViewCell.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewCell.h"
@class Consume;
@interface ConsumeViewCell : BaseTableViewCell

-(void)setItem:(Consume *)consume;
-(void)setImageViewForCoume;
@end
