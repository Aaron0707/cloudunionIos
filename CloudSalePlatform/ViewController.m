//
//  AppDelegate.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ViewController.h"
#import "BasicNavigationController.h"
#import "BSEngine.h"
#import "MineViewController.h"
#import "LoginController.h"
#import "AppDelegate.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "Globals.h"
#import "HomeViewController.h"
#import "ShopingCarViewController.h"

#define imageTabBar(idx) LOADIMAGE(([NSString stringWithFormat:@"tabbar_icon%d",idx]))
#define imageTabBarD(idx) LOADIMAGE(([NSString stringWithFormat:@"tabbar_icon%d_d",idx]))
@interface ViewController ()<UIGestureRecognizerDelegate, UITabBarControllerDelegate> {
    NSMutableArray  *   rootConArr;
    int                 selectIndex;
    int                 msgCount;
}


@end

@implementation ViewController

- (id)init {
    if (self = [super init]) {
        // Custom initialization
        self.controllerArr = [NSMutableArray array];
        rootConArr = [[NSMutableArray alloc] init];
        [self initTabbarControllers];

    }
    return self;
}

- (void)dealloc {
    Release(_controllerArr);
    Release(rootConArr);
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#define TitleArr @[@"首页",@"消息",@"购物车",@"我的"]
#define ControllerclassArr  @[@"HomeViewController" , @"InformationViewController",@"ShopingCarViewController", @"MineViewController"]

- (UITabBarItem *)tabBarItemAtindex:(int)idx {
    UITabBarItem * barItem = nil;
    NSString * name = TitleArr[idx];
    UIFont* font = [UIFont systemFontOfSize:12];
    if (Sys_Version < 7) {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:imageTabBar(idx) tag:0];
        [barItem setFinishedSelectedImage:imageTabBarD(idx==0?idx:idx+1) withFinishedUnselectedImage:imageTabBar(idx==0?idx:idx+1)];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:(idx==0||idx==2)?MyPinkColor:idx==1?MygreenColor:RGBCOLOR(63, 175, 225),UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BkgFontColor, UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateNormal];
    } else {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:imageTabBar(idx==0?idx:idx+1) selectedImage:imageTabBarD(idx==0?idx:idx+1)];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         (idx==0||idx==2)?MyPinkColor:idx==1?MygreenColor:RGBCOLOR(63, 175, 225), NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         BkgFontColor, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        
    }
    return barItem;
}

- (void)initTabbarControllers {
    [ControllerclassArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class class = NSClassFromString(ControllerclassArr[idx]);
        UIViewController * tmpCon = [[class alloc] init];
        UITabBarItem * barItem = [self tabBarItemAtindex:idx];
        tmpCon.tabBarItem = barItem;
        [rootConArr addObject:tmpCon];
        BasicNavigationController* navCon = [[BasicNavigationController alloc] initWithRootViewController:tmpCon];
        navCon.tabBarItem = barItem;
        [self.controllerArr addObject:navCon];
    }];

    self.delegate = self;
    self.tabBar.backgroundColor = tabColor;
    self.viewControllers = _controllerArr;
    self.selectedIndex = 0;
    self.tabBarController.tabBar.tintColor =MyPinkColor;
    [self.tabBar setBackgroundImage:[Globals getImageWithColor:[UIColor whiteColor]]];
    if (Sys_Version < 7) {
        [self.tabBar setTintColor:[UIColor whiteColor]];
    } else {
        self.tabBar.translucent = NO;
        [self.tabBar setBarTintColor:[UIColor whiteColor]];
    }

    [self.tabBar setBackgroundImage: [UIImage imageWithColor:tabColor cornerRadius:0]];
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_select_bkg"]];
    
    AppDelegate * delegate = [AppDelegate instance];
    delegate.viewControllers = _controllerArr;
}

#pragma mark -
#pragma mark - Notifications
// login State did change
- (void)notificationLoginChanged:(NSNotification*)notification {
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    viewController.tabBarItem.badgeValue = nil;
}


@end