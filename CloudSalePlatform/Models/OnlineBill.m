//
//  OnlineConsume.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/8.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "OnlineBill.h"
#import "CartItemAndBillItem.h"

@implementation OnlineBill


- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
     _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    
    NSMutableArray * temp  = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CartItemAndBillItem * item = [CartItemAndBillItem objWithJsonDic:obj];
        [temp addObject:item];
    }];
    
    _items = [temp copy];
}
@end
