//
//  UserTypeViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "UserTypeViewCell.h"
#import "UserType.h"

@interface UserTypeViewCell (){
    UILabel * typeDescLabel;
}

@end

@implementation UserTypeViewCell

- (void)initialiseCell {
    [super initialiseCell];
    typeDescLabel = [[UILabel alloc] init];
    [self.contentView addSubview:typeDescLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLine  = NO;
    self.imageView.hidden = NO;
    self.imageView.frame = CGRectMake(10, 20, 34, 34);
    self.textLabel.frame = CGRectMake(10, 60, self.width/2, 20);
    typeDescLabel.frame = CGRectMake(10, 80, self.width/2, 20);
    
    typeDescLabel.textColor = RGBCOLOR(111, 111, 111);
    typeDescLabel.backgroundColor = [UIColor clearColor];
    typeDescLabel.tag = 1;
    typeDescLabel.numberOfLines = 0;
    typeDescLabel.font = [UIFont systemFontOfSize:13];
    typeDescLabel.highlightedTextColor = [UIColor grayColor];
}
-(void)setItem:(UserType *)type{
    self.textLabel.text = type.typeDisplay;
    typeDescLabel.text = type.typeDesc;
    NSString * typestr = type.type;
    if ([typestr isEqualToString:@"QHT_ORG"]) {
        [_backGroundImage setImage:[UIImage imageNamed:@"QHT_ORG_BACK"]];
    }else if ([typestr isEqualToString:@"JXC_PRODUCT_ORG"]) {
        [_backGroundImage setImage:[UIImage imageNamed:@"JXC_PRODUCT_ORG_BACK"]];
    }else if ([typestr isEqualToString:@"JXC_ORG"]) {
        [_backGroundImage setImage:[UIImage imageNamed:@"JXC_ORG_BACK"]];
    }else{
        [_backGroundImage setImage:[UIImage imageNamed:@"UserType_Head_Back"]];
    }
}


@end
