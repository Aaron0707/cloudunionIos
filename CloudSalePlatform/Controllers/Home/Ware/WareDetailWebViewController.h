//
//  WareDetailViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/10/23.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseViewController.h"
@class Ware;
@interface WareDetailWebViewController : BaseViewController

@property (strong,nonatomic) Ware *ware;
@property (strong,nonatomic) NSString *wareId;
@end
