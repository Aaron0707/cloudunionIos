//
//  HeaderButtonsView.h
//  CarPool
//
//  Created by kiwi on 14-6-25.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderButtonDelegate <NSObject>
- (void)selectedButtonAtIdx:(NSInteger)idx;
@end
@interface HeaderButtonsView : UIView
@property (nonatomic, strong) NSArray * nameArray;
@property (nonatomic, strong) id<HeaderButtonDelegate> delegate;
@property (nonatomic, assign) CGFloat maxButtonWidth;
@property (nonatomic, assign) NSInteger selected;
@property (nonatomic, copy) UIColor * buttonTitleColor;
- (void)resetallStatus;
@end
