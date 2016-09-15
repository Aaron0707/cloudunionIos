//
//  ImageTouchView.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageTouchViewDelegate <NSObject>
- (void)imageTouchViewDidSelected:(id)sender;
@optional
- (void)imageTouchViewDidBegin:(id)sender;
- (void)imageTouchViewDidCancel:(id)sender;
@end

@interface ImageTouchView : UIImageView {
    IBOutlet id <ImageTouchViewDelegate> delegate;
}
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) id <ImageTouchViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id <ImageTouchViewDelegate>)del;
- (void)startRotateAnimation;
- (void)stopRotateAnimation;
@end
