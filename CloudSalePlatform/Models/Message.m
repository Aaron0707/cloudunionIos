//
//  Message.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Message.h"
#import "Globals.h"

@implementation Message

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _createTime = [Globals sendTimeString:_createTime.doubleValue];
}
@end
