//
//  OnlineConsumeViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/8.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "OnlineConsumeViewController.h"
#import "OnlineConsumeViewCell.h"
#import "OnlineBill.h"
#import "BaseTableViewCell.h"
#import "WareDetailViewController.h"
#import "BuyWareViewController.h"
#import "UIImage+FlatUI.h"
#import "CartItemAndBillItem.h"
#import "PaymentViewController.h"

@interface OnlineConsumeViewController ()<BuyAgainDelegate>{
    NSString * currentStatus;
    
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
}
@end

@implementation OnlineConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在线消费";
    [tableView setBackgroundColor:[UIColor clearColor]];

    [self setRightBarButton:@"全部订单" selector:@selector(searchAllBill:)];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIView *buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 40)];
    [buttonsView setBackgroundColor:kBlueColor];
    
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, rect.size.width/5-2, 40)];
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width/5-2, 0, rect.size.width/5-2, 40)];
    button3 = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width/5-2)*2, 0, rect.size.width/5-2, 40)];
    button4 = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width/5-2)*3, 0, rect.size.width/5-2, 40)];
    button5 = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width/5-2)*4, 0, rect.size.width/5+8, 40)];
    
    [button1 setTitle:@"待付款" forState:UIControlStateNormal];
    [button2 setTitle:@"待发货" forState:UIControlStateNormal];
    [button3 setTitle:@"待收货" forState:UIControlStateNormal];
    [button4 setTitle:@"待评价" forState:UIControlStateNormal];
    [button5 setTitle:@"退款/售后" forState:UIControlStateNormal];
    button1.titleLabel.font =
    button2.titleLabel.font =
    button3.titleLabel.font =
    button4.titleLabel.font =
    button5.titleLabel.font = [UIFont systemFontOfSize:14];
    button1.tag = 1;
    button2.tag = 2;
    button3.tag = 3;
    button4.tag = 4;
    button5.tag = 5;
    button1.selected = YES;
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button3 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button4 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button5 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    
    [button1 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsView addSubview:button1];
    [buttonsView addSubview:button2];
    [buttonsView addSubview:button3];
    [buttonsView addSubview:button4];
    [buttonsView addSubview:button5];
    
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, rect.size.width, 10)];
//    [line setBackgroundColor:self.view.backgroundColor];
//    [self.view addSubview:line];
    tableView.top +=40;
    tableView.height -=40;
    [self.view addSubview:buttonsView];
    
    currentStatus = @"NOT_PAYED";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isFirstAppear && [super startRequest]) {
        [client findBillByStatus:currentStatus page:currentPage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            OnlineBill *consume = [OnlineBill objWithJsonDic:obj];
            [contentArr addObject:consume];
        }];
        
        [tableView reloadData];
    }
    return YES;
}

- (void)requestWareDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        Ware *ware = [Ware objWithJsonDic:[obj objectForKey:@"ware"]];
        BuyWareViewController *con  = [[BuyWareViewController alloc] init];
        con.item = ware;
        [self pushViewController:con];
    }
}

-(void)requestBillsDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        [contentArr removeAllObjects];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            OnlineBill  * bill = [OnlineBill objWithJsonDic:obj];
            [contentArr addObject:bill];
        }];
        [tableView reloadData];
    }
}

-(void)requestDeleteBillDidFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        [tableView reloadData];
//    }
}


#pragma mark -tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return contentArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OnlineBill * bill = [contentArr objectAtIndex:section];
    return bill.items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)sender viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, sender.width, 40)];
    [headerView setBackgroundColor:[UIColor whiteColor]];

    OnlineBill * bill = [contentArr objectAtIndex:section];
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    if ([bill.status isEqualToString:@"NOT_PAYED"]) {
        statusLabel.text = @"未付款";
    }else if ([bill.status isEqualToString:@"PART_PAYED"]) {
        statusLabel.text = @"部分付款";
    }else if ([bill.status isEqualToString:@"ALL_PAYED"]) {
        statusLabel.text = @"已付款";
    }else if ([bill.status isEqualToString:@"NOT_SEND"]) {
        statusLabel.text = @"未发货";
    }else if ([bill.status isEqualToString:@"SENT"]) {
        statusLabel.text = @"已发货";
    }else if ([bill.status isEqualToString:@"RECEIVED"]) {
        statusLabel.text = @"已收货";
    }else if ([bill.status isEqualToString:@"COMMENTED"]) {
        statusLabel.text = @"已评价";
    }else if ([bill.status isEqualToString:@"REJECTED"]) {
        statusLabel.text = @"退货";
    }
    UILabel * billNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, tableView.width-120, 20)];
    billNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",bill.billNumber];
    
    statusLabel.font = [UIFont systemFontOfSize:16];
    billNumberLabel.font = [UIFont systemFontOfSize:14];
    [billNumberLabel setTextColor:MygrayColor];
    [billNumberLabel setTextAlignment:NSTextAlignmentRight];
    
    [headerView addSubview:statusLabel];
    [headerView addSubview:billNumberLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 0.5)];
    lineView.image =
    lineView.highlightedImage = LOADIMAGECACHES(@"bkg_gray_line");
    [headerView addSubview:lineView];
    
//    if (section !=0) {
        UIView * bigViwe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
        [bigViwe setBackgroundColor:self.view.backgroundColor];
        [bigViwe addSubview: headerView];
        return bigViwe;
//    }

    return headerView;
}

-(UIView *)tableView:(UITableView *)sender viewForFooterInSection:(NSInteger)section{
    OnlineBill * bill = [contentArr objectAtIndex:section];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    UILabel * totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 160, 20)];
    NSString *text = [NSString stringWithFormat:@"合计：%.2f元",bill.totalPrice.doubleValue];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [attStr addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(3, text.length-3)];
    totalPriceLabel.attributedText = attStr;
    [footerView addSubview:totalPriceLabel];
    
    if (![@"NOT_PAYED" isEqualToString:currentStatus]) {
        return footerView;
    }
    
    UIButton * cancelBillBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.width-160, 5, 70, 30)];
    cancelBillBtn.tag = section;
    [cancelBillBtn pinkBorderStyle];
    [cancelBillBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBillBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    
    UIButton * paymentBillBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.width-80, 5, 70, 30)];
    paymentBillBtn.tag = section;
    [paymentBillBtn pinkStyle];
    [paymentBillBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [paymentBillBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    
    [cancelBillBtn addTarget:self action:@selector(cancelBillAction:) forControlEvents:UIControlEventTouchUpInside];
    [paymentBillBtn addTarget:self action:@selector(paymentBillAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:cancelBillBtn];
    [footerView addSubview:paymentBillBtn];
    
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.topLine = NO;
        cell.bottomLine = YES;
    }
    OnlineBill * bill = [contentArr objectAtIndex:indexPath.section];
    CartItemAndBillItem *item = [bill.items objectAtIndex:indexPath.row];
 
    cell.textLabel.text = item.wareName;
    
    [cell update:^(NSString *name) {
        cell.bottomLineView.width-=20;
        cell.bottomLineView.left = 10;
        cell.textLabel.numberOfLines = 2;
    }];
    
    return cell;
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    OnlineBill * bill = [contentArr objectAtIndex:indexPath.section];
    CartItemAndBillItem *item = [bill.items objectAtIndex:indexPath.row];
    
    return item.picture;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     [sender deselectRowAtIndexPath:indexPath animated:YES];
//    OnlineConsume *cousume = [contentArr objectAtIndex:indexPath.row];
//    WareDetailViewController *con  = [[WareDetailViewController alloc] init];
//    con.wareId = cousume.wareId;
//    [self pushViewController:con];
}



#pragma mark - Util
-(void)searchAllBill:(UIButton *)button{
    
}

-(void)cancelBillAction:(UIButton *)button{
    NSInteger index = button.tag;
    OnlineBill *bill = [contentArr objectAtIndex:index];
    
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDeleteBillDidFinish:obj:)];
    [client deleteBillById:bill.ID];
    
    [contentArr removeObject:bill];
    
    [tableView deleteSections: [NSIndexSet indexSetWithIndex: index] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)paymentBillAction:(UIButton *)button{
    NSInteger index = button.tag;
    OnlineBill * bill = [contentArr objectAtIndex:index];
    PaymentViewController * con = [[PaymentViewController alloc]init];
    con.billId = bill.ID;
    [self pushViewController:con];
}

-(void)buyAgain:(NSString *)wareId{
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestWareDidFinish:obj:)];
    [client findWareWithId:wareId];
}

-(void)findBillByType:(UIButton *)button{
    if (button.selected) {
        return;
    }
    currentPage = 1;
    button.selected = !button.selected;
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestBillsDidFinish:obj:)];
    switch (button.tag) {
        case 1:
            currentStatus = @"NOT_PAYED";
            [client findBillByStatus:@"NOT_PAYED" page:currentPage];
            button2.selected =
            button3.selected =
            button4.selected =
            button5.selected = NO;
            break;
        case 2:
            currentStatus = @"ALL_PAYED";
            [client findBillByStatus:@"ALL_PAYED" page:currentPage];
            button1.selected =
            button3.selected =
            button4.selected =
            button5.selected = NO;
            break;
        case 3:
            currentStatus = @"SENT";
            [client findBillByStatus:@"SENT" page:currentPage];
            button1.selected =
            button2.selected =
            button4.selected =
            button5.selected = NO;
            break;
        case 4:
            currentStatus = @"RECEIVED";
            [client findBillByStatus:@"RECEIVED" page:currentPage];
            button2.selected =
            button3.selected =
            button1.selected =
            button5.selected = NO;
            break;
        case 5:
            currentStatus = @"REJECTED";
            [client findBillByStatus:@"REJECTED" page:currentPage];
            button2.selected =
            button3.selected =
            button4.selected =
            button1.selected = NO;
            break;
        default:
            break;
    }
}
@end
