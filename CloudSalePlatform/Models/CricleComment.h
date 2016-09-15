//
//  CricleComment.h
//  CloudSalePlatform
//
//  Created by cloud on 14-9-8.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"
@interface CricleComment : NSBaseObject

@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * blogId;
@property (nonatomic,strong) NSString * referId;
@property (nonatomic,strong) NSString * creatorId;
@property (nonatomic,strong) NSString * creatorName;
@property (nonatomic,strong) NSString * creatorPhone;
@property (nonatomic,strong) NSString * blogCreatorId;
@property (nonatomic,strong) NSString * blogCreatorName;
@property (nonatomic,strong) NSString * blogCreatorPhone;
@property (nonatomic,strong) NSString * referCreatorId;
@property (nonatomic,strong) NSString * referCreatorName;
@property (nonatomic,strong) NSString * referCreatorPhone;
@property (nonatomic,strong) NSArray * subs;
@end
