//
//  Wares.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Ware.h"
#import "WareSku.h"

@implementation Ware
@synthesize id = _wid;

-(void)updateWithJsonDic:(NSDictionary *)dic{
    NSDictionary * item = [dic getDictionaryForKey:@"ware"];
    if (!item) {
        [super updateWithJsonDic:dic];
        __description = [dic objectForKey:@"description"];
        return;
    }
    [super updateWithJsonDic:item];
    __description = [item objectForKey:@"description"];
    
    NSMutableArray * temp = [NSMutableArray array];
    NSArray * skus = [dic objectForKey:@"skus"];
    [skus enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WareSku * sku = [WareSku objWithJsonDic:obj];
        [temp addObject:sku];
    }];
    _skus = [temp copy];
}
@end
