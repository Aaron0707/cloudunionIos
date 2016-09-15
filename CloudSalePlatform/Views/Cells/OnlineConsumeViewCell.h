//
//  OnlineConsumeViewCell.h
//  CloudSalePlatform
//
//  Created by cloud on 14/12/8.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "BaseTableViewCell.h"
@class OnlineBill;

@protocol BuyAgainDelegate <NSObject>

-(void)buyAgain:(NSString *)wareId;

@end
@interface OnlineConsumeViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *billNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *shopPicView;
@property (strong, nonatomic) IBOutlet UILabel *shopDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberCashLabel;
@property (strong, nonatomic) IBOutlet UILabel *unionCurrencyLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyAgainBtn;
@property (strong, nonatomic) IBOutlet UIView *line1;

@property (strong, nonatomic) IBOutlet UIView *line2;
@property (nonatomic,weak) id<BuyAgainDelegate> delegate;
-(void)setItem:(OnlineBill *)consume;
@end
