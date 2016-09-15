//
//  UserTypeViewCell.h
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewCell.h"

@class UserType;

@interface UserTypeViewCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *backGroundImage;

-(void)setItem:(UserType *)shop;
@end
