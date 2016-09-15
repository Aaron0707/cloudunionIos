//
//  UserType.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "UserType.h"
#import <objc/runtime.h>
@implementation UserType
- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int propertyCount = 0;
        objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
        for (int i=0; i<propertyCount; i++) {
            objc_property_t * thisProperty = propertyList + i;
            const char * propertyName = property_getName(*thisProperty);
            NSString * key = [NSString stringWithUTF8String:propertyName];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int propertyCount = 0;
    objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

@end
