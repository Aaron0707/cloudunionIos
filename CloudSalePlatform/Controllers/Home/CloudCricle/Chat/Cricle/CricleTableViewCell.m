//
//  CricleTableViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 14-9-8.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CricleTableViewCell.h"

@implementation CricleTableViewCell

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 34, 34);
    self.textLabel.frame = CGRectMake(20+self.imageView.width, 10, self.width - self.textLabel.left - 10, 22);
}
@end
