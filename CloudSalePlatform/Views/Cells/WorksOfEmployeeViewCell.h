//
//  WorksOfEmployeeViewCell.h
//  CloudSalePlatform
//
//  Created by cloud on 15/2/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ImageTouchView.h"

@interface WorksOfEmployeeViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet ImageTouchView *pictureOneView;
@property (strong, nonatomic) IBOutlet ImageTouchView *pictureTwoView;
@property (strong, nonatomic) IBOutlet UILabel *nameOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameTwoLabel;


-(void)setItem:(NSArray *)array;
@end
