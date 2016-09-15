//
//  TextInput.h
//  FamiliarMen
//
//  Created by kiwi on 14-1-17.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTextField : UITextField
- (void)shakeAlert;
@property (nonatomic, assign) NSInteger  index;
@end


@interface KTextView : UITextView {
    UILabel * labPlaceholder;
    UILabel * labCount;
    UIImageView * backgroundView;
}

@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, assign) NSInteger  maxCount;

- (void)setplaceholderFram:(CGRect)rect;
- (void)setplaceholderTextAlignment:(NSTextAlignment)aligment;
- (void)setupBackgroundView;
@end
