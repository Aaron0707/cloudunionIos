//
//  EmployeeViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "EmployeeViewCell.h"
#import "Employee.h"

@implementation EmployeeViewCell

- (void)initialiseCell {
    [super initialiseCell];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLine =NO;
    self.bottomLine = YES;
    
    _phoneLabel.textColor = 
    _produceLabel.textColor = MygrayColor;
    
    self.imageView.frame = CGRectMake(10, 10, 40, 40);
    self.textLabel.frame = CGRectMake(60, 0, 100, 40);
}
-(void)setItem:(Employee *)employee{
    self.textLabel.text = employee.name;
    _phoneLabel.text = [employee.phone hasValue]?employee.phone:@"未登记电话号码";
    _produceLabel.text = [NSString stringWithFormat:@"作品0个"];
    [self setStar:3];
}



-(void)setStar:(int)score{
    int red = score;
    int gray = 5-red;
    for (double i=0; i<red; i++) {
        UIView *view = [self.contentView viewWithTag:i+200];
        if (!view) {
            view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar"]]];
            view.top = 15;
            view.size = CGSizeMake(9, 9);
            view.left = self.textLabel.left+110 + i*10;
            view.tag = i+200;
            [self.contentView addSubview:view];
        }
    }
    for (double i=0; i<gray; i++) {
        UIView *view = [self.contentView viewWithTag:i+210];
        if (!view) {
            view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar2"]]];
            view.top = 15;
            view.size = CGSizeMake(9, 9);
            view.left = self.textLabel.left+110 + (i+red)*10;
            view.tag = i+210;
            [self.contentView addSubview:view];
        }
    }
}
@end
