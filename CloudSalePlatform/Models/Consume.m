//
//  Consume.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Consume.h"

@implementation Consume
- (void) updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
