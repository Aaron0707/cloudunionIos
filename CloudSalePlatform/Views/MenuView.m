//
//  MenuView.m
//  SpartaEducation
//
//  Created by kiwi on 14-7-23.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MenuView.h"
#import "UIImage+FlatUI.h"
#import "BusinessCategory.h"

@interface MenuView ()

@property (nonatomic, assign) CGFloat maximumButtonHeight;
@property (nonatomic, assign) CGFloat maximumButtonWidth;
@end

@implementation MenuView
@synthesize delegate, bkgView, maximumButtonHeight, maximumButtonWidth, buttonTitles;

- (id)initWithButtonTitles:(NSArray *)titlesArray withDelegate:(id)del
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [self initWithFrame:rect];
    if (self) {
        
        //  Minimum Button Height
        maximumButtonHeight = 42;
        //  Maximum button width
        maximumButtonWidth = Main_Screen_Width/2;
        
        self.delegate = del;
        self.buttonTitles = [NSMutableArray arrayWithArray:titlesArray];
        
        //  1. Add bkgView
        [self addSubview:[self bkgView]];
        
        // 3. Add buttonView
        [self addSubview:[self buttonView]];
        // 4. Render the buttons
        [self renderButtons];
        self.numberOfButtons = buttonTitles.count;
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.bkgView = nil;
    self.buttonTitles = nil;
}

- (UIScrollView*)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, maximumButtonWidth, 252)];
        _buttonView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _buttonView.alwaysBounceVertical = YES;
        _buttonView.showsHorizontalScrollIndicator = NO;
        _buttonView.showsVerticalScrollIndicator = NO;
        _buttonView.layer.borderWidth = 0.5;
        _buttonView.backgroundColor = RGBCOLOR(248, 248, 248);
        _buttonView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    }
    return _buttonView;
}

- (CGFloat)getHeight {
    return buttonTitles.count*maximumButtonHeight;
}

- (UIImageView*)bkgView {
    if (!bkgView) {
        bkgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        bkgView.backgroundColor = [RGBCOLOR(102, 102, 102) colorWithAlphaComponent:0.7];
        bkgView.userInteractionEnabled = YES;
        bkgView.layer.masksToBounds = YES;
        bkgView.alpha = 0;
    }
    return bkgView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hide];
    if([delegate respondsToSelector:@selector(popoverViewCancel:)]){
        [delegate popoverViewCancel:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - Render Buttons

- (void)renderButtons {
    //  remove if buttons Existing||Empty
    [_buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //  Render new buttons
    [self.buttonTitles enumerateObjectsUsingBlock:^(BusinessCategory * item, NSUInteger idx, BOOL *stop) {
        //  Add the buttons to the UI
        UIButton *button = [self buttonWithTitle:item.name forIndex:idx];
        [_buttonView addSubview:button];
        //  Handle touches in the app
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, idx*maximumButtonHeight, bkgView.width, 1)];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lineView.backgroundColor = RGBCOLOR(210, 210, 210);
        lineView.alpha = 0.6;
        [_buttonView addSubview:lineView];
    }];
    UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.buttonTitles.count*maximumButtonHeight, bkgView.width, 1)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    lineView.backgroundColor = RGBCOLOR(210, 210, 210);
    lineView.alpha = 0.6;
    [_buttonView addSubview:lineView];
    _buttonView.contentSize = CGSizeMake(0, [self getHeight]);
}

#pragma mark - Button Event Handling

- (void)buttonTapped:(UIButton *)sender {
    [self hide];
    if([delegate respondsToSelector:@selector(popoverView:didDismissWithButtonIndex:)]){
        [delegate popoverView:self didDismissWithButtonIndex:sender.tag];
    }
}

#pragma mark - Button Metrics

/*  @Returns a button for a given title and index */
- (UIButton *) buttonWithTitle:(NSString *)title forIndex:(NSUInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setFrame:CGRectMake(0, index*maximumButtonHeight, maximumButtonWidth, maximumButtonHeight)];
    //  Apply autoresizing masks
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [button setTitleColor:RGBCOLOR(102, 100, 101) forState:UIControlStateNormal];
    [button setTitleColor:kBlueColor forState:UIControlStateHighlighted];
    
//    [button setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)];
    [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(247, 247, 247) cornerRadius:0] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(238, 238, 238) cornerRadius:0] forState:UIControlStateHighlighted];
    //  Apply the title
    [button setTitle:title forState:UIControlStateNormal];
    return button;
    
}

//  Returns the space between the buttons
- (CGFloat)verticalSpacingBetweenButtons {
    return 5;
}

#pragma mark - Presentation

- (void)showInView:(UIView*)view origin:(CGPoint)origin {
    
    _buttonView.top = - 200;
    _buttonView.left = origin.x;
    [view insertSubview:self atIndex:view.subviews.count - 2];
    [UIView
     animateWithDuration:0.3
     animations:^{
         _buttonView.top = origin.y;
         bkgView.alpha = 1;
     }];
}

- (void)hide {
    // Animate everything out of place
    
    [UIView
     animateWithDuration:0.3
     animations:^{
         _buttonView.top = -_buttonView.height;
         bkgView.alpha = 0;
     } completion:^(BOOL finished) {
         if (finished) {
             [self removeFromSuperview];
         }
     }];
}

@end