//
//  BusinessShopViewCell.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BusinessShopViewCell.h"
#import "BusinessShop.h"

@interface BusinessShopViewCell () {
    IBOutlet UILabel * distanceLabel;
    IBOutlet UILabel * discountLabel; // 折扣
}

@property (nonatomic, copy) NSString * distance;
@property(nonatomic, strong) UILabel * detailTextLabel;
@end
@implementation BusinessShopViewCell
@synthesize detailTextLabel, item;

- (void)initialiseCell {
    [super initialiseCell];
    
    self.detailTextLabel = [UILabel new];
    detailTextLabel.font = [UIFont systemFontOfSize:13];
    detailTextLabel.textColor = distanceLabel.textColor;
    detailTextLabel.backgroundColor = [UIColor clearColor];
    detailTextLabel.tag = 1;
    detailTextLabel.numberOfLines = 0;
    detailTextLabel.highlightedTextColor = distanceLabel.highlightedTextColor;
    [self.contentView addSubview:self.detailTextLabel];
    discountLabel.clipsToBounds = NO;
    self.imageView.layer.cornerRadius = 10;
}

- (void)setDistance:(NSString *)dis {
    if (![dis isEqualToString:_distance]) {
        _distance = [dis copy];
        distanceLabel.text = dis;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, self.height - 5, self.height - 20);
    self.textLabel.frame = CGRectMake(self.imageView.right + 10, 14, self.width - self.imageView.right - 20, 18);
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, distanceLabel.top, self.width - self.imageView.right - 5 - distanceLabel.width - 5, 16);
}

- (void)setItem:(BusinessShop *)it {
    
    self.distance = it.distance;
    self.textLabel.text = it.orgName;
    if (it.discount.doubleValue > 0) {
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折", it.discount]];
        [attrTitle addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(0, it.discount.length)];
        [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, it.discount.length)];
        
        discountLabel.attributedText = attrTitle;
    }
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", it.categoryName, it.districtName];
    
    [self setStar:ceil(it.score.doubleValue) numberShow:it.commentTimes.intValue];
}

-(void)setStar:(int)score numberShow:(int)numb{
    int red = score;
    int gray = 5-red;
    for (double i=0; i<red; i++) {
        UIView *view = [self.contentView viewWithTag:i+200];
        if (!view) {
            view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar"]]];
            view.top = discountLabel.top+10;
            view.size = CGSizeMake(9, 9);
            view.left = 110 + i*10;
            view.tag = i+200;
            [self.contentView addSubview:view];
        }
    }
    for (double i=0; i<gray; i++) {
        UIView *view = [self.contentView viewWithTag:i+210];
        if (!view) {
             view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar2"]]];
            view.top = discountLabel.top+10;
            view.size = CGSizeMake(9, 9);
            view.left = 110 + (i+red)*10;
            view.tag = i+210;
            [self.contentView addSubview:view];
        }
    }
    
    UILabel *totalLabel = (id)[self.contentView viewWithTag:221];
    if (!totalLabel) {
        totalLabel = [[UILabel alloc] init];
        totalLabel.font = [UIFont systemFontOfSize:12];
        totalLabel.textColor = distanceLabel.textColor;
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.highlightedTextColor = distanceLabel.highlightedTextColor;
        totalLabel.tag = 221;
        totalLabel.size = CGSizeMake(100, 20);
        totalLabel.top = discountLabel.top+4;
        totalLabel.left = 110 + 6*10;
        totalLabel.clipsToBounds = NO;
        [self.contentView addSubview:totalLabel];
    }
    totalLabel.text = [NSString stringWithFormat:@"%i条",numb];
}


@end
