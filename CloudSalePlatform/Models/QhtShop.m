//
//  QhtShop.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "QhtShop.h"
#import <objc/runtime.h>

@interface QhtShop (){
    BOOL     isOpenUnion;
}

@end

@implementation QhtShop

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
        id value = [aDecoder decodeObjectForKey:@"isOpenUnion"];
        if (value) {
            [self setValue:value forKey:@"isOpenUnion"];
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
    
    id value = [self valueForKey:@"isOpenUnion"];
    if (value) {
        [aCoder encodeObject:value forKey:@"isOpenUnion"];
    }
}
-(void)dealloc{
//    self.ID = nil;
}

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    _lastConsumeDate = [dic getDictionaryForKey:@"lastConsumeDate"];
    NSString * openStr = [dic getStringValueForKey:@"isOpenUnion" defaultValue:@"0"];
    isOpenUnion = [openStr isEqualToString:@"1"]?YES:NO;
}

- (BOOL)isOpenUnion{
    return isOpenUnion;
}
- (void)isOpenUnion:(BOOL)open{
    isOpenUnion = open;
}
@end
