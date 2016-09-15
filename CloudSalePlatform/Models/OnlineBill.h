//
//  OnlineConsume.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/8.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface OnlineBill : NSBaseObject
//@property (nonatomic, strong) NSString * paymentOfCard;
//@property (nonatomic, strong) NSString * billNumber;
//@property (nonatomic, strong) NSString * createTime;
//@property (nonatomic, strong) NSString * creatorId;
//@property (nonatomic, strong) NSString * paymentOfTotal;
//@property (nonatomic, strong) NSString * picture;
//@property (nonatomic, strong) NSString * orgId;
//@property (nonatomic, strong) NSString * ID;
//@property (nonatomic, strong) NSString * amount;
//@property (nonatomic, strong) NSString * unit;
//@property (nonatomic, strong) NSString * paymentOfUnionCurrency;
//@property (nonatomic, strong) NSString * price;
//@property (nonatomic, strong) NSString * unionShopName;
//@property (nonatomic, strong) NSString * unionCardId;
//@property (nonatomic, strong) NSString * nuionShopId;
//@property (nonatomic, strong) NSString * wareId;
//@property (nonatomic, strong) NSString * totalPrice;
//@property (nonatomic, strong) NSString * wareName;

@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * wareNum;
@property (nonatomic, strong) NSString * billNumber;
@property (nonatomic, strong) NSString * wareItemNum;
@property (nonatomic, strong) NSString * totalPrice;
@property (nonatomic, strong) NSString * payment;
@property (nonatomic, strong) NSString * needPayment;
@property (nonatomic, strong) NSString * receiverDistrictCode;
@property (nonatomic, strong) NSString * receiverDistrictName;
@property (nonatomic, strong) NSString * receiverAddress;
@property (nonatomic, strong) NSString * receiverName;
@property (nonatomic, strong) NSString * receiverPhone;
@property (nonatomic, strong) NSString * onlinePay;
@property (nonatomic, strong) NSString * payoff;
@property (nonatomic, strong) NSString * buyerDeleted;
@property (nonatomic, strong) NSString * salerDeleted;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSArray * items;
@end
