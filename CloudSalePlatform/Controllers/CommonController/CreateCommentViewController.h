//
//  CreateCommentViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 11/14/14.
//  Copyright (c) 2014 YunHaoRuanJian. All rights reserved.
//

#import "BaseViewController.h"

@protocol CreateCommentDeletage <NSObject>

-(void)createCommentSuccess:(NSDictionary *)obj;
@end

@interface CreateCommentViewController : BaseViewController

@property (nonatomic) CommentType commentType;

@property (nonatomic, strong) NSString * referId;
@property (nonatomic, strong) NSString * targetId;

@property (nonatomic) id<CreateCommentDeletage> deletage;
@end
