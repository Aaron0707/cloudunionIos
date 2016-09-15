//
//  ShoppingCartItem.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/26.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "ShoppingCartItem.h"
#import "CartItemAndBillItem.h"
@implementation ShoppingCartItem


- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
//    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    NSMutableArray * temp = [NSMutableArray array];
    NSArray * items = [dic objectForKey:@"items"];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CartItemAndBillItem * ware = [CartItemAndBillItem objWithJsonDic:obj];
        [temp addObject:ware];
    }];
    _items = [temp copy];
}
@end
