//
//  MemberDetail.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface TimeInDetail : NSBaseObject
@property (nonatomic, strong) NSString * poolName;
@property (nonatomic, strong) NSString * remainedTimes;
@end

@interface DirectInDetail : NSBaseObject
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * remainedAmount;
@end

@interface MemberDetail : NSBaseObject

@property (nonatomic, strong) NSString * shopName;
@property (nonatomic, strong) NSString * balanceOfCash;             // 卡金余额
@property (nonatomic, strong) NSString * balanceOfBonus;            // 赠金余额
@property (nonatomic, strong) NSString * balanceOfUnionCurrency;    // 云浩币余额
@property (nonatomic, strong) NSArray  * times;                     // 服务次数列表
@property (nonatomic, strong) NSArray  * directs;                   // 定向金列表
@property (nonatomic, strong) NSString * gallery;
@end
