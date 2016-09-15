//
//  Wares.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface Ware : NSBaseObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * unionShopId;
@property (nonatomic, strong) NSString * unit;
@property (nonatomic, strong) NSString * _description;//报错修改

@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSArray  * skus;

@end
