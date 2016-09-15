//
//  QhtShopViewCell2.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/28.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "QhtShopViewCell2.h"
#import "QhtShop.h"
@interface QhtShopViewCell2(){
    UIView *backView;
}
@end

@implementation QhtShopViewCell2

- (void)initialiseCell {
    [super initialiseCell];
    
    [_myLine setBackgroundColor:[UIColor clearColor]];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden = YES;
    self.topLine  = NO;
}
-(void)setItem:(QhtShop *)shop{
  
    NSString * text = [NSString stringWithFormat:@"推荐人: %@",shop.name];
    
    NSMutableAttributedString *st = [[NSMutableAttributedString alloc] initWithString:text];
    [st addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica" size:14] range:NSMakeRange(0, text.length)];
    [st addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    [st addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(3, text.length-3)];
    _memberNameLabel.attributedText = st;
    
    _shopNameLabel.text = shop.shopName;
}

-(void)setImageViewForCoume:(NSInteger)row mark:(BOOL)mark{
    int index = (row+1)%3;
    [backView removeFromSuperview];
    backView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.width-10, 125)];
    if (mark) {
        UIImage *image = [UIImage imageNamed:@"change_shop_mark"];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-45, 0, 35, 37)];
        [imageView setImage:image];
        [backView addSubview:imageView];
    }
    backView.layer.cornerRadius = 4;
    if (index==1){
        [backView setBackgroundColor:MyPinkColor];
    }else if (index==2){
        [backView setBackgroundColor:kBlueColor];
    }else{
        [backView setBackgroundColor:RGBCOLOR(127, 49, 151)];
    }
    [self.contentView addSubview:backView];
    [self.contentView sendSubviewToBack:backView];
}
@end
