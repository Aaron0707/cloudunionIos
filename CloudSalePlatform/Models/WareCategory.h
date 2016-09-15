//
//  WareCategory.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/7.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface WareCategory : NSBaseObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *system;
@property (nonatomic, strong) NSString *inUse;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *level;

@end
