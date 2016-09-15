//
//  UserTypeViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/23.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "UserTypeViewController.h"
#import "UserType.h"
#import "UserTypeViewCell.h"
#import "QhtShopListViewController.h"

@interface UserTypeViewController ()

@end

@implementation UserTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"会员身份";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [contentArr addObjectsFromArray:_userTypes];
    [tableView reloadData];
}

#pragma mark - TableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"UserTypeViewCell";
    if (!fileNib) {
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
    }
    UserTypeViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    UserType *type = [contentArr objectAtIndex:indexPath.row];
    [cell setItem:type];
    
    [cell update:^(NSString *name) {
        NSString * typestr = type.type;
        if ([typestr isEqualToString:@"QHT_ORG"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"QHT_ORG"]];
        }else if ([typestr isEqualToString:@"JXC_PRODUCT_ORG"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"JXC_PRODUCT_ORG"]];
        }else if ([typestr isEqualToString:@"JXC_ORG"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"JXC_ORG"]];
        }else{
            [cell.imageView setImage:[UIImage imageNamed:@"UserType_Head"]];
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserType *type = [contentArr objectAtIndex:indexPath.row];
      
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberType object:type.type];
    
    if (_gotoQhtShopList) {
        [self showChangeShop:_qhtMembers recommendShop:_recommendMembers];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)showChangeShop:(NSArray *)qhtMemberArry recommendShop:(NSArray *)recommendShops{
    
    QhtShopListViewController *con = [[QhtShopListViewController alloc]init];
    con.qhtShops = qhtMemberArry;
    con.recommendShops  = recommendShops;
    
    [self.navigationController pushViewController:con animated:YES];
}

@end
