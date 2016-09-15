//
//  FriendBlog.m
//  CloudSalePlatform
//
//  Created by cloud on 14-9-8.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "FriendBlog.h"

@implementation FriendBlog

-(void)updateWithJsonDic:(NSDictionary *)dic{
    [super updateWithJsonDic:dic];
    NSMutableArray *comments = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    [_comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CricleComment * item = [CricleComment objWithJsonDic:obj];
        [comments addObject:item];
    }];
    if ([_imgs isKindOfClass:[NSArray class]]) {
        [_imgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSURL *imageUrl = [NSURL URLWithString:(NSString *)obj];
            [images addObject:imageUrl];
        }];
    }else{
        NSString * temp = (NSString *)_imgs;
        if (temp.length>0) {
            NSURL *imageUrl = [NSURL URLWithString:(NSString *)_imgs];
            [images addObject:imageUrl];
        }
    }
    _imgs = images;
    _comments = comments;
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
}

@end
