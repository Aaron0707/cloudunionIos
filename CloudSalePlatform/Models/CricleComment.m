//
//  CricleComment.m
//  CloudSalePlatform
//
//  Created by cloud on 14-9-8.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CricleComment.h"

@implementation CricleComment

-(void)updateWithJsonDic:(NSDictionary *)dic{
    [super updateWithJsonDic:dic];
    NSMutableArray *comments = [NSMutableArray array];
    if ([_subs isKindOfClass:[NSArray class]]) {
        [_subs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CricleComment * item = [CricleComment objWithJsonDic:obj];
             [comments addObject:item];
        }];
    }

    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    _subs = comments;
}
@end
