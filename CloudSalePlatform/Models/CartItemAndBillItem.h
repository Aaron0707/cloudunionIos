//
//  WareInShoppingCart.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/26.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface CartItemAndBillItem : NSBaseObject
@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * cartId;
@property (nonatomic,strong) NSString * billId;
@property (nonatomic,strong) NSString * wareOrgId;
@property (nonatomic,strong) NSString * wareId;
@property (nonatomic,strong) NSString * wareName;
@property (nonatomic,strong) NSString * skuId;
@property (nonatomic,strong) NSString * skuName;
@property (nonatomic,strong) NSString * skuPrice;
@property (nonatomic,strong) NSString * num;
@property (nonatomic,strong) NSString * itemPrice;
@property (nonatomic,strong) NSString * picture;
@end
