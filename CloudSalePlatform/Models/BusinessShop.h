//
//  BusinessShop.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface BusinessShop : NSBaseObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, strong) NSString * badTimes;
@property (nonatomic, strong) NSString * goodTimes;
@property (nonatomic, strong) NSString * balanceOfUnionCurrency;
@property (nonatomic, strong) NSString * categoryId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * discount;
@property (nonatomic, strong) NSString * creatorName;
@property (nonatomic, strong) NSString * favoritedTimes;
@property (nonatomic, strong) NSString * gallery;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * reservedUnionCurrency;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * purchaseNote;
@property (nonatomic, strong) NSString * categoryName;
@property (nonatomic, strong) NSString * districtName;
@property (nonatomic, strong) NSString * isFavorited;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString *commentTimes;

@property (nonatomic, strong) NSString * businessCategoryName;

- (void)getDistance:(double)lat lng:(double)lng;
@end
