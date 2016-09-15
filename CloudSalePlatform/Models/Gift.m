//
//  Gift.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "Gift.h"

@implementation Gift
- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
