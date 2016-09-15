//
//  CityStreamControlViewController.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/30.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol CityStreamDelegate <NSObject>

-(void)cityStreamControlDidFinish:(NSString *)fullName districtCode:(NSString *)code;

@end

@interface CityStreamControlViewController : BaseTableViewController

@property (nonatomic, weak) id<CityStreamDelegate> delegate;
@end
