////
////  OnlineConsumeViewCell.m
////  CloudSalePlatform
////
////  Created by cloud on 14/12/8.
////  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
////
//
//#import "OnlineConsumeViewCell.h"
//#import "OnlineConsume.h"
//#import "UIImageView+WebCache.h"
//#import "Globals.h"
//
//@interface OnlineConsumeViewCell(){
//
//    NSString * wareId;
//}
//
//@end
//@implementation OnlineConsumeViewCell
//
//- (void)initialiseCell {
//    [super initialiseCell];
//    [_buyAgainBtn pinkStyle];
//    [_buyAgainBtn addTarget:self action:@selector(buyAgain) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_line1 setBackgroundColor: RGBACOLOR(215, 215, 215,0.5)];
//    [_line2 setBackgroundColor: RGBACOLOR(215, 215, 215,0.5)];
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.imageView.hidden = YES;
//    self.topLine  = YES;
//    self.bottomLine = YES;
//    self.height = 210;
//}
//
//-(void)setItem:(OnlineConsume *)consume{
//    wareId = consume.wareId;
//    _unionCurrencyLabel.text = @"";
//    _billNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",consume.billNumber.hasValue?consume.billNumber:@""];
//    _shopNameLabel.text = consume.unionShopName;
//    [_shopPicView sd_setImageWithURL:[NSURL URLWithString:consume.picture] placeholderImage:[Globals getImageDefault]];
//    _shopDetailLabel.text = consume.wareName;
//    _memberCashLabel.text = [NSString stringWithFormat:@"%@￥",consume.paymentOfCard];
//    _unionCurrencyLabel.text = [NSString stringWithFormat:@"%@￥",[[consume paymentOfUnionCurrency] hasValue]?[consume paymentOfUnionCurrency]:@"0"];
//    
//    CGSize size = [consume.unionShopName sizeWithFont:[UIFont systemFontOfSize:16]];
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(size.width + 10, (_shopNameLabel.height - 9)/2-6, 6, _shopNameLabel.height);
//    layer.contentsGravity = kCAGravityResizeAspect;
//    layer.contents = (id)[UIImage imageNamed:@"arrow_right" isCache:YES].CGImage;
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        layer.contentsScale = [[UIScreen mainScreen] scale];
//    }
//    [_shopNameLabel.layer addSublayer:layer];
//}
//
//-(void)buyAgain{
//    if ([_delegate respondsToSelector:@selector(buyAgain:)]) {
//        [_delegate performSelector:@selector(buyAgain:) withObject:wareId];
//    }
//}
//@end
