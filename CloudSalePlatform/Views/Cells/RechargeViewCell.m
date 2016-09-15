//
//  RechargeViewCell.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/31.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "RechargeViewCell.h"
#import "Recharge.h"
#import "Globals.h"

@interface RechargeViewCell(){

    IBOutlet UILabel *createTimeLabel;
    IBOutlet UILabel *rechargeOfMemberBonusLabel;
    IBOutlet UILabel *rechargeOfMemberCashLabel;
    IBOutlet UILabel *balanceOfMemberCashAfterLabel;
    IBOutlet UILabel *balanceOfMemberBonusAfterLabel;
    IBOutlet UILabel *creatorNameLabel;
    
}

@end

@implementation RechargeViewCell

- (void)initialiseCell {
    [super initialiseCell];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden = YES;
    self.topLine = NO;
    [self setBackgroundColor:MygreenColor];
}
-(void)setItem:(Recharge *)recharge{
   
    rechargeOfMemberBonusLabel.text = recharge.rechargeOfMemberBonus;
    rechargeOfMemberCashLabel.text = recharge.rechargeOfMemberCash;
    balanceOfMemberBonusAfterLabel.text = recharge.balanceOfMemberBonusAfter;
    balanceOfMemberCashAfterLabel.text = recharge.balanceOfMemberCashAfter;
    creatorNameLabel.text = recharge.creatorName;
    
    if (recharge.billDate && ![@"0" isEqualToString:recharge.billDate]) {
        createTimeLabel.text =[Globals convertDateFromString:recharge.billDate timeType:1];
    }else{
        createTimeLabel.text = @" ";
    }
  
    [self setImageViewForCoume];
}

-(void)setImageViewForCoume{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 132)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:backView];
    [self.contentView sendSubviewToBack:backView];
}


@end
