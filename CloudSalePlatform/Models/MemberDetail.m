//
//  MemberDetail.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MemberDetail.h"

@implementation TimeInDetail

@end

@implementation DirectInDetail

@end

@implementation MemberDetail

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    NSMutableArray * arr = [NSMutableArray array];
    [_times enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TimeInDetail * it = [TimeInDetail objWithJsonDic:obj];
        [arr addObject:it];
    }];
    _times = arr;
    
    arr = [NSMutableArray array];
    [_directs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DirectInDetail * it = [DirectInDetail objWithJsonDic:obj];
        [arr addObject:it];
    }];
    _directs = arr;
}
@end
