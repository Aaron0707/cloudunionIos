//
//  BusinessCategory.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface BusinessCategory : NSBaseObject
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * inUse;
@property (nonatomic, strong) NSString * name;
@end
