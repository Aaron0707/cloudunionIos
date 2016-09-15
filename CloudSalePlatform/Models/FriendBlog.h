//
//  FriendBlog.h
//  CloudSalePlatform
//
//  Created by cloud on 14-9-8.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "NSBaseObject.h"
#import "CricleComment.h"

@interface FriendBlog : NSBaseObject

@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * creatorName;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSArray * imgs;
@property (nonatomic,strong) NSArray * comments;
@end
