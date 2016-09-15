//
//  NSBaseObject.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"
#import <objc/runtime.h>

@implementation NSBaseObject

+ (id)objWithJsonDic:(NSDictionary *)dic {
    return [[[self class] alloc] initWithJsonDic:dic];
}

- (id)initWithJsonDic:(NSDictionary*)dic {
    if (self = [super init]) {
        isInitSuccuss = NO;
        [self updateWithJsonDic:dic];
        if (!isInitSuccuss) {
            return nil;
        }
    }
    return self;
}

- (void)updateWithJsonDic:(NSDictionary *)dic {
    isInitSuccuss = NO;
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
        isInitSuccuss = YES;
    }
    _badge = [dic getStringValueForKey:@"badge" defaultValue:@"0"];
    if (isInitSuccuss) {
        unsigned int propertyCount = 0;
        objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
        for (int i=0; i<propertyCount; i++) {
            objc_property_t *thisProperty = propertyList + i;
            const char* propertyName = property_getName(*thisProperty);
            NSString * key = [NSString stringWithUTF8String:propertyName];
            id value = [dic objectForKey:key];
            if (value) {
                if ([value isKindOfClass:[NSArray class]]) {
                    value = [dic getArrayForKey:key];
                } else if ([value isKindOfClass:[NSDictionary class]]) {
                    value = [dic getDictionaryForKey:key];
                } else  {
                    value = [dic getStringValueForKey:key defaultValue:@""];
                    //                value = [dic objectForKey:key];
                }
                [self setValue:value forKey:key];
            }
        }
    }
}
//- (void)setValue:(id)value forKey:(NSString *)key{
//    objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
//}
//
//- (id)valueForKey:(NSString *)key {
//    return objc_getAssociatedObject(self, key.UTF8String);
//}

@end
