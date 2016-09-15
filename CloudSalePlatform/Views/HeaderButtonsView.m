//
//  HeaderButtonsView.m
//  CarPool
//
//  Created by kiwi on 14-6-25.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "HeaderButtonsView.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"

@interface HeaderButtonsView ()

@end
@implementation HeaderButtonsView
@synthesize nameArray, buttonTitleColor;
@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}

- (void)loadView {
    self.backgroundColor = RGBCOLOR(250, 247, 240);
    self.buttonTitleColor = [UIColor grayColor];
    _selected = -1;
}

- (void)dealloc {
    Release(buttonTitleColor);
    self.nameArray = nil;
}


- (void)setNameArray:(NSArray *)arr {
    nameArray = arr;
    if (arr.count <= 4) {
        self.maxButtonWidth = self.width/arr.count;
    } else {
        self.maxButtonWidth = 80;
    }
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
        if ([btn isKindOfClass:[UIImageView class]] && btn.tag > 0) {
            [btn removeFromSuperview];
        }
    }
    CGFloat totalWidth = 0;
    for (int i = 0;i < nameArray.count;i++) {
        UIButton *btn = [self buttonWithTitle:nameArray[i]];
        btn.tag = i;
        UIButton *_arrowBtn = [self arrowBtn];
        _arrowBtn.frame = CGRectMake(_maxButtonWidth - 16, (self.height-7)/2, 8, 7);
        [btn addSubview:_arrowBtn];
        
        btn.frame = CGRectMake(totalWidth, 0, _maxButtonWidth, self.height);
        [self addSubview:btn];
        if (i > 0) {
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(totalWidth-0.5, 2, 1, self.height - 4)];
            view.tag = i;
            view.image = [UIImage imageNamed:@"SecretaryCut_line" isCache:YES];
            [self addSubview:view];
        }
        
        totalWidth += _maxButtonWidth;
    }
}

- (UIButton *)arrowBtn {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 11;
    [btn setImage:LOADIMAGE(@"arrow_dropdown") forState:UIControlStateNormal];
    [btn setImage:LOADIMAGE(@"arrow_dropup") forState:UIControlStateSelected];
    btn.frame = CGRectZero;
    return btn;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forState:UIControlStateSelected];
    [btn setTitleColor:kBlueColor forState:UIControlStateHighlighted];
    [btn setTitleColor:kBlueColor forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonitemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

- (void)buttonitemPressed:(UIButton*)sender {
    if (_selected != sender.tag) {
        [self resetallStatus];
        _selected = sender.tag;
        UIButton * btn = VIEWWITHTAG(sender, 11);
        btn.selected = sender.selected = !sender.selected;
        if ([delegate respondsToSelector:@selector(selectedButtonAtIdx:)]) {
            [delegate selectedButtonAtIdx:sender.tag];
        }
        self.userInteractionEnabled = NO;
    } else {
        
    }

}

- (void)resetallStatus {
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * btn = VIEWWITHTAG(obj, 11);
            btn.selected = obj.selected = NO;
        }
    }];
    self.userInteractionEnabled = YES;
    _selected = -1;
}
@end
