//
//  Message.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface Message : NSBaseObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * unionCardId;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * messageType;
@property (nonatomic, strong) NSString * billId;    // 订单ID
@property (nonatomic, strong) NSString * billType;  // 订单类型
@property (nonatomic, strong) NSString * createTime;

@end
