//
//  UserType.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "NSBaseObject.h"

@interface UserType : NSBaseObject

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * typeDisplay;
@property (nonatomic, strong) NSString * typeDesc;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * orgName;
@end
