//
//  AddressItem.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/30.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "AddressItem.h"

@implementation AddressItem

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
