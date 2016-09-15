//
//  InformationViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-17.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "InformationViewCell.h"

@implementation InformationViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 34, 34);
    self.textLabel.frame = CGRectMake(20+self.imageView.width, 10, self.width - self.textLabel.left - 10, 22);
}
@end
