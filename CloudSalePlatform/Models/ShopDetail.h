//
//  ShopDetail.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"
#import "Ware.h"
#import "Comment.h"

@interface ShopDetail : NSBaseObject

@property (nonatomic, strong) NSArray * wares;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * _description;
@property (nonatomic, strong) NSDictionary * shop;
@property (nonatomic, strong) NSDictionary * summary;
//@property (nonatomic, strong) NSArray * comments;
@property (nonatomic, strong) NSArray * galleries;


@property (nonatomic, strong) NSString * employeeBadge;
@property (nonatomic, strong) NSString * promotionBadge;
@property (nonatomic, strong) NSString * wareBadge;
@end
