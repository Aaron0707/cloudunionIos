//
//  KWAlertView.m
//  kiwi
//
//  Created by kiwi on 6/6/13.
//  Copyright (c) 2013 Kiwaro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KWAlertView.h"
#import "TextInput.h"
#import "UIColor+FlatUI.h"
#import "Globals.h"

#define KWAlertTag 1818
#define KWAlertTWidth 230
#define KWAlertButtonWidth 210
#define KWAlertBoldFont [UIFont systemFontOfSize:16]
#define KWAlertSFont [UIFont systemFontOfSize:15]
#define KWAlertSFontB [UIFont systemFontOfSize:15]

@interface KWAlertView () <UITextViewDelegate> {
    UIImageView * blackView;
}

@end

@implementation KWAlertView
@synthesize delegate, textViews, index, tag;

+ (void)showAlert:(NSString*)msg {
    KWAlertView * alert = [[KWAlertView alloc] initWithMsg:msg cancelButtonTitle:@"确定"];
    [alert show];
}

- (id)initWithMsg:(NSString*)msg cancelButtonTitle:(NSString *)canBtn {
    NSString * deftit = nil;
    return [self initWithTitle:deftit
                       message:msg
                      delegate:nil
             cancelButtonTitle:canBtn
                    textViews:nil
             otherButtonTitles:nil, nil];
}

- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
           delegate:(id)_delegate
  cancelButtonTitle:(NSString*)cancelButtonTitle
          textViews:(NSArray*)tvs
  otherButtonTitles:(NSString*)otherButtonTitles, ...  {
    NSMutableArray * buttons = nil;
    if ([otherButtonTitles isKindOfClass:[NSString class]] && otherButtonTitles.length > 0) {
        buttons = [NSMutableArray array];
        va_list args;
        va_start(args, otherButtonTitles); // scan for arguments after firstObject.        
        // get rest of the objects until nil is found
        for (NSString * str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            if ([str isKindOfClass:[NSString class]] && str.length > 0) {
                [buttons addObject:str];
            }
        }        
        va_end(args);
    }
    
    NSMutableArray * subs = [NSMutableArray array];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CGSize size; CGRect frame; CGFloat poX=0, poY=0;
    UILabel * lab; KTextView * tView; UIButton * btn;
    
    BOOL hasTitle = NO;
    if (title && [title isKindOfClass:[NSString class]] && title.length > 0) {
        size = [title sizeWithFont:KWAlertBoldFont constrainedToSize:CGSizeMake(KWAlertTWidth, 60)];
        frame = CGRectMake(poX, poY, KWAlertTWidth + 20, size.height + 15);
        lab = [[UILabel alloc] initWithFrame:frame];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lab.textColor = MyPinkColor;
        lab.numberOfLines = 0;
        
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = title;
        
        UIView *bkg = [[UIView alloc] initWithFrame:CGRectMake(poX, 30, KWAlertTWidth + 20, 1)];
//        bkg.frame = frame;
        [bkg setBackgroundColor:MyPinkColor];
        [subs addObject:bkg];
        [subs addObject:lab];
        poY += size.height + 20;
        hasTitle = YES;
    }
    
    poX=10;
    if (message && [message isKindOfClass:[NSString class]] && message.length > 0) {
        UIFont * font;
        if (hasTitle) {
            font = KWAlertSFont;
        } else {
            poY=15;
            font = KWAlertSFontB;
        }
        size = [message sizeWithFont:font constrainedToSize:CGSizeMake(KWAlertTWidth, 120)];
        frame = CGRectMake(poX, poY, KWAlertTWidth, size.height);
        lab = [[UILabel alloc] initWithFrame:frame];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = font;
        lab.textColor = [UIColor blackColor];
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = message;
        [subs addObject:lab];
        poY += size.height + 5;
    }
    
    if (tvs && tvs.count > 0) {
        for (tView in tvs) {
            if ([tView isKindOfClass:[UITextView class]]) {
                tView.delegate = self;
                frame = CGRectMake(20, poY, KWAlertTWidth - 20, 30);
                tView.frame = frame;
                UIImageView* bkgView = [[UIImageView alloc] initWithFrame:frame];
                UIImage * tfImg = [[UIImage imageNamed:@"Screening.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
                bkgView.image = tfImg;
                bkgView.autoresizingMask = self.autoresizingMask;
                [subs addObject:bkgView];
                [subs addObject:tView];
                poY += 35;
            }
        }
    }
    
    int hasBtn = 0;
    if ([cancelButtonTitle isKindOfClass:[NSString class]] && cancelButtonTitle.length > 0) {
        hasBtn ++;
    }
    hasBtn += buttons.count;
    
    if (hasBtn > 0) {
        poY += 5;
        if (hasBtn == 1) {
            NSString * btn0 = nil;
            BOOL isCancel = NO;
            if ([cancelButtonTitle isKindOfClass:[NSString class]] && cancelButtonTitle.length > 0) {
                btn0 = cancelButtonTitle;
                isCancel = YES;
            } else {
                btn0 = [buttons objectAtIndex:0];
            }
            frame = CGRectMake((KWAlertTWidth-KWAlertButtonWidth)/2 + 10, poY, KWAlertButtonWidth, 30);
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = frame;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            if (isCancel) {
                [btn commonStyle];
            } else {
                [btn warningStyle];
            }
            
            [btn setTitle:btn0 forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnOtherPress:) forControlEvents:UIControlEventTouchUpInside];
            [subs addObject:btn];
            poY += 45;
        } else if (hasBtn == 2) {
            NSString * btn0 = nil, * btn1 = nil;
            
            BOOL isCancel = NO;
            if ([cancelButtonTitle isKindOfClass:[NSString class]] && cancelButtonTitle.length > 0) {
                isCancel = YES;
                btn0 = cancelButtonTitle;
                btn1 = [buttons objectAtIndex:0];
            } else {
                btn0 = [buttons objectAtIndex:0];
                btn1 = [buttons objectAtIndex:1];
            }
            frame = CGRectMake(15, poY, 100, 30);
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = frame;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            if (isCancel) {
                [btn dangerStyle];
            } else {
                [btn warningStyle];
            }
            [btn setTitle:btn1 forState:UIControlStateNormal];
            
            btn.tag = 0;
            [btn addTarget:self action:@selector(btnOtherPress:) forControlEvents:UIControlEventTouchUpInside];
            [subs addObject:btn];
            frame = CGRectMake(135, poY, 100, 30);
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = frame;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn successStyle];
            [btn setTitle:btn0 forState:UIControlStateNormal];
            btn.tag = 1;
            [btn addTarget:self action:@selector(btnOtherPress:) forControlEvents:UIControlEventTouchUpInside];
            [subs addObject:btn];
            poY += 45;
        } else {
            for (int i = 0; i < buttons.count; i ++) {
                NSString * btn0 = [buttons objectAtIndex:i];
                frame = CGRectMake((KWAlertTWidth-KWAlertButtonWidth)/2 + 10, poY, KWAlertButtonWidth, 30);
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = frame;
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
                [btn successStyle];
                [btn setTitle:btn0 forState:UIControlStateNormal];
                btn.tag = i;
                [btn addTarget:self action:@selector(btnOtherPress:) forControlEvents:UIControlEventTouchUpInside];
                [subs addObject:btn];
                poY += 40;
            }
            if ([cancelButtonTitle isKindOfClass:[NSString class]] && cancelButtonTitle.length > 0) {
                NSString * btn0 = cancelButtonTitle;
                frame = CGRectMake((KWAlertTWidth-KWAlertButtonWidth)/2 + 10, poY, KWAlertButtonWidth, 30);
                btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = frame;
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
                [btn dangerStyle];
                [btn setTitle:btn0 forState:UIControlStateNormal];
                btn.titleLabel.shadowColor = tabColor;
                btn.titleLabel.shadowOffset = CGSizeMake(1, 1);
                [btn addTarget:self action:@selector(btnCancelPress:) forControlEvents:UIControlEventTouchUpInside];
                [subs addObject:btn];
                poY += 40;
            }
            poY += 5;
        }
    }
    
    CGFloat wid = KWAlertTWidth + 20;
    frame = CGRectMake((window.frame.size.width-wid)/2, (window.frame.size.height-poY)/2, wid, poY);
    if (self = [super initWithFrame:frame]) {
        self.delegate = _delegate;
        self.tag = KWAlertTag;
        self.backgroundColor = [UIColor cloudsColor];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        self.layer.cornerRadius = 10;
        for (UIView * sub in subs) {
            [self addSubview:sub];
        }
        self.textViews = tvs;
    }
    
    return self;
}

- (void)defaultInit {
    
}

- (void)dealloc {
    self.textViews = nil;
    Release(blackView);
}

- (void)show {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    KWAlertView * alreadyAlert = nil;
    for (UIView * sub in window.subviews) {
        if ([sub isKindOfClass:[KWAlertView class]] && sub.tag == KWAlertTag) {
            alreadyAlert = (KWAlertView*)sub;
        }
    }
    if (alreadyAlert != nil) {
        [alreadyAlert hide:@"HIDE"];
        [self performSelector:@selector(show) withObject:nil afterDelay:0.25];
        return;
    }
    self.alpha = 0;
    if (blackView == nil) {
        blackView = [[UIImageView alloc] initWithFrame:window.bounds];
        blackView.backgroundColor = [UIColor clearColor];
        blackView.alpha = 0;
        blackView.backgroundColor = RGBACOLOR(100, 100, 100, 0.5);
        blackView.userInteractionEnabled = YES;
        [window addSubview:blackView];
    }
    [window addSubview:self];
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView beginAnimations:@"SHOW0" context:nil];
    [UIView setAnimationDuration:0.20];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnd:finished:context:)];
    blackView.alpha = 1;
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView commitAnimations];
}

- (void)hide:(NSString*)HID {
    [UIView beginAnimations:HID context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationEnd:finished:context:)];
    blackView.alpha = 0;
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView commitAnimations];
}

- (void)animationEnd:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if ([animationID hasPrefix:@"SHOW"]) {
        if ([animationID hasSuffix:@"0"]) {
            [UIView beginAnimations:@"SHOW1" context:nil];
            [UIView setAnimationDuration:0.10];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationEnd:finished:context:)];
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            [UIView commitAnimations];
        } else if ([animationID hasSuffix:@"1"]) {
            [UIView beginAnimations:@"SHOW2" context:nil];
            [UIView setAnimationDuration:0.07];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationEnd:finished:context:)];
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView commitAnimations];
        }
    } else if ([animationID hasPrefix:@"HIDE"]) {
        if (animationID.length > 4) {
            NSString * su = [animationID substringFromIndex:4];
            NSInteger bID = [su integerValue];
            if (bID >= 0 && bID < 90) {
                if ([delegate respondsToSelector:@selector(kwAlertView:didDismissWithButtonIndex:)]) {
                    [delegate kwAlertView:self didDismissWithButtonIndex:bID];
                }
            }
        }
        [blackView removeFromSuperview];
        [self removeFromSuperview];
    }
}

#pragma mark - Button Actions

- (void)btnOtherPress:(UIButton*)sender {
    NSString * animationID = [NSString stringWithFormat:@"HIDE%ld", (long)sender.tag];
    [self hide:animationID];
}

- (void)btnCancelPress:(id)sender {
    [self hide:@"HIDE99"];
}

#pragma mark - Button Actions

#define KEYH 240

- (void)textViewDidBeginEditing:(UITextView *)sender {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    height = height - 240 - self.frame.size.height/2;
    if (height < self.center.y) {
        [UIView beginAnimations:@"MOVE" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationEnd:finished:context:)];
        self.center = CGPointMake(self.center.x, height);
        [UIView commitAnimations];
    }
}

@end
