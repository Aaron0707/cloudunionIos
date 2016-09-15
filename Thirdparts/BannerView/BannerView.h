//
//  BannerView.h
//  LfMall
//
//  Created by keen on 13-8-5.
//  Copyright (c) 2013年 XizueSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView, BannerCell;

@protocol BannerViewDelegate <NSObject>

@required
- (NSInteger)numberOfPagesInBannerView:(BannerView*)sender;
- (BannerCell*)bannerView:(BannerView*)sender cellForPage:(NSInteger)page;

@optional
- (void)bannerView:(BannerView*)sender willDisplayCell:(BannerCell*)cell forPage:(NSInteger)page;
- (void)bannerView:(BannerView*)sender tappedOnPage:(NSInteger)page;

@end


@interface BannerCell : UIImageView

- (id)initWithPage:(NSInteger)page;

@end


@interface BannerView : UIView

@property (nonatomic, assign) id <BannerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedPage;

- (void)setScrollViewHeight:(CGFloat)height;
- (BannerCell*)cellForPage:(NSInteger)page;
- (void)reloadData;
- (void)setPageControlHiden:(BOOL)isHiden;
@end
