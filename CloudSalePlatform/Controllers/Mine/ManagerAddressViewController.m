//
//  ManagerAddressViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/29.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "ManagerAddressViewController.h"
#import "UpdateAddressViewController.h"
#import "BaseTableViewCell.h"
#import "AddressItem.h"
#import "UIButton+NSIndexPath.h"

@interface ManagerAddressViewController ()

@end

@implementation ManagerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地址管理";
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, mainBounds.size.height-115, tableView.width, 50)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame =CGRectMake((tableView.width-120)/2, 10, 120, 30);
    [addButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addButton setTitleColor:MyPinkColor forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addButton];
    
    [self.view addSubview:footerView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([super startRequest]) {
        [client findAddressItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - requestDidFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj objectForKey:@"list"];
        [contentArr removeAllObjects];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AddressItem * item = [AddressItem objWithJsonDic:obj];
            [contentArr addObject:@[item]];
        }];
        [tableView reloadData];
    }
    return YES;
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return contentArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel * nameLabel = VIEWWITHTAG(cell.contentView, 100);
    UILabel * phoneLabel = VIEWWITHTAG(cell.contentView,101);
    UIImageView * line  = VIEWWITHTAG(cell.contentView, 102);
    UILabel * addressLabel = VIEWWITHTAG(cell.contentView, 103);
    UIButton *eidtButton  = VIEWWITHTAG(cell.contentView, 104);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (tableView.width-40)/3, 20)];
        nameLabel.numberOfLines  = 1;
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        nameLabel.tag = 100;
        [cell.contentView addSubview:nameLabel];
        
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width-40)/3+20, 10, (tableView.width-40)/3, 20)];
        phoneLabel.numberOfLines  = 1;
        [phoneLabel setFont:[UIFont systemFontOfSize:14]];
        [phoneLabel setTextAlignment:NSTextAlignmentCenter];
        phoneLabel.tag = 101;
        [cell.contentView addSubview:phoneLabel];
        
        eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(tableView.width-40, 5, 30, 30)];
        eidtButton.tag = 104;
        [eidtButton setBackgroundImage:[UIImage imageNamed:@"pinkPencel"] forState:UIControlStateNormal];
        [eidtButton addTarget:self action:@selector(editAddressItem:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:eidtButton];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 1)];
        [line setImage:[UIImage imageNamed:@"change_card_cellline"]];
        line.tag = 102;
        [cell.contentView addSubview:line];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 50)];
        addressLabel.numberOfLines  = 2;
        [addressLabel setFont:[UIFont systemFontOfSize:14]];
        addressLabel.tag = 103;
        [cell.contentView addSubview:addressLabel];
    }
    eidtButton.indexPath = indexPath;
    
    cell.imageView.hidden = YES;
    
    AddressItem * item = [contentArr objectAtIndex:indexPath.section][0];
    nameLabel.text =item.receiverName;
    phoneLabel.text = item.receiverPhone;
    addressLabel.text = item.receiverAddress;
    
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressItem * item = [contentArr objectAtIndex:indexPath.section][0];
    if ([_delegate respondsToSelector:@selector(managerAddressCheckedAddress:)]) {
        [_delegate performSelector:@selector(managerAddressCheckedAddress:) withObject:item];
        [self popViewController];
    }
    
}

#pragma mark - Util
- (void)addAddress:(UIButton *)button{
    UpdateAddressViewController * update = [[UpdateAddressViewController alloc]init];
    [self pushViewController:update];
}

- (void)editAddressItem:(UIButton *)button{
    UpdateAddressViewController * update = [[UpdateAddressViewController alloc]init];
    AddressItem * item = [contentArr objectAtIndex:button.indexPath.section][0];
    update.item =item;
    [self pushViewController:update];
}
@end
