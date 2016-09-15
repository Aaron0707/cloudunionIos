//
//  QhtShopViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "QhtShopViewCell.h"
#import "QhtShop.h"
#import "Globals.h"
#import "NSStringAdditions.h"

@interface QhtShopViewCell (){
    
    IBOutlet UILabel *shopNameLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *lastConsumeDateLabel;
    IBOutlet UILabel *cardNumberLabel;
    IBOutlet UILabel *balanceOfPointsLabel;
    IBOutlet UILabel *balanceOfCashLabel;
    IBOutlet UILabel *levelNameLabel;
    IBOutlet UILabel *memberShopNameLabel;
    
    IBOutlet UIImageView *myline;
    
    UIView *backView;
}

@end

@implementation QhtShopViewCell

- (void)initialiseCell {
    [super initialiseCell];
    
    [myline setBackgroundColor:[UIColor clearColor]];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden = YES;
    self.topLine  = NO;
}
-(void)setItem:(QhtShop *)shop{
    shopNameLabel.text = shop.shopName;
    nameLabel.text = shop.name;
    NSDictionary *lastConsumeDate = shop.lastConsumeDate;
    if (lastConsumeDate) {
        NSString *lastDate = [NSString stringWithFormat:@"%@",[lastConsumeDate objectForKey:@"time"]];
        if (lastDate.hasValue && ![@"0" isEqualToString:lastDate]) {
            lastConsumeDateLabel.text =[NSString stringWithFormat:@"上次消费:%@",[Globals convertDateFromString:lastDate timeType:1]];
        }else{
            lastConsumeDateLabel.text = @"上次消费:";
        }
    }
    balanceOfPointsLabel.text = shop.balanceOfPoints;
    cardNumberLabel.text = shop.cardNumber;
    balanceOfCashLabel.text = shop.balanceOfCash;
    levelNameLabel.text = shop.levelName;
    memberShopNameLabel.text = shop.memberShopName;
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
