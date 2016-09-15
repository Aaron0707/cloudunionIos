//
//  AddressItem.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/30.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface AddressItem : NSBaseObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * aliasName;
@property (nonatomic, strong) NSString * receiverDistrictCode;
@property (nonatomic, strong) NSString * receiverDistrictName;
@property (nonatomic, strong) NSString * receiverAddress;
@property (nonatomic, strong) NSString * receiverName;
@property (nonatomic, strong) NSString * receiverPhone;
@property (nonatomic, strong) NSString * receiverHandline;
@end
