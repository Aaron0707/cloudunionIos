//
//  ActionSheetOne.h
//  CloudSalePlatform
//
//  Created by cloud on 15/2/11.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActionSheetOneDelegate;
@interface ActionSheetOne : UIView

@property (nonatomic, assign) id <ActionSheetOneDelegate> delegate;

- (id)initWithActionTab:(NSArray*)tabs TextViews:(NSArray*)tViews withDelegate:(id)del;
- (void)show;
- (void)hide:(UIButton*)sender;
@end

@protocol ActionSheetOneDelegate <NSObject>
- (void)actionSheet:(ActionSheetOne *)sender didDismissWithObj:(NSDictionary *)dic;
@end