//
//  Employee.h
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-25.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface Employee : NSBaseObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *display;
@end
