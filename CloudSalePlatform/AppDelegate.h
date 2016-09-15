//
//  AppDelegate.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSArray * viewControllers;

+ (AppDelegate*)instance;
- (void)signOut;
@end
