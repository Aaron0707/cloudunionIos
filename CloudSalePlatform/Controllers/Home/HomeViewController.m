//
//  HomeViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "HomeViewController.h"
#import "CycleScrollView.h"
#import "Globals.h"
#import "ShopDetail.h"
#import "BSClient.h"
#import "UIImageView+WebCache.h"
#import "CameraActionSheet.h"
#import "WareListViewController.h"
//#import "EmpListViewController.h"
#import "OnlineAppointmentViewController.h"
#import "ActivityListViewController.h"
#import "AppointmentListViewController.h"
#import "CricleListViewController.h"
#import "ContactListViewController.h"
#import "ChatListViewController.h"
#import "ApplyViewController.h"
#import "ChatListViewController.h"
#import "SellerViewController.h"
#import "BasicNavigationController.h"
#import "QhtShopListViewController.h"
#import "QhtShop.h"
#import "BusinessShop.h"
#import "XHImageViewer.h"
#import "ShopDetailViewController.h"
#import "RedEnvelopeViewController.h"

#import "UserType.h"
#import "SenchaManagerViewController.h"

#import <CommonCrypto/CommonDigest.h>

@interface HomeViewController ()<CameraActionSheetDelegate,QhtShopListDelegate,XHImageViewerDelegate>{
    NSString *indexShopId;
    UIImageView *advertisements;
    
    BasicNavigationController *chatNavgation ;
    BasicNavigationController *contactNavgation ;
    
    BasicNavigationController *cricleNavgation;
    
    BOOL needLoadHomeBadge;
    
    NSDictionary * homeBadge;
    
    NSString * currentUserType;
    
}

@property (nonatomic , retain) CycleScrollView *headScorllView;

@property (nonatomic , strong) NSDictionary *shop;
@property (nonatomic , strong) NSArray *galleries;
@end

@implementation HomeViewController

-(id)init{
    if (self = [super init]) {
         indexShopId = [BSEngine currentEngine].user.currentShopId;
        _homeActBtn = [[UIButton alloc]init];
        _homeCallBtn = [[UIButton alloc]init];
        _homeCargo_btn = [[UIButton alloc]init];
        _homeEmpBtn = [[UIButton alloc]init];
        _homeYunlianBtn = [[UIButton alloc]init];
        needLoadHomeBadge = YES;
        homeBadge = [NSDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     BOOL isNewCard = [[BSEngine currentEngine] isNewCard];
    
    currentUserType = [BSEngine currentEngine].user.currentUserType;
    
    [self initHomeViews:isNewCard];
    
    [self setLeftBarButtonImage:[UIImage imageNamed:@"index_left_bar"] selector:@selector(shopDetialAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLoginChanged:) name:NtfLogin object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndexShopId:) name:ChangeMemberCard object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMemberType:) name:ChangeMemberType object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
     self.tabBarController.tabBar.tintColor =MyPinkColor;
    [super viewDidAppear:animated];
    
    [self showOrHidenManager:![currentUserType isEqualToString:@"MEMBER"]];
    
    if ([self showLoginIfNeed]) {
        if (!self.shop) {
            if ([super startRequest]) {
                if (indexShopId && indexShopId.hasValue) {
                    [client findOpenShop:indexShopId];
                }else{
                    [client findOpenShop];
                }
            }
        }else{
            if (needLoadHomeBadge) {
                client = [[BSClient alloc] initWithDelegate:self action:@selector(requestHomeBadgeDidFinish:obj:)];
                [client getHomeBadgeByShopId:[self.shop objectForKey:@"id"]];
                [self performSelector:@selector(setNeedLoadHomeBadge) withObject:nil afterDelay:60.0f];
            }else{
                [self createMyBadge:_homeActBtn Value:[homeBadge getStringValueForKey:@"promotionBadge" defaultValue:@"0"] Left:NO];
                [self createMyBadge:_homeEmpBtn Value:[homeBadge getStringValueForKey:@"employeeBadge" defaultValue:@"0"] Left:NO];
                [self createMyBadge:_homeCargo_btn Value:[homeBadge getStringValueForKey:@"wareBadge" defaultValue:@"0"] Left:NO];
            }
        }
    }

//    [self showOrHidenShopList:[[[BSEngine currentEngine] user] isShowNearShop]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list =[obj objectForKey:@"list"];
        self.shop = list[0];
        self.galleries =  [self.shop objectForKey:@"galleries"];
        [self updateMyHead];
        
        client = [[BSClient alloc] initWithDelegate:self action:@selector(requestHomeBadgeDidFinish:obj:)];
        [client getHomeBadgeByShopId:[self.shop objectForKey:@"id"]];
        [self performSelector:@selector(setNeedLoadHomeBadge) withObject:nil afterDelay:60.0f];
    }
    
    return YES;
}

-(void)requestHomeBadgeDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self createMyBadge:_homeActBtn Value:[obj getStringValueForKey:@"promotionBadge" defaultValue:@"0"] Left:NO];
        [self createMyBadge:_homeEmpBtn Value:[obj getStringValueForKey:@"employeeBadge" defaultValue:@"0"] Left:NO];
        [self createMyBadge:_homeCargo_btn Value:[obj getStringValueForKey:@"wareBadge" defaultValue:@"0"] Left:NO];
        needLoadHomeBadge = NO;
        homeBadge = obj;
    }
}

-(void)requestRedEnvelopeSetingDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        RedEnvelopeViewController * con = [[RedEnvelopeViewController alloc] init];
        con.readingRedEnvelope = [[obj getStringValueForKey:@"total" defaultValue:@"0"] isEqualToString:@"1"];
        con.times = [obj getStringValueForKey:@"left" defaultValue:@"0"].intValue;
        con.shopId = indexShopId;
        con.gifts = [obj getArrayForKey:@"gifts"];
        [self pushViewController:con];
    }
}

- (void)shopDetialAction{
    if (!self.shop) {
        return;
    }
    ShopDetailViewController * con = [[ShopDetailViewController alloc] init];
    BusinessShop * item = [BusinessShop objWithJsonDic:_shop];
    con.sid = item.orgId;
    con.businessShop = item;
    [self pushViewController:con];
}

-(void)updateMyHead{
    if (!self.shop) {
        return;
    }
    [self setMyTitle:[self.shop objectForKey:@"orgName"]];
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSMutableArray *titleArray = [@[] mutableCopy];
    for (int i = 0; i < [self.galleries count]; ++i) {
        NSString *urlString = [(NSDictionary *)[_galleries objectAtIndex:i] objectForKey:@"imgPath"];
        NSString * description = [(NSDictionary *)[_galleries objectAtIndex:i] objectForKey:@"description"];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"!shop" withString:@""];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 163)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [viewsArray addObject:imageView];
        [titleArray addObject:description.hasValue?description:@"暂无描述！！"];
    }
    if (viewsArray.count ==0) {
        [_headScorllView removeFromSuperview];
        return;
    }
    self.headScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 163) animationDuration:viewsArray.count>1?4.0:0.0];
    self.headScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    self.headScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    NSInteger count = [viewsArray count];
    self.headScorllView.totalPagesCount = ^NSInteger(void){
        return count;
    };
    self.headScorllView.TapActionBlock = ^(NSInteger pageIndex){
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
//        imageViewer.imageSize = CGSizeMake(weakSelf.view.width, 163);
        imageViewer.delegate = weakSelf;
        [imageViewer showWithImageViews:viewsArray selectedView:[viewsArray objectAtIndex:pageIndex] viewTitles:titleArray];
        
    };
    [self.view addSubview:self.headScorllView];
}

-(void)setMyTitle:(NSString *)title{
    if (title.hasValue && title.length>1) {
        CGSize size =  [title sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(220,MAXFLOAT)];
        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attStr addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica-Bold" size:18] range:NSMakeRange(0, title.length)];
        if (title.length>12) {
            [attStr addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(0, 6)];
            [attStr addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(6, title.length-6)];
            
        }else{
            if (title.length%2==0) {
                [attStr addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(0, title.length/2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(title.length/2, title.length/2)];
            }else{
                [attStr addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(0, (title.length-1)/2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange((title.length-1)/2, title.length-(title.length-1)/2)];
            }
          
        }
        
        UILabel *titleView = [[UILabel alloc]init];
        titleView.size =size;
        titleView.attributedText = attStr;
        self.navigationItem.titleView = titleView;
    }
}

-(void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView{
    [self.headScorllView reStart];
}

#pragma mark 按钮的点击事件处理
-(void)clickHomeActBtn:(id)sender{
    NSString * promotionBadge = [homeBadge objectForKey:@"promotionBadge"];
    if (promotionBadge && ![@"0" isEqualToString:promotionBadge]) {
        [homeBadge setValue:@"0" forKey:@"promotionBadge"];
    }

    ActivityListViewController *con = [[ActivityListViewController alloc]init];
    con.shopId = [_shop objectForKey:@"id"];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)clickHomeCallBtn:(id)sender{
//    id phone = [_shop objectForKey:@"phone"];
//    if (![Globals isPhoneNumber:[NSString stringWithFormat:@"%@",phone ]]) {
//        [self showText:@"未提供电话号码"];
//        return;
//    }
//    NSArray * arr = [phone componentsSeparatedByString:@" "];
//    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:[NSString stringWithFormat:@"联系商家"] TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:arr];
//    [actionSheet show];
    client  = [[BSClient alloc] initWithDelegate:self action:@selector(requestRedEnvelopeSetingDidFinish:obj:)];
    [client getRedEnvelopeSettingByShopId:indexShopId];
}

-(void)clickHomeCargoBtn:(id)sender{
    
    NSString * wareBadge = [homeBadge objectForKey:@"wareBadge"];
    if (wareBadge && ![@"0" isEqualToString:wareBadge]) {
      [homeBadge setValue:@"0" forKey:@"wareBadge"];
    }

    WareListViewController *con = [[WareListViewController alloc] init];
    con.shopId =[_shop objectForKey:@"id"];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)clickHomeEmpBtn:(id)sender{
    
    NSString * employeeBadge = [homeBadge objectForKey:@"employeeBadge"];
    NSLog(@"====%@",employeeBadge);
    if (employeeBadge && ![@"0" isEqualToString:employeeBadge]) {
        [homeBadge setValue:@"0" forKey:@"employeeBadge"];
    }
    
//    NSMutableArray *rootControllers = [[self.tabBarController viewControllers] mutableCopy];
//    EmpListViewController *con = [[EmpListViewController alloc] init];
    OnlineAppointmentViewController *con = [[OnlineAppointmentViewController alloc] init];
//    AppointmentListViewController *con1 = [[AppointmentListViewController alloc] init];
//    con1.sourceRootControllers =
//    con.sourceRootControllers = rootControllers;
    if ([[_shop objectForKey:@"id"] hasValue]) {
        con.shopId =[_shop objectForKey:@"id"];
        [self pushViewController:con];
    }
//    BasicNavigationController *nav1 =[self CreateBaseNav:con barItemSelectedImage:LOADIMAGE(@"tabbar_icon0_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon0") TextColorForSelected:MyPinkColor barTitle:@"预约"];
//    BasicNavigationController *nav2 =[self CreateBaseNav:con1 barItemSelectedImage:LOADIMAGE(@"tabbar_icon4_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon4") TextColorForSelected:kBlueColor barTitle:@"我的"];
//    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:nav1,nav2, nil] animated:YES];
    
}

-(void)clickYunlianBtn:(id)sender{
    User * item  = [BSEngine currentEngine].user;
    if (![[EaseMob sharedInstance].chatManager isLoggedIn]) {
        NSDictionary *rect = [[EaseMob sharedInstance].chatManager loginWithUsername:item.imUsername password:@"123456" error:nil];
        if (rect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            NSLog(@"登陆环信");
        }else{
            NSLog(@"登陆环信失败");
            [self showAlert:@"聊天登陆失败！！" isNeedCancel:NO];
            return;
        }
    }
    if (!chatNavgation && !contactNavgation && !cricleNavgation) {
        NSMutableArray *rootControllers = [[self.tabBarController viewControllers] mutableCopy];
        ChatListViewController *con = [[ChatListViewController alloc] init];
        ContactListViewController *con1 = [[ContactListViewController alloc] init];
        CricleListViewController *con2 = [[CricleListViewController alloc] init];
        con1.sourceRootControllers =
        con2.sourceRootControllers =
        con.sourceRootControllers = rootControllers;
        
        chatNavgation =[self CreateBaseNav:con barItemSelectedImage:LOADIMAGE(@"huihua") withFinishedUnselectedImage:LOADIMAGE(@"huihua") TextColorForSelected:RGBCOLOR(241, 62, 102) barTitle:@"会话"];
        contactNavgation =[self CreateBaseNav:con1 barItemSelectedImage:LOADIMAGE(@"user") withFinishedUnselectedImage:LOADIMAGE(@"user") TextColorForSelected:RGBCOLOR(127, 49, 151) barTitle:@"联系人"];
        cricleNavgation =[self CreateBaseNav:con2 barItemSelectedImage:LOADIMAGE(@"yunlianquan") withFinishedUnselectedImage:LOADIMAGE(@"yunlianquan") TextColorForSelected:MygreenColor barTitle:@"云联圈"];
    }
    NSInteger numb = [[[ApplyViewController shareController] dataSource] count];
    if (numb!=0) {
        [contactNavgation.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%li",(long)numb]];
    }
   
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:cricleNavgation ,chatNavgation,contactNavgation, nil] animated:YES];
}

-(void)clickAboutBtn:(id)sender{
    ActivityListViewController *con = [[ActivityListViewController alloc]init];
    con.shopId = [_shop objectForKey:@"id"];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)clickNearShopBtn:(id)sender{
    self.tabBarController.selectedIndex = 1;
}

- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray * arr = [[_shop objectForKey:@"phone"] componentsSeparatedByString:@" "];
    if (buttonIndex == arr.count) {
        return;
    } else {
        [Globals callAction:arr[buttonIndex] parentView:self.view];
    }
}


- (void)notificationLoginChanged:(NSNotification*)notification {
    BOOL isNewCard = [[BSEngine currentEngine] isNewCard];
    [self initHomeViews:isNewCard];
    NSLog(@"登陆状态改变");
}


-(void)initHomeViews:(BOOL)isNewCard{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    if (_homeActBtn) {
        [_homeActBtn removeFromSuperview];
        _homeActBtn = nil;
    }
    if (_homeCallBtn) {
        [_homeCallBtn removeFromSuperview];
        _homeCallBtn = nil;
    }
    if (_homeCargo_btn) {
        [_homeCargo_btn removeFromSuperview];
        _homeCargo_btn = nil;
    }
    if (_homeEmpBtn) {
        [_homeEmpBtn removeFromSuperview];
        _homeEmpBtn  = nil;
    }
    if (_homeYunlianBtn) {
        [_homeYunlianBtn removeFromSuperview];
        _homeYunlianBtn = nil;
    }
    
    _homeActBtn = [[UIButton alloc]init];
    _homeCallBtn = [[UIButton alloc]init];
    _homeCargo_btn = [[UIButton alloc]init];
    _homeEmpBtn = [[UIButton alloc]init];
    _homeYunlianBtn = [[UIButton alloc]init];
    
    [self.view addSubview:_homeYunlianBtn];
    [self.view addSubview:_homeEmpBtn];
    [self.view addSubview:_homeCargo_btn];
    [self.view addSubview:_homeCallBtn];
    [self.view addSubview:_homeActBtn];
    if (ISIPHONE5) {
        [_homeCargo_btn setFrame:CGRectMake(0, 261, size.width/2, 114)];
        [_homeActBtn setFrame:CGRectMake(size.width/2, 261, size.width/2, 87)];
        [_homeEmpBtn setFrame:CGRectMake(0, 380, size.width/2, 73)];
        [_homeYunlianBtn setFrame:CGRectMake(size.width/2, 352, size.width/2,100)];
        if (isNewCard) {
            if (_homeCallBtn) {
                [_homeCallBtn removeFromSuperview];
            }
            advertisements = [[UIImageView alloc]initWithFrame:CGRectMake(0, 167, size.width, 90)];
            [advertisements setImage:[UIImage imageNamed:@"广告语言"]];
            [self.view addSubview:advertisements];
            
            [_homeActBtn setImage:[UIImage imageNamed:@"home_near_nor"] forState:UIControlStateNormal];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_severs_nor"] forState:UIControlStateNormal];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_about_nor"] forState:UIControlStateNormal];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_noral"] forState:UIControlStateNormal];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_near_press"] forState:UIControlStateHighlighted];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_severs_press"] forState:UIControlStateHighlighted];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_about_press"] forState:UIControlStateHighlighted];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_press"] forState:UIControlStateHighlighted];
            
            [_homeCargo_btn addTarget:self action:@selector(clickHomeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeActBtn addTarget:self action:@selector(clickNearShopBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeYunlianBtn addTarget:self action:@selector(clickYunlianBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeEmpBtn addTarget:self action:@selector(clickAboutBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_homeCallBtn setFrame:CGRectMake(0, 170, size.width, 86)];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_act_noral"] forState:UIControlStateNormal];
            [_homeCallBtn setImage:[UIImage imageNamed:@"home_call_noral"] forState:UIControlStateNormal];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_cargo_noral"] forState:UIControlStateNormal];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_emp_noral"] forState:UIControlStateNormal];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_noral"] forState:UIControlStateNormal];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_act_press"] forState:UIControlStateHighlighted];
            [_homeCallBtn setImage:[UIImage imageNamed:@"home_call_press"] forState:UIControlStateHighlighted];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_cargo_press"] forState:UIControlStateHighlighted];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_emp_press"] forState:UIControlStateHighlighted];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_press"] forState:UIControlStateHighlighted];
            
            [_homeActBtn addTarget:self action:@selector(clickHomeActBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeCallBtn addTarget:self action:@selector(clickHomeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeCargo_btn addTarget:self action:@selector(clickHomeCargoBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeEmpBtn addTarget:self action:@selector(clickHomeEmpBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeYunlianBtn addTarget:self action:@selector(clickYunlianBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [advertisements removeFromSuperview];
            [self.view addSubview:_homeCallBtn];
        }
    }else{
        [_homeCargo_btn setFrame:CGRectMake(0, 227, size.width/2, 73)];
        [_homeActBtn setFrame:CGRectMake(size.width/2,227, size.width/2, 59)];
        [_homeEmpBtn setFrame:CGRectMake(0, 304, size.width/2, 59)];
        [_homeYunlianBtn setFrame:CGRectMake(size.width/2, 289, size.width/2, 73.5)];
        
        if (isNewCard) {
            if (_homeCallBtn) {
                [_homeCallBtn removeFromSuperview];
            }
            advertisements = [[UIImageView alloc]initWithFrame:CGRectMake(0, 167, size.width, 57)];
            [advertisements setImage:[UIImage imageNamed:@"广告语言2"]];
            [self.view addSubview:advertisements];
            
            [_homeActBtn setImage:[UIImage imageNamed:@"home_near_s_nor"] forState:UIControlStateNormal];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_severs_s_nor"] forState:UIControlStateNormal];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_about_s_nor"] forState:UIControlStateNormal];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian2_s_nor"] forState:UIControlStateNormal];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_near_s_press"] forState:UIControlStateHighlighted];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_severs_s_press"] forState:UIControlStateHighlighted];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_about_s_press"] forState:UIControlStateHighlighted];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian2_s_press"] forState:UIControlStateHighlighted];
            [_homeCargo_btn addTarget:self action:@selector(clickHomeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeActBtn addTarget:self action:@selector(clickNearShopBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeYunlianBtn addTarget:self action:@selector(clickYunlianBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeEmpBtn addTarget:self action:@selector(clickAboutBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_homeCallBtn setFrame:CGRectMake(0, 167, size.width, 57)];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_act_noral_s"] forState:UIControlStateNormal];
            [_homeCallBtn setImage:[UIImage imageNamed:@"home_call_noral_s"] forState:UIControlStateNormal];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_cargo_noarl_s"] forState:UIControlStateNormal];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_emp_noral_s"] forState:UIControlStateNormal];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_noral_s"] forState:UIControlStateNormal];
            [_homeActBtn setImage:[UIImage imageNamed:@"home_act_press_s"] forState:UIControlStateHighlighted];
            [_homeCallBtn setImage:[UIImage imageNamed:@"home_call_press_s"] forState:UIControlStateHighlighted];
            [_homeCargo_btn setImage:[UIImage imageNamed:@"home_cargo_press_s"] forState:UIControlStateHighlighted];
            [_homeEmpBtn setImage:[UIImage imageNamed:@"home_emp_press_s"] forState:UIControlStateHighlighted];
            [_homeYunlianBtn setImage:[UIImage imageNamed:@"home_yunlian_press_s"] forState:UIControlStateHighlighted];
            
            [_homeActBtn addTarget:self action:@selector(clickHomeActBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeCallBtn addTarget:self action:@selector(clickHomeCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeCargo_btn addTarget:self action:@selector(clickHomeCargoBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeEmpBtn addTarget:self action:@selector(clickHomeEmpBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_homeYunlianBtn addTarget:self action:@selector(clickYunlianBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [advertisements removeFromSuperview];
            [self.view addSubview:_homeCallBtn];
        }
    }
    
    NSArray *qhtMembers = [BSEngine currentEngine].user.qhtMembers;
    NSArray *recommendMembers = [BSEngine currentEngine].user.recommendMembers;
    if (qhtMembers && recommendMembers && qhtMembers.count+recommendMembers.count >0) {
     [self setRightBarButtonImage:[UIImage imageNamed:@"change_member_card"] highlightedImage:nil selector:@selector(showChangeShop)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}


#pragma mark -Create BaseNav

-(BasicNavigationController *)CreateBaseNav:(BaseViewController *)con barItemSelectedImage:(UIImage *)image1 withFinishedUnselectedImage:(UIImage *)image2 TextColorForSelected:(UIColor *)color barTitle:(NSString *)name{
    BasicNavigationController* navCon = [[BasicNavigationController alloc] initWithRootViewController:con];
    UITabBarItem * barItem = nil;
    UIFont* font = [UIFont systemFontOfSize:12];
    if (Sys_Version < 7) {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:image2 tag:0];
        [barItem setFinishedSelectedImage:image1 withFinishedUnselectedImage:image2];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BkgFontColor, UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateNormal];
    } else {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:image2 selectedImage:image1];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         color, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         BkgFontColor, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        
    }
    navCon.tabBarItem = barItem;
    return navCon;
}



-(void)changeIndexShopId:(NSNotification *)notification{

    NSString *shopId = [NSString stringWithFormat:@"%@",[notification object]];
    User *user = [BSEngine currentEngine].user;
    if (shopId.hasValue) {
        indexShopId = shopId;
        user.currentShopId = shopId;
         [[BSEngine currentEngine] setCurrentUser:user password:nil tok:nil];
        
        self.shop  = nil;
    }
    [self showOrHidenShopList:user.isShowNearShop];
}

-(void)changeMemberType:(NSNotification *)notification{
     currentUserType  = [NSString stringWithFormat:@"%@",[notification object]];
}

-(void)showChangeShop{
    
    QhtShopListViewController *con = [[QhtShopListViewController alloc]init];
    con.qhtShopListDelegate = self;
    con.qhtShops = [BSEngine currentEngine].user.qhtMembers;
    con.recommendShops = [BSEngine currentEngine].user.recommendMembers;
    
    [self.navigationController pushViewController:con animated:YES];
}

-(void)qhtShopListDidSelect:(QhtShop *)shop{
    [self popViewController];
}

- (void) showOrHidenShopList:(BOOL )isShow{
    //先全部取消显示
    isShow = NO;
    NSMutableArray *viewControllers =  [[self.tabBarController viewControllers] mutableCopy];
    if (isShow) {
        if ([viewControllers count]==4) {
            BasicNavigationController *navCon = [self CreateBaseNav:[[SellerViewController alloc]init] barItemSelectedImage:LOADIMAGE(@"tabbar_icon1_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon1") TextColorForSelected:RGBCOLOR(127, 49, 151) barTitle:@"店铺"];
            [viewControllers insertObject:navCon atIndex:1];
            [self.tabBarController setViewControllers:viewControllers animated:YES];
        }
    }else{
        if ([viewControllers count]==5) {
            [viewControllers removeObjectAtIndex:1];
            [self.tabBarController setViewControllers:viewControllers];
        }
    }
}

- (void)showOrHidenManager:(BOOL )isShow{
    NSMutableArray *viewControllers =  [[self.tabBarController viewControllers] mutableCopy];
    if (isShow) {
        if ([viewControllers count]==4) {
            
            SenchaManagerViewController * con = [[SenchaManagerViewController alloc]init];
            con.url = @"http://sencha.cloudvast.com";
//            con.url = @"http://10.0.0.101/mobile/index.cloud";
//            con.url = @"http://10.0.0.101/mobile/report/cgrkdj.cloud?orgId=e5737574-6c37-46ab-aa10-f11d2ba18a73";
            BasicNavigationController *navCon = [self CreateBaseNav:con barItemSelectedImage:LOADIMAGE(@"tabbar_icon6_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon6") TextColorForSelected:RGBCOLOR(127, 49, 151) barTitle:@"管理区"];
            [viewControllers insertObject:navCon atIndex:1];
            [self.tabBarController setViewControllers:viewControllers animated:YES];
        }
    }else{
        if ([viewControllers count]==5) {
            [viewControllers removeObjectAtIndex:1];
            [self.tabBarController setViewControllers:viewControllers];
        }
    }
}

-(void)setNeedLoadHomeBadge{
    needLoadHomeBadge = YES;
}

@end


