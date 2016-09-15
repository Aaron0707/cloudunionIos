//
//  Activity.h
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface Activity : NSBaseObject

//{"id":"id","orgId":"5d2","orgName":"店铺名称","imgPath":"图片地址","title":"标题"}
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *orgId;
@property (nonatomic,strong) NSString *orgName;
@property (nonatomic,strong) NSString *imgPath;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *createTime;
@end
