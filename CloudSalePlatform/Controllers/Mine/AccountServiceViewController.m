//
//  AccountServiceViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "AccountServiceViewController.h"
#import "QhtShopViewCell.h"
#import "QhtShop.h"
#import "ServiceDetailViewController.h"

@interface AccountServiceViewController ()

@end

@implementation AccountServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的会员卡";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.width-10, 40)];
    titleLabel.text = @"点击会员卡片查看详情";
    titleLabel.textColor = MyPinkColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:titleLabel];
    tableView.tableHeaderView = titleLabel;
    tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    NSArray *qhtMembers = [BSEngine currentEngine].user.qhtMembers;
    [contentArr addObjectsFromArray:qhtMembers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (isFirstAppear && [super startRequest]) {
//        [client findFavoritedShop:currentPage isFav:NO];
//    }
    [tableView reloadData];
}

//- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
//    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray * list = [obj getArrayForKey:@"list"];
//        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
//            BusinessShop * item = [BusinessShop objWithJsonDic:obj];
//            [contentArr addObject:item];
//        }];
//        [tableView reloadData];
//    }
//    return YES;
//}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"QhtShopViewCell";
    if (!fileNib) {
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
    }
    QhtShopViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    QhtShop * item = contentArr[indexPath.row];
//    cell.superTableView = sender;
//    [cell setTopLine:NO];
//    [cell update:^(NSString *name) {
//        cell.imageView.frame = CGRectMake(15, 12, cell.width - 30, cell.height-12);
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.frame = CGRectMake(15, cell.imageView.height - 18, cell.width - 30, 30);
//        cell.textLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        BusinessShop * item = contentArr[indexPath.row];
//        cell.textLabel.text = item.orgName;
//        [cell.contentView bringSubviewToFront: cell.textLabel];
//    }];
    NSLog(@"shopname %@",item.shopName);
    [cell setItem:item];
    [cell setImageViewForCoume:indexPath.row mark:NO];
    return cell;
}

- (void)tableView:(id)sender didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    QhtShop * item = contentArr[indexPath.row];
    ServiceDetailViewController * con = [[ServiceDetailViewController alloc] init];
    con.memberId = item.ID;
    [self pushViewController:con];
}

//- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath {
//    BusinessShop * item = contentArr[indexPath.row];
//    return item.gallery;
//}

@end
