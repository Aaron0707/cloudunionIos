//
//  Employee.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-25.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Employee.h"

@implementation Employee

-(void)dealloc{
    self.ID = nil;
}

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
