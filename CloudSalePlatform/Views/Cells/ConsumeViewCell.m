//
//  ConsumeViewCell.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ConsumeViewCell.h"
#import "Consume.h"
#import "Globals.h"
@interface ConsumeViewCell (){

    IBOutlet UILabel *billNumberLabel;
    IBOutlet UILabel *summeryLabel;
    IBOutlet UILabel *creatorName;
    IBOutlet UILabel *billDate;
    IBOutlet UILabel *totalDiscount;
    IBOutlet UILabel *totalCost;
    IBOutlet UILabel *allCost;
    IBOutlet UILabel *cardNumber;
    IBOutlet UILabel *memberName;
    IBOutlet UILabel *employeeNames;
}

@end


@implementation ConsumeViewCell


- (void)initialiseCell {
    [super initialiseCell];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden = YES;
    self.topLine =NO;
    [self setBackgroundColor:MygreenColor];
}
-(void)setItem:(Consume *)consume{
    billNumberLabel.text = consume.billNumber;
    creatorName.text = consume.creatorName;
    NSString *lastDate = consume.createTime;
    if (lastDate.hasValue && ![@"0" isEqualToString:lastDate]) {
        billDate.text =[Globals convertDateFromString:lastDate timeType:1];
    }else{
        billDate.text = @" ";
    }
    totalDiscount.text = consume.totalDiscount;
    totalCost.text = consume.totalCost;
    allCost.text = consume.allCost;
    cardNumber.text = consume.cardNumber;
    memberName.text = consume.memberName;
    employeeNames.text = consume.employeeNames;
    summeryLabel.text = consume.summary;
    
    [self setImageViewForCoume];
}

-(void)setImageViewForCoume{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 202)];
//    backView.layer.cornerRadius = 6;
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:backView];
    [self.contentView sendSubviewToBack:backView];
}

@end
