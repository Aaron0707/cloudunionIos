//
//  Activity.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Activity.h"

@implementation Activity

-(void)dealloc{
    self.ID = nil;
}

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}
@end
