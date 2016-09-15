//
//  SearchBeginViewController.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SearchBeginViewController : BaseTableViewController
@property (nonatomic, strong) NSString * businessCategoryId;
@property (nonatomic, strong) NSString * districtCode;
@property (nonatomic, strong) NSString * searchText;
@end
