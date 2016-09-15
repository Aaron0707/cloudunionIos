//
//  WareSku.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/27.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "WareSku.h"

@implementation WareSku


- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
