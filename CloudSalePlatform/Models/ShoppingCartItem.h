//
//  ShoppingCartItem.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/26.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface ShoppingCartItem : NSBaseObject

@property (nonatomic,strong) NSString * wareOrgId;
@property (nonatomic,strong) NSString * wareOrgName;
@property (nonatomic,strong) NSArray * items;
@end
