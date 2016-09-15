//
//  BasicNavigationController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BasicNavigationController.h"
#import "BaseViewController.h"
#import "BaseNavigationBar.h"

@interface BasicNavigationController ()

@end

@implementation BasicNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(234, 234, 234);
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
//    UIImage *backImage = [[UIImage imageNamed:@"back_bakc"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
//    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backButtonItem];
}

- (void)pushViewController:(BaseViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController showBackButton];
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
