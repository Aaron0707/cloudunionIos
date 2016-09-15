//
//  WareInShoppingCart.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/26.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "CartItemAndBillItem.h"

@implementation CartItemAndBillItem
- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
        _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
