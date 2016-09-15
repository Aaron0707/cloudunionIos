//
//  Works.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/11.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "Works.h"

@implementation Works
- (void)updateWithJsonDic:(NSDictionary *)dic {
    NSDictionary * tempdic = [dic getDictionaryForKey:@"empWork"];
    if (tempdic) {
        [super updateWithJsonDic:[dic getDictionaryForKey:@"empWork"]];
        _ID = [[dic getDictionaryForKey:@"empWork"] getStringValueForKey:@"id" defaultValue:@""];
        _emp = [dic getDictionaryForKey:@"emp"];
        _limitSettings = [dic getArrayForKey:@"limitSettings"];
    }else{
        [super updateWithJsonDic:dic];
        _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    }
}
@end
