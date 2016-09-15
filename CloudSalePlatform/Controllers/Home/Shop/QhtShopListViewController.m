//
//  QhtShopListViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "QhtShopListViewController.h"
#import "QhtShopViewCell.h"
#import "QhtShopViewCell2.h"
#import "QhtShop.h"

@interface QhtShopListViewController ()

@end

@implementation QhtShopListViewController

- (void)viewDidLoad {
    super.willShowBackButton = NO;
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择会员卡";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width-10, 40)];
    titleLabel.text = @"你在云联平台有多张会员卡请选择一张作为首页展示";
    titleLabel.textColor = MyPinkColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableArray * allShops = [NSMutableArray array];
    [allShops addObjectsFromArray:[self.qhtShops copy]];
    [allShops addObjectsFromArray:[self.recommendShops copy]];
    contentArr = [allShops mutableCopy];
    [tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isQhtShop = !(indexPath.row+1 > self.qhtShops.count);
    if (isQhtShop) {
        static NSString * CellIdentifier = @"QhtShopViewCell";
//        if (!fileNib) {
            fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
            [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
//        }
        QhtShopViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        QhtShop *shop = [contentArr objectAtIndex:indexPath.row];
        [cell setItem:shop];
        [cell setImageViewForCoume:indexPath.row mark:indexPath.row+1 > self.qhtShops.count];
        return cell;
    }else{
        static NSString * CellIdentifier = @"QhtShopViewCell2";
//        if (!fileNib) {
            fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
            [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
//        }
        QhtShopViewCell2 * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        QhtShop *shop = [contentArr objectAtIndex:indexPath.row];
        [cell setItem:shop];
        [cell setImageViewForCoume:indexPath.row mark:indexPath.row+1 > self.qhtShops.count];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathz{
    return  135;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QhtShop *shop = [contentArr objectAtIndex:indexPath.row];
    
    [[BSEngine currentEngine] setUserIsShowNearShop:shop.isOpenUnion];
    [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
    if (_qhtShopListDelegate && [_qhtShopListDelegate respondsToSelector:@selector(qhtShopListDidSelect:)]) {
        [_qhtShopListDelegate qhtShopListDidSelect:shop];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberCard object:shop.shopId];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
