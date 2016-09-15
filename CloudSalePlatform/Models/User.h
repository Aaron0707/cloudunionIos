//
//  User.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface User : NSBaseObject

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * passportId;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * balanceOfUnionCurrency;
@property (nonatomic, strong) NSString * birthDay;
@property (nonatomic, strong) NSString * birthMonth;
@property (nonatomic, strong) NSString * birthType;
@property (nonatomic, strong) NSString * birthYear;
@property (nonatomic, strong) NSString * cardNumber;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createYmd;
@property (nonatomic, strong) NSString * creatorId;
@property (nonatomic, strong) NSString * creatorName;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * levelId;
@property (nonatomic, strong) NSString * levelName;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * ownerName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nickName;
//@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * topOrgId;
@property (nonatomic, strong) NSString * topOrgName;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updatorId;
@property (nonatomic, strong) NSString * updatorName;
@property (nonatomic, strong) NSString * signature;


@property (nonatomic, strong) NSString * unionCardId;//联系人的后期加入。
//@property (nonatomic, strong) NSString * imUserApplicationName;
@property (nonatomic, strong) NSString * imUsername;
@property (nonatomic, strong) NSString * currentShopId;
@property (nonatomic, strong) NSString * currentUserType;

@property (nonatomic, strong) NSArray *qhtMembers;
@property (nonatomic, strong) NSArray *recommendMembers;

@property (nonatomic, strong) NSArray *certifications;


// user config
- (void)saveConfigWhithKey:(NSString*)key value:(id)value;
- (NSString*)readConfigWithKey:(NSString*)key;
- (id)readValueWithKey:(NSString*)key;

- (void)setShowNearShop:(BOOL)isShow;
- (BOOL)isShowNearShop;
@end
