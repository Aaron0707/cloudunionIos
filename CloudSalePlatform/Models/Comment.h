//
//  Comment.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"

@interface Comment : NSBaseObject

@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * creatorId;
@property (nonatomic, strong) NSString * creatorName;
@property (nonatomic, strong) NSString * creatorAvatar;
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * referId;//父评论Id
@property (nonatomic, strong) NSString * referCreatorId;
@property (nonatomic, strong) NSString * referCreatorName;
@property (nonatomic, strong) NSString * targetId;
@property (nonatomic, strong) NSString * targetName;
@property (nonatomic, strong) NSString * targetType;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * bossReply;
@property (nonatomic, strong) NSString * inUse;

@property (nonatomic, strong) NSArray * subs;

-(BOOL)isBossReply;
@end
