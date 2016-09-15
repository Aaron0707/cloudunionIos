//
//  ShopDetail.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ShopDetail.h"

@implementation ShopDetail

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    NSMutableArray * arr = [NSMutableArray array];
//    NSMutableArray * comment = [NSMutableArray array];
    [_wares enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Ware * item = [Ware objWithJsonDic:obj];
        [arr addObject: item];
    }];
//    [_comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        Comment * item = [Comment objWithJsonDic:obj];
//        [comment addObject:item];
//    }];
//    _comments = comment;
    _wares = arr;
    
    self._description = [dic objectForKey:@"description"];
}
@end
