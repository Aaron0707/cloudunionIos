//
//  KWAlertView.h
//  kiwi
//
//  Created by kiwi on 6/6/13.
//  Copyright (c) 2013 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KWAlertView;

@protocol KWAlertViewDelegate <NSObject>

@optional
- (void)kwAlertView:(KWAlertView*)sender didDismissWithButtonIndex:(NSInteger)index;

@end



NS_CLASS_AVAILABLE_IOS(2_0) @interface KWAlertView : UIView

@property (nonatomic, assign) id <KWAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray * textViews;
@property (nonatomic, assign) int index;
//@property (nonatomic, assign) int tag;
#pragma mark - Quick Methods

+ (void)showAlert:(NSString*)msg;
- (id)initWithMsg:(NSString*)msg cancelButtonTitle:(NSString *)canBtn;

#pragma mark - Public Methods

- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
           delegate:(id)_delegate
  cancelButtonTitle:(NSString*)cancelButtonTitle
         textViews:(NSArray*)tvs
  otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
