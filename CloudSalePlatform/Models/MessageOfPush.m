//
//  MessageOfPush.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/22.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MessageOfPush.h"
#import "Globals.h"

@implementation MessageOfPush


- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _createTime = [Globals sendTimeString:_createTime.doubleValue];
}
@end
