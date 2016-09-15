//
//  MessageDetailViewController.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-27.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseViewController.h"
@class MessageOfPush;
@interface MessageDetailViewController : BaseViewController

//@property (nonatomic, assign) NSString * mid;
@property (nonatomic, strong) MessageOfPush *message;
@end
