//
//  MenuView.h
//  SpartaEducation
//
//  Created by kiwi on 14-7-23.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate;

@interface MenuView : UIView

@property (nonatomic, strong) UIScrollView * buttonView;
@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, assign) NSInteger numberOfButtons;
@property (nonatomic, assign) id <MenuViewDelegate> delegate;
@property (nonatomic, strong) UIImageView  * bkgView;

- (id)initWithButtonTitles:(NSArray *)titlesArray withDelegate:(id)del;
- (void)showInView:(id)view origin:(CGPoint)origin;
- (void)hide;

@end

@protocol MenuViewDelegate <NSObject>
@optional
- (void)popoverView:(MenuView *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)popoverViewCancel:(MenuView *)sender;
@end
