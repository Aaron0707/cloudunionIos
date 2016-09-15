//
//  SellerViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "SellerViewController.h"
#import "ImageTouchView.h"
#import "BusinessShop.h"
#import "BannerView.h"
#import "Globals.h"
#import "BusinessShopViewCell.h"
#import "ShopDetailViewController.h"
#import "MenuView.h"
#import "BasicNavigationController.h"
#import "CityPositioningViewController.h"
#import "HeaderButtonsView.h"
#import "BusinessCategory.h"
#import "District.h"
#import "LocationManager.h"
#import "UIImage+FlatUI.h"
#import "SearchBeginViewController.h"

@interface SellerViewController ()<ImageTouchViewDelegate, MenuViewDelegate, UITextFieldDelegate, HeaderButtonDelegate> {
    UILabel     * cityLab;
    UIView      * titleView;
    NSString    * myCity;
    NSString    * myCode;
    UIView      * headerView;
    UILabel     * labelLocation;
    ImageTouchView * refreshImage;
}

@property (nonatomic, strong) NSMutableArray   * districtAaray;
/**
 *  选中的行业类型；nil为全部
 *
 */
@property (nonatomic, strong) BusinessCategory * selectedBusinessCategory;
/**
 *  选中的城市区域；nil为全部
 *
 */
@property (nonatomic, strong) District * selectedDistrict;
/**
 *  名称滑动交互层，传递用户在名称层的交互
 *
 */
@property (nonatomic, strong) HeaderButtonsView  * headerButtonsView;
/**
 *  筛选目录显示层，传递用户筛选的交互
 *
 */
@property (nonatomic, strong) MenuView * menuView;

@property (nonatomic, strong) ImageTouchView * leftButton;
@property (nonatomic, strong) ImageTouchView * middleButtonView;
@end

@implementation SellerViewController

- (void)dealloc {
    // test
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self enableSlimeRefresh];
    //    [self.view addSubview:self.headerButtonsView];
    [LocationManager sharedManager].located = YES;
    [[LocationManager sharedManager] startUpdatingLocation];
    _selectedBusinessCategory = [[BSEngine currentEngine] categoryArray][0];
    self.districtAaray = [NSMutableArray array];
    self.tableViewCellHeight = 93;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 38)];
    tableView.tableHeaderView = headerView;
    headerView.backgroundColor = RGBCOLOR(240, 239, 237);
    
    NSString * str = [NSString stringWithFormat:@"当前: %@", [[LocationManager sharedManager] locationText]?[[LocationManager sharedManager] locationText]:@"定位中"];
    labelLocation = [UILabel linesText:str font:[UIFont systemFontOfSize:14] wid:tableView.width lines:1 color:[UIColor grayColor]];
    labelLocation.frame = CGRectMake(10, 0, tableView.width - 20, 38);
    labelLocation.textAlignment = NSTextAlignmentLeft;
    labelLocation.backgroundColor = RGBCOLOR(240, 239, 237);
    [headerView addSubview:labelLocation];
    
    refreshImage = [[ImageTouchView alloc] initWithFrame:CGRectMake(tableView.width - 36, (headerView.height - 16)/2, 16, 16) delegate:self];
    refreshImage.image = LOADIMAGE(@"icon_refresh");
    refreshImage.tag = @"refresh";
    [headerView addSubview:refreshImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateNotification:) name:LocationUpdateNotification object:nil];
    needToLoad = NO;
    [self updateleftBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    myCity = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCity"];
    myCode = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCode"];
    
    NSString * str = [NSString stringWithFormat:@"当前: %@", [[LocationManager sharedManager] locationText]?[[LocationManager sharedManager] locationText]:@"定位中"];
    labelLocation.text = str;
    
    if (!myCode || !myCity) {
        CityPositioningViewController * con = [[CityPositioningViewController alloc] init];
        BasicNavigationController *subNav = [[BasicNavigationController alloc] initWithRootViewController:con];
        [self presentViewController:subNav animated:YES completion:nil];
    }else{
        if (isFirstAppear && myCode.hasValue) {
            if ([super startRequest]) {
                [self setLoading:YES content:@"正在获取商家列表"];
                [client searchShop:nil districtCode:myCode cityCode:myCode query:nil page:currentPage];
            }
        }
        cityLab.text = myCity;
    }
    
    _leftButton.delegate = self;
    _middleButtonView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChangeNotification:) name:LocationChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =RGBCOLOR(127, 49, 151);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _leftButton.delegate = nil;
    _middleButtonView.delegate = nil;
}

- (void)locationUpdateNotification:(NSNotification*)sender {
    NSString * str = [[LocationManager sharedManager] locationText];
    str = [NSString stringWithFormat:@"当前: %@", str];
    labelLocation.text = str;
    refreshImage.userInteractionEnabled = YES;
    
    [refreshImage stopRotateAnimation];
}

/**
 *切换城市选择后，刷新数据
 */
- (void)locationChangeNotification:(NSNotification *)sender {
    myCity = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCity"];
    if (!myCity || [myCity isEqualToString:@"定位中"]) {
        [self.tabBarController setSelectedIndex:0];
        return;
    }
    if (!isFirstAppear && [super startRequest]) {
        currentPage = 1;
        isloadByslime = YES;
        myCode = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCode"];
        cityLab.text = myCity;
        [self setLoading:YES content:@"正在切换商家列表"];
        // 默认全城，商圈id为城市id
        [client searchShop:nil districtCode:myCode cityCode:myCode query:nil page:currentPage];
        _selectedDistrict = nil;
        _selectedBusinessCategory = [[BSEngine currentEngine] categoryArray][0];
        _headerButtonsView.nameArray = @[_selectedBusinessCategory?_selectedBusinessCategory.name:@"全部分类",@"全城"];
    }
}

- (void)disableButton:(BOOL)dis {
    headerView.userInteractionEnabled =
    tableView.userInteractionEnabled =
    titleView.userInteractionEnabled = !dis;
    if (!dis) {
        [_headerButtonsView resetallStatus];
    }
}

- (void)updateleftBtn {
    UIFont * font = [UIFont boldSystemFontOfSize:14];
    cityLab = [UILabel linesText:@"请选择" font:font wid:42 lines:1 color:BkgSkinColor];
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    self.navigationItem.titleView = titleView;
    [titleView addSubview:self.leftButton];
    [titleView addSubview:self.middleButtonView];
    self.navigationItem.titleView = titleView;
    if (myCity.hasValue) {
        cityLab.text = myCity;
    }
}

- (ImageTouchView *)leftButton {
    if (!_leftButton) {
        UIImage * img = LOADIMAGECACHES(@"arrow_down");
        _leftButton = [[ImageTouchView alloc] initWithFrame:CGRectMake(0, 13, cityLab.width + 4 + img.size.width*1.2, 18) delegate:self];
        _leftButton.tag = @"_leftButton";
        [_leftButton addSubview:cityLab];
        UIImageView * image = [[UIImageView alloc] initWithImage:img];
        image.left = cityLab.width + 4;
        image.top = (_leftButton.height - image.height)/2;
        image.size = CGSizeMake(image.width*1.2, image.height*1.2);
        [_leftButton addSubview:image];
    }
    return _leftButton;
}

- (ImageTouchView *)middleButtonView {
    if (!_middleButtonView) {
        _middleButtonView = [[ImageTouchView alloc] initWithFrame:CGRectMake(cityLab.right+30, 7, titleView.width - cityLab.right-50, 28) delegate:self];
        _middleButtonView.tag = @"_middleButtonView";
        //        _middleButtonView.backgroundColor = RGBCOLOR(0, 149, 181);
        _middleButtonView.layer.masksToBounds = YES;
        _middleButtonView.layer.cornerRadius = 6;
        _middleButtonView.layer.borderWidth = 1;
        _middleButtonView.layer.borderColor = BkgSkinColor.CGColor;
        UILabel * lab = [UILabel linesText:@"输入商户名，地点" font:[UIFont boldSystemFontOfSize:15] wid:160 lines:0 color:[UIColor grayColor]];
        lab.left = 30;lab.height = 28;
        [_middleButtonView addSubview:lab];
        UIImageView * imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor colorWithPatternImage:LOADIMAGE(@"turn")]];
        //        imageView.origin = CGPointMake(2, 2);
        imageView.frame = CGRectMake(2, 2, 24, 24);
        [_middleButtonView addSubview:imageView];
    }
    return _middleButtonView;
}

- (HeaderButtonsView *) headerButtonsView {
    if (!_headerButtonsView) {
        _headerButtonsView = [[HeaderButtonsView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
        _headerButtonsView.buttonTitleColor = [UIColor clearColor];
        _headerButtonsView.nameArray = @[_selectedBusinessCategory?_selectedBusinessCategory.name:@"全部分类",@"全城"];
        _headerButtonsView.backgroundColor = RGBCOLOR(253, 253, 253);
        if (Sys_Version >= 7) {
            //            _headerButtonsView.top += 64;
            tableView.top += _headerButtonsView.height;
            tableView.height -= _headerButtonsView.height;
        }
        _headerButtonsView.delegate = self;
    }
    return _headerButtonsView;
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    if (isloadByslime) {
        [self setLoading:YES content:@"正在重新获取商家列表"];
    } else {
        [self setLoading:YES content:@"正在加载更多商家"];
    }
    [client searchShop:_selectedBusinessCategory?_selectedBusinessCategory.id:nil districtCode:_selectedDistrict.code cityCode:myCode query:nil page:page];
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            BusinessShop * item = [BusinessShop objWithJsonDic:obj];
            [contentArr addObject:item];
        }];
        [tableView reloadData];
        if (!_selectedDistrict) {
            self.loading = YES;
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestfoundDidFinish:obj:)];
            [client findDistrict:myCode];
        }
        
    }
    return YES;
}

- (void)requestfoundDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [[self districtAaray] removeAllObjects];
        District * myCityDistrict = [[District alloc] init];
        myCityDistrict.name = @"全城";
        myCityDistrict.code = myCode;
        [[self districtAaray] addObject:myCityDistrict];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            District * item = [District objWithJsonDic:obj];
            [[self districtAaray] addObject:item];
        }];
        if (_districtAaray.count > 0) {
            _selectedDistrict = _districtAaray[0];
        }
        _headerButtonsView.nameArray = @[_selectedBusinessCategory?_selectedBusinessCategory.name:@"全部分类",_selectedDistrict.name];
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BusinessShopViewCell";
    if (!fileNib) {
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
    }
    BusinessShopViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.superTableView = sender;
    cell.indexPath = indexPath;
    [cell setItem:[contentArr objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailViewController * con = [[ShopDetailViewController alloc] init];
    BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
    con.sid = item.orgId;
    con.businessShop = item;
    [self pushViewController:con];
}

- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath {
    BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
    return item.gallery;
}

#pragma mark - MenuViewDelegate
- (void)popoverView:(MenuView *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (sender.tag == 0) {
        _selectedBusinessCategory = [[BSEngine currentEngine] categoryArray][buttonIndex];
    } else {
        _selectedDistrict = _districtAaray[buttonIndex];
    }
    _headerButtonsView.nameArray = @[_selectedBusinessCategory.name,_selectedDistrict.name];
    if ([super startRequest]) {
        isloadByslime = YES; 
        currentPage = 1;
        [self setLoading:YES content:@"正在加载商家列表"];
        [client searchShop:_selectedBusinessCategory.id districtCode:_selectedDistrict.code cityCode:myCode query:nil page:currentPage];
    }
    [self disableButton:NO];
}

- (void)popoverViewCancel:(MenuView *)sender {
    [self disableButton:NO];
}

#pragma mark - imageTouchViewDelegate
- (void)imageTouchViewDidSelected:(ImageTouchView*)sender {
    if ([sender.tag isEqualToString:@"_leftButton"]) {
        CityPositioningViewController * con = [[CityPositioningViewController alloc] init];
        BasicNavigationController *subNav = [[BasicNavigationController alloc] initWithRootViewController:con];
        [self presentViewController:subNav animated:YES completion:nil];
    } else if ([sender.tag isEqualToString:@"refresh"]) {
        sender.userInteractionEnabled = NO;
        if ([[LocationManager sharedManager] located]) {
            [[LocationManager sharedManager] startUpdatingLocation];
        }
        [sender startRotateAnimation];
        
    } else if ([sender.tag isEqualToString:@"_middleButtonView"]) {
        SearchBeginViewController * con = [[SearchBeginViewController alloc] init];
        con.businessCategoryId = _selectedBusinessCategory.id;
        con.districtCode = _selectedDistrict.code;
        BasicNavigationController * nav = [[BasicNavigationController alloc] initWithRootViewController:con];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)selectedButtonAtIdx:(NSInteger)selected {
    MenuView * menu = [[MenuView alloc] initWithButtonTitles:(selected == 0)?[[BSEngine currentEngine] categoryArray]:((NSArray*)self.districtAaray) withDelegate:self];
    [menu showInView:self.view origin:CGPointMake(((selected == 0)?0:Main_Screen_Width/2), self.headerButtonsView.bottom)];
    menu.tag = selected;
    [self disableButton:YES];
}
@end
