//
//  UpdateAddressViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/29.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "UpdateAddressViewController.h"
#import "BaseTableViewCell.h"
#import "AddressItem.h"
#import "TextInput.h"
#import "CityStreamControlViewController.h"
#import "BasicNavigationController.h"

@interface UpdateAddressViewController ()<CityStreamDelegate,UITextViewDelegate>{
    NSString * receiverDistrictCode;
    
    UIButton *saveButton;
    
    UIButton *deleteButton;
}

@end

@implementation UpdateAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"编辑收货人";
    tableView.height = 220;
    saveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, tableView.bottom+ 20, tableView.width-40, 40)];
    [saveButton commonStyle];
    [saveButton setTitle:@"保存收货地址" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    deleteButton =[[UIButton alloc]initWithFrame:CGRectMake(20, saveButton.bottom+ 20, tableView.width-40, 40)];
    [deleteButton pinkStyle];
    [deleteButton addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"删除收货地址" forState:UIControlStateNormal];
    [self.view addSubview:deleteButton];
    
    saveButton.hidden =
    deleteButton.hidden = YES;
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //处理数据。
    if(isFirstAppear){
        receiverDistrictCode = _item.receiverDistrictCode;
        [contentArr addObject:_item?(_item.receiverDistrictName):@"所在地区"];
        [contentArr addObject:_item?(_item.receiverName):@""];
        [contentArr addObject:_item?(_item.receiverPhone):@""];
        [contentArr addObject:_item?(_item.receiverAddress):@""];
        [tableView reloadData];
    }
    saveButton.hidden = NO;
    if (_item) {
        deleteButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - requestDidFinsh
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self popViewController];
    }
    return YES;
}

-(void)requestDeleteDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self popViewController];
    }
}

#pragma mark -tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==3) {
        return 60;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    KTextView * filed = VIEWWITHTAG(cell.contentView, 100);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        filed = [[KTextView alloc] initWithFrame:CGRectMake(10, 5, cell.width-20, 30)];
        filed.delegate = self;
        filed.tag = 100;
        [filed setFont:[UIFont systemFontOfSize:16]];
        if (indexPath.row == 0) {
            filed.hidden = YES;
            [cell addArrowRight];
        }else if (indexPath.row == 1) {
            filed.placeholder = @"名称";
        }else if (indexPath.row ==2){
            filed.placeholder = @"电话";
        }else if (indexPath.row == 3){
            filed.height = 50;
            filed.placeholder = @"地址信息";
        }
        [cell.contentView addSubview:filed];
    }
    cell.imageView.hidden = YES;
    filed.tag = indexPath.row;
    [filed setplaceholderTextAlignment:NSTextAlignmentLeft];
    filed.text = [contentArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = [contentArr objectAtIndex:indexPath.row];
    }
    [cell update:^(NSString *name) {
        if (indexPath.row == 0) {
            cell.textLabel.left = 20;
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        CityStreamControlViewController * con = [[CityStreamControlViewController alloc]init];
        con.delegate = self;
        BasicNavigationController *subNav = [[BasicNavigationController alloc] initWithRootViewController:con];
        [self presentViewController:subNav animated:YES completion:nil];
    }
}


-(void)cityStreamControlDidFinish:(NSString *)fullName districtCode:(NSString *)code{
    receiverDistrictCode = code;
    [contentArr removeObjectAtIndex:0];
    [contentArr insertObject:fullName atIndex:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@" b  %@ tag%li",textView.text,(long)textView.tag);
    [contentArr removeObjectAtIndex:textView.tag];
    [contentArr insertObject:textView.text atIndex:textView.tag];
}

#pragma  mark -Util

- (void)saveAddress:(UIButton *)button{
    if (!_item) {
        _item = [[AddressItem alloc]init];
    }
    _item.receiverDistrictCode = receiverDistrictCode;
    _item.receiverAddress = [contentArr objectAtIndex:3];
    _item.receiverName = [contentArr objectAtIndex:1];
    _item.receiverPhone = [contentArr objectAtIndex:2];
    
    if (!_item.receiverName.hasValue || !_item.receiverDistrictCode.hasValue || !_item.receiverAddress.hasValue) {
        [self showText:@"请填写完整的地址信息"];
    }else{
        [super startRequest];
        [self setLoading:YES];
        [client createOrDeleteAddress:_item];
    }
}

- (void)deleteAddress:(UIButton *)button{
    if (!_item.ID.hasValue) {
        [self showText:@"数据异常"];
    }else{
        client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDeleteDidFinish:obj:)];
        [client deleteAddressById:_item.ID];
    }
    
}

@end
