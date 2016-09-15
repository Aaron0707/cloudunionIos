//
//  UploadPreViewController.h
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol updateDidDelegate <NSObject>
@optional
- (void)updateDid:(id)obj path:(NSString*)path;
- (void)saveBtnPressed:(UIImage *)image;
@end

@interface UploadPreViewController : BaseViewController {
    CGRect screenFrame;
}

@property (nonatomic, strong, readonly) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *shotView;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) id<updateDidDelegate> del;
@property (nonatomic, assign) BOOL uploadMine;

@end
