//
//  QhtShop.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface QhtShop : NSBaseObject

@property (nonatomic, strong) NSString * shopId;
@property (nonatomic, strong) NSString * name;//
@property (nonatomic, strong) NSDictionary * lastConsumeDate;//最后消费时间
@property (nonatomic, strong) NSString * sex;//
@property (nonatomic, strong) NSString * mobilePhone;//手机
@property (nonatomic, strong) NSString * shopName;//店铺名称
@property (nonatomic, strong) NSString * levelName;//级别名称
@property (nonatomic, strong) NSString * cardNumber;//卡号
@property (nonatomic, strong) NSString * balanceOfPoints;//积分
@property (nonatomic, strong) NSString * balanceOfCash;//卡金
@property (nonatomic, strong) NSString * balanceOfBonus;//赠金
@property (nonatomic, strong) NSString * owedAmount;//欠款
@property (nonatomic, strong) NSString * memberShopName;//所属店铺
@property (nonatomic, strong) NSString * ID;

@property (nonatomic, strong) NSArray  * consums;
@property (nonatomic, strong) NSArray  * recharges;
@property (nonatomic,getter=isShowRecord)         BOOL      showRecord;


- (BOOL)isOpenUnion;
- (void)isOpenUnion:(BOOL)open;
@end
