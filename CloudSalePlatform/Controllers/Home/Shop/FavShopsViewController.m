//
//  FavShopsViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "FavShopsViewController.h"
#import "BusinessShop.h"
#import "BusinessShopViewCell.h"
#import "ShopDetailViewController.h"

@interface FavShopsViewController ()

@end

@implementation FavShopsViewController
@synthesize isFav;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = isFav?@"收藏商家":@"绑定商家";
    self.tableViewCellHeight = 93;
    needToLoad = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [self setLoading:YES content:[NSString stringWithFormat:@"正在获取%@",self.navigationItem.title]];
        [client findFavoritedShop:currentPage isFav:isFav];
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            BusinessShop * item = [BusinessShop objWithJsonDic:obj];
            [contentArr addObject:item];
        }];
        [tableView reloadData];
    }
    return YES;
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
    [cell setItem:[contentArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailViewController * con = [[ShopDetailViewController alloc] init];
    BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
    con.businessShop = item;
    con.sid = item.orgId;
    [self pushViewController:con];
}

- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath {
    BusinessShop * item = [contentArr objectAtIndex:indexPath.row];
    return item.gallery;
}

@end
