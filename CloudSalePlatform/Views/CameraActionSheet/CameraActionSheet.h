//
//  CameraActionSheet.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraActionSheetDelegate;

@interface CameraActionSheet : UIView

@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, assign) NSInteger cancelButtonIndex;
@property (nonatomic) NSInteger destructiveButtonIndex;
@property (nonatomic, assign) NSInteger numberOfButtons;
@property (nonatomic, assign) id <CameraActionSheetDelegate> delegate;

- (id)initWithActionTitle:(NSString*)title TextViews:(NSString*)tViews CancelTitle:(NSString*)cancelTitle withDelegate:(id)del otherButtonTitles:(NSArray*)otherButtonTitles;

//- (void)showInView:(UIView*)view;
- (void)show;
- (void)hide:(UIButton*)sender;

@end

@protocol CameraActionSheetDelegate <NSObject>
- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
