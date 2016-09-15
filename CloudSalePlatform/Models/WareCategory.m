//
//  WareCategory.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/7.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "WareCategory.h"

@implementation WareCategory
- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
