//
//  Comment.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (void) updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    NSMutableArray *comments = [NSMutableArray array];
    if ([_subs isKindOfClass:[NSArray class]]) {
        [_subs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Comment * item = [Comment objWithJsonDic:obj];
            [comments addObject:item];
        }];
    }
    
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    _subs = comments;
//    _bossReply = [dic getBoolValueForKey:@"bossReply" defaultValue:NO];
}

-(BOOL)isBossReply{
    if ([_bossReply isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}
@end
