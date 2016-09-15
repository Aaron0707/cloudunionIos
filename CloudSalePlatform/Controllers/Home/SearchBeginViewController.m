//
//  SearchBeginViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "SearchBeginViewController.h"
#import "BusinessShop.h"
#import "BannerView.h"
#import "Globals.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "ShopDetailViewController.h"
#import "BusinessShopViewCell.h"

@interface SearchBeginViewController ()<UITextFieldDelegate>  {
    BOOL beginSearch;
}

@property (nonatomic, strong) UIView * middleButtonView;
@end

@implementation SearchBeginViewController

- (void)viewDidLoad
{
    self.willShowBackButton = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setLeftBarButtonImage:LOADIMAGECACHES(@"btn_back_n") selector:@selector(popViewController)];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    self.navigationItem.titleView = titleView;
    [titleView addSubview:self.middleButtonView];
    self.tableViewCellHeight = 93;
    NSArray * arr = [[[BSEngine currentEngine] user] readValueWithKey:@"LastestSearches"];
    if (!arr) {
        arr = [NSArray array];
        [[[BSEngine currentEngine] user] saveConfigWhithKey:@"LastestSearches" value:arr];
    }
    [filterArr addObjectsFromArray:arr];
    beginSearch = NO;
    if (Sys_Version >= 7) {
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    NSString * myCode = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCode"];
    [client searchShop:_businessCategoryId districtCode:_districtCode cityCode:myCode query:_searchText page:currentPage];
    
    if (_searchText) {
        UILabel * lab = [UILabel multLinesText:_searchText font:[UIFont systemFontOfSize:14] wid:tableView.width - 10];
        lab.height += 18;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = RGBCOLOR(95, 94, 96);
        lab.left = 10;
        lab.backgroundColor = RGBCOLOR(224, 223, 221);
        lab.text = [NSString stringWithFormat:@"  当前搜素:%@", _searchText];
        tableView.tableHeaderView = lab;
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            BusinessShop * item = [BusinessShop objWithJsonDic:obj];
            [contentArr addObject:item];
        }];
        
        [filterArr addObject:_searchText];
        NSSet *set = [NSSet setWithArray:filterArr];
        [[[BSEngine currentEngine] user] saveConfigWhithKey:@"LastestSearches" value:[set allObjects]];
        [tableView reloadData];
    }
    return YES;
}

- (void)popViewController {
    [self dismissModalController:YES];
}

- (UIView *)middleButtonView {
    if (!_middleButtonView) {
        _middleButtonView = [[UIView alloc] initWithFrame:CGRectMake(10, 7, Main_Screen_Width - 85, 32)];
        _middleButtonView.backgroundColor = RGBCOLOR(254, 254, 254);
        _middleButtonView.layer.masksToBounds = YES;
        _middleButtonView.layer.cornerRadius = 2;
        _middleButtonView.layer.borderWidth =1;
        _middleButtonView.layer.borderColor = RGBCOLOR(223, 223, 223).CGColor;
        UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(35, 1, _middleButtonView.width-34, _middleButtonView.height)];
        tf.tintColor = [UIColor blackColor];
        tf.delegate = self;
        tf.returnKeyType = UIReturnKeySearch;
        tf.text = _searchText;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:17];
        tf.textColor = [UIColor blackColor];
        [_middleButtonView addSubview:tf];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"turn")];
        imageView.origin = CGPointMake(3, (_middleButtonView.height - imageView.height)/2);
        [_middleButtonView addSubview:imageView];
        [tf becomeFirstResponder];
    }
    return _middleButtonView;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!beginSearch) {
        return filterArr.count > 0?(filterArr.count+1):0;
    } else {
        return contentArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return beginSearch?self.tableViewCellHeight:44;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!beginSearch) {
        BaseTableViewCell * cell = (BaseTableViewCell*)[super tableView:sender cellForRowAtIndexPath:indexPath];
        if (indexPath.row == filterArr.count) {
            cell.textLabel.text = @"清除历史记录";
        } else {
            cell.textLabel.text = filterArr[indexPath.row];
        }
        cell.topLineView.left = 10;
        cell.imageView.hidden = YES;
        return cell;
    } else {
        static NSString * CellIdentifier = @"BusinessShopViewCell";
        if (!fileNib) {
            fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
            [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
        }
        BusinessShopViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.superTableView = sender;
        [cell setItem:[contentArr objectAtIndex:indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if (beginSearch) {
        ShopDetailViewController * con = [[ShopDetailViewController alloc] init];
        BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
        con.sid = item.orgId;
        con.businessShop = item;
        [self pushViewController:con];
    } else {
        if (indexPath.row == filterArr.count) {
            [filterArr removeAllObjects];
            [[[BSEngine currentEngine] user] saveConfigWhithKey:@"LastestSearches" value:filterArr];
            [tableView reloadData];
        } else {
            [currentInputView resignFirstResponder];
            [super startRequest];
            _searchText = filterArr[indexPath.row];
            beginSearch =
            isloadByslime = YES;
            [self prepareLoadMoreWithPage:0 maxID:0];
        }
}

}

- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath {
    BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
    return item.gallery;
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [currentInputView resignFirstResponder];
    _searchText = sender.text;
    if (_searchText.length > 0 && [super startRequest]) {
        beginSearch =
        isloadByslime = YES;
        [self prepareLoadMoreWithPage:0 maxID:0];
    }
    return YES;
}

@end
