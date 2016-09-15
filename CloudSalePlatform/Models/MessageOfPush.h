//
//  MessageOfPush.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/22.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface MessageOfPush : NSBaseObject
@property (nonatomic, strong) NSString * contentDisplay;
@property (nonatomic, strong) NSString * contentId;
@property (nonatomic, strong) NSString * createYmd;
@property (nonatomic, strong) NSString * creatorId;
@property (nonatomic, strong) NSString * grouPush;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * platformId;
@property (nonatomic, strong) NSString * platformName;
@property (nonatomic, strong) NSString * receiverId;
@property (nonatomic, strong) NSString * receiverPhone;
@property (nonatomic, strong) NSString * topOrgId;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSDictionary *aps;
@end
