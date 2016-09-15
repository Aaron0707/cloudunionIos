//
//  User.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "User.h"
#import "BSEngine.h"
#import "EmotionInputView.h"
#import <objc/runtime.h>
@interface User(){
     BOOL showNearShop;
}
@end
@implementation User

//@synthesize ID, avatar, balanceOfUnionCurrency, birthDay, birthMonth, birthType, birthYear, cardNumber, createTime, createYmd, creatorId, creatorName, gender, levelId, levelName, orgId, orgName, phoneNumber, topOrgId, topOrgName, updateTime, updatorId, updatorName,phone,nickName,name;

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
        id value = [aDecoder decodeObjectForKey:@"showNearShop"];
        if (value) {
            [self setValue:value forKey:@"showNearShop"];
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
    id value = [self valueForKey:@"showNearShop"];
    if (value) {
        [aCoder encodeObject:value forKey:@"showNearShop"];
    }
}

- (void)dealloc {
    self.ID = nil;
}

-(NSString *)ownerName{
    if (_nickName && _nickName.length>0) {
        return _nickName;
    }else if(_name &&_name.length>0){
        return _name;
    }else{
        return [self phone];
    }
}

//-(void)setOwnerName:(NSString *)ownerName{
//    
//}

-(NSString *)imUserApplicationName{
    if (self.imUsername && self.imUsername.length>0) {
        return self.imUsername;
    }
    if (self.phone && self.phone.length>0) {
        return [self.phone md5Hex];
    }
    
    return nil;
}
//-(NSString *)phone{
//    if (_phone && _phone.hasValue) {
//        return _phone;
//    }
//    return self.phoneNumber;
//}

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    _ID = [dic getStringValueForKey:@"id" defaultValue:@""];
    NSString * nickname = [dic getStringValueForKey:@"nickname" defaultValue:@""];
    if (nickname.hasValue) {
        _nickName = nickname;
    }
    NSString * phoneNumber =[dic getStringValueForKey:@"phoneNumber" defaultValue:@""];
    if ((!_phone.hasValue) && phoneNumber.hasValue) {
        _phone = phoneNumber;
    }
    showNearShop = NO;
}

- (BOOL)isShowNearShop{
    return showNearShop;
}

- (void)setShowNearShop:(BOOL)isShow{
    showNearShop = isShow;
}

#pragma mark - user Config

- (NSString*)readConfigWithKey:(NSString*)key {
    NSString * plistPath = [NSString stringWithFormat:@"%@/Library/Cache/Person/PersonConfig.cloud",NSHomeDirectory()];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *config = [dictionary objectForKey:self.ID];
    if (config && config.count > 0) {
        return [config getStringValueForKey:key defaultValue:nil];
    }
    return nil;
}

- (id)readValueWithKey:(NSString*)key {
    NSString * plistPath = [NSString stringWithFormat:@"%@/Library/Cache/Person/PersonConfig.cloud",NSHomeDirectory()];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *config = [dictionary objectForKey:self.ID];
    return [config objectForKey:key];
}

- (void)saveConfigWhithKey:(NSString*)key value:(id)value
{
    if (key && value) {
        NSString * plistPath = [NSString stringWithFormat:@"%@/Library/Cache/Person/PersonConfig.cloud",NSHomeDirectory()];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSMutableDictionary *dic = [dictionary objectForKey:self.ID];
        if (!dictionary) {
            dictionary = [NSMutableDictionary dictionary];
        }
        if (!dic) {
            dic = [NSMutableDictionary dictionary];
        }
        [dic setObject:value forKey:key];
        [dictionary setObject:dic forKey:self.ID];
        [dictionary writeToFile:plistPath atomically:YES];
    }
}

@end
