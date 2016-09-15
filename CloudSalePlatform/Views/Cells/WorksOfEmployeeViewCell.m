//
//  WorksOfEmployeeViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "WorksOfEmployeeViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDictionaryAdditions.h"
#import "Globals.h"

@interface WorksOfEmployeeViewCell()<ImageTouchViewDelegate>{
    UIView * backView1;
    UIView * backView2;
}
@end

@implementation WorksOfEmployeeViewCell
- (void)initialiseCell {
        [super initialiseCell];
    _pictureTwoView.tag = @"2";
    _pictureOneView.tag = @"1";
    _pictureOneView.delegate =
    _pictureTwoView.delegate = self;
    
    backView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 140, 170)];
    backView2 = [[UIView alloc] initWithFrame:CGRectMake(170, 10, 140, 170)];
    [backView1 setBackgroundColor:[UIColor whiteColor]];
    [backView2 setBackgroundColor:[UIColor whiteColor]];
    backView1.layer.borderWidth =
    backView2.layer.borderWidth = 0.5;
    backView1.layer.borderColor =
    backView2.layer.borderColor = MygrayColor.CGColor;
    
    backView2.layer.cornerRadius =
    backView1.layer.cornerRadius = 6;
    
    [self.contentView addSubview:backView2];
    [self.contentView addSubview:backView1];
    
    [self.contentView sendSubviewToBack:backView2];
    [self.contentView sendSubviewToBack:backView1];
    
    _nameOneLabel.textAlignment =
    _nameTwoLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden =YES;
    self.bottomLine =
    self.topLine =NO;
}
-(void)setItem:(NSArray *)array{
    if (array.count==0) {
        return;
    }
    
    NSDictionary * dic1 = array[0];
   
    NSString * urlStr1 = [dic1 getStringValueForKey:@"imagePath" defaultValue:@""];
    [_pictureOneView sd_setImageWithURL:[NSURL URLWithString:urlStr1] placeholderImage:[Globals getImageDefault]];
    _nameOneLabel.text = [dic1 getStringValueForKey:@"name" defaultValue:@""];
    
    if (array.count>=2) {
        NSDictionary * dic2 = array[1];
        _nameTwoLabel.text = [dic2 getStringValueForKey:@"name" defaultValue:@""];
        NSString * urlStr2 = [dic2 getStringValueForKey:@"imagePath" defaultValue:@""];
        [_pictureTwoView sd_setImageWithURL:[NSURL URLWithString:urlStr2] placeholderImage:[Globals getImageDefault]];
    }else{
        backView2.hidden =
        _nameTwoLabel.hidden =
        _pictureTwoView.hidden = YES;
    }
}



- (void)imageTouchViewDidSelected:(ImageTouchView *)sender {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:super.indexPath.row inSection:sender.tag.integerValue];
    if ([super.superTableView.delegate respondsToSelector:@selector(tableView:didTapHeaderAtIndexPath:)]) {
        [super.superTableView.delegate performSelector:@selector(tableView:didTapHeaderAtIndexPath:) withObject:super.superTableView withObject:indexPath];
    } else {
        if ([super.superTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [super.superTableView.delegate performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:super.superTableView withObject:indexPath];
        }
    }
}
@end
