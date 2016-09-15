//
//  CameraActionSheet.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CameraActionSheet.h"
#import "UIColor+FlatUI.h"
#import "UIImage+FlatUI.h"
#import "UIImage+Alpha.h"
#import <CoreGraphics/CoreGraphics.h>

@interface CameraActionSheet ()
@property (nonatomic, strong) UIView        * frameView;
@property (nonatomic, strong) UIView        * glassWrapper;
@property (nonatomic, strong) UIView        * buttonView;
@property (nonatomic, assign) CGFloat       minimumButtonHeight;
@property (nonatomic, assign) CGFloat       maximumButtonWidth;
@property (nonatomic, strong) NSString      * actionTitle;
@property (nonatomic, strong) NSString      * textViews;
@end

@implementation CameraActionSheet
@synthesize buttonTitles, frameView, glassWrapper, buttonView, actionTitle, textViews;
@synthesize destructiveButtonIndex;
@synthesize delegate;

- (id)initWithActionTitle:(NSString*)title TextViews:(NSString*)tViews CancelTitle:(NSString*)cancelTitle withDelegate:(id)del otherButtonTitles:(NSArray*)otherButtonTitles {
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [self init];
    if (self) {
        self.frame = rect;
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        // Cancel Button Index
        _cancelButtonIndex = -1;
        //  Minimum Button Height
        _minimumButtonHeight = 38;
        //  Maximum button width
        _maximumButtonWidth = self.width - 40;
        
        destructiveButtonIndex = -1;
        self.actionTitle = title;
        self.textViews = tViews;
        self.delegate = del;
        self.buttonTitles = nil;
        buttonTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        
        destructiveButtonIndex =
        _cancelButtonIndex = buttonTitles.count;
        
        if (cancelTitle) {
            [self.buttonTitles addObject:cancelTitle];
        }
        //  1. Add a modal overlay
        [self addSubview:self.frameView];
        
        //  2. Add a glass wrapper one third of the screen
        [frameView addSubview:self.glassWrapper];
        
        
        // 4. Render the buttons
        [self renderButtons];
        self.numberOfButtons = buttonTitles.count;
    }
    return self;
}

- (void)dealloc {
    self.actionTitle = nil;
    self.textViews = nil;
    self.delegate = nil;
    self.frameView = nil;
    self.glassWrapper = nil;
    self.buttonTitles = nil;
    self.buttonView = nil;
}

- (UIView*)glassWrapper {
    if (!glassWrapper) {
        glassWrapper = [[UIView alloc] init];
        [glassWrapper setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
        CGSize size = CGSizeZero;
        CGFloat height = (actionTitle?20:4)+buttonTitles.count*(_minimumButtonHeight+10)+15;
        if (textViews && textViews.length > 0) {
            size = [textViews sizeWithFont:[UIFont systemFontOfSize:13] maxWidth:self.width - 80 maxNumberLines:0];
            height += size.height + 4;
        }
        
        CGRect frame = CGRectMake(0, self.height - height, self.width, height);
        [glassWrapper setFrame:frame];
        [glassWrapper setBackgroundColor:RGBCOLOR(214, 214, 211)];
        
        // add actionTitle
        UILabel * label = nil;
        if (actionTitle) {
            label = [UILabel linesText:actionTitle font:[UIFont systemFontOfSize:14] wid:self.width-20 lines:0];
            label.origin = CGPointMake(10, 5);
            label.width = self.width-20;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [glassWrapper addSubview:label];
        }
        
        if (textViews && textViews.length > 0) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(40, label.bottom, self.width - 80, size.height)];
            label.text = textViews;
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            [glassWrapper addSubview:label];
        }
        // 3. Add buttonView
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom + 10, self.width, height - (label.bottom + 10))];
        buttonView.autoresizingMask  = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [glassWrapper addSubview:buttonView];
    }
    return glassWrapper;
}

- (UIView*)frameView {
    if (!frameView) {
        frameView = [[UIView alloc] initWithFrame:[self frame]];
        [frameView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        frameView.backgroundColor = [UIColor clearColor];
        //  Hide the buttons
        //        [frameView setTransform:CGAffineTransformMakeTranslation(0, frameView.height)];
        frameView.top = frameView.height;
    }
    return frameView;
}

#pragma mark - Overridden Setters

- (void)setDestructiveButtonIndex:(NSInteger)_destructiveButtonIndex
{
    destructiveButtonIndex = _destructiveButtonIndex;
    [self renderButtons];
}

#pragma mark - Render Buttons

- (void)renderButtons {
    //  remove if buttons Existing||Empty
    [buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //  Render new buttons
    [self.buttonTitles enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL *stop) {
        //  Add the buttons to the UI
        UIButton *button = [self buttonWithTitle:title forIndex:idx];
        [buttonView addSubview:button];
        //  Handle touches in the app
        [button addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - Button Metrics

//
//  Returns a button for a given title and index
//

- (UIButton *) buttonWithTitle:(NSString *)title forIndex:(NSUInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    //
    //  Resize the button
    //
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    CGFloat buttonHeight = _minimumButtonHeight;
    CGFloat buttonWidth = [self buttonWidth];
    
    CGRect buttonFrame = CGRectMake((self.width - buttonWidth)/2, index*(buttonHeight + [self verticalSpacingBetweenButtons]), buttonWidth, buttonHeight);
    [button setFrame:buttonFrame];
    if (index == destructiveButtonIndex) {
        [button defaultStyle];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else {
        [button navBlackStyle];
    }
    
    //  Apply autoresizing masks
    [button setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)];
    
    //  Apply the title
    [button setTitle:title forState:UIControlStateNormal];
    return button;
    
}

- (CGFloat)buttonWidth {
    return glassWrapper.width - 40;
}

//  Returns the space between the buttons
- (CGFloat)verticalSpacingBetweenButtons {
    return 10;
}

#pragma mark - Presentation

//- (void)showInView:(UIView*)view {
- (void)show {
    //  1. Install the modal view
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    //  2. Animate everything into place
    [UIView
     animateWithDuration:0.45
     animations:^{
         //  3. Slide the buttons into place
         // Transform:slowly in iphone4
         //         [frameView setTransform:CGAffineTransformIdentity];
         
         frameView.top = 0;
     }
     completion:^(BOOL finished) {
         
     }];
}

- (void)hide:(UIButton*)sender {
    // Animate everything out of place
    
    [UIView
     animateWithDuration:0.3
     animations:^{
         frameView.top = frameView.height;
         //  hide the main view down
         //         CGAffineTransform t = CGAffineTransformIdentity;
         //         t = CGAffineTransformTranslate(t, 0, frameView.height);
         //         [frameView setTransform:t];
     }
     completion:^(BOOL finished) {
         if (finished) {
             [self removeFromSuperview];
             if([delegate respondsToSelector:@selector(cameraActionSheet:didDismissWithButtonIndex:)]){
                 [delegate cameraActionSheet:self didDismissWithButtonIndex:sender.tag];
             }
         }
     }];
    
}

@end

