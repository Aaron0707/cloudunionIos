//
//  CreateBillViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/29.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "PaymentViewController.h"
#import "BaseTableViewCell.h"
#import "AddressItem.h"
#import "UIButton+NSIndexPath.h"
#import "CartItemAndBillItem.h"
#import "OnlineBill.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import "ManagerAddressViewController.h"

@interface PaymentViewController ()<ManagerAddressDelegate>{
    AddressItem * addressItem;
    OnlineBill * bill;
    
    UILabel * nameLabel;
    UILabel * phoneLabel;
    UILabel * addressLabel;
    
    UILabel * balanceOfCashLabel;
}

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认支付";
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 110)];
    [tableHeaderView setBackgroundColor:[UIColor whiteColor]];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (tableView.width-40)/3, 20)];
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width-40)/3+20, 10, (tableView.width-40)/3, 20)];
    UIImageView * line  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 1)];
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 50)];
    UIButton *eidtButton  = [[UIButton alloc] initWithFrame:CGRectMake(tableView.width-40, 5, 30, 30)];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (tableView.width-40)/3, 20)];
    nameLabel.numberOfLines  = 1;
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [tableHeaderView addSubview:nameLabel];
    
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width-40)/3+20, 10, (tableView.width-40)/3, 20)];
    phoneLabel.numberOfLines  = 1;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [tableHeaderView addSubview:phoneLabel];
    
    eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(tableView.width-40, 5, 30, 30)];
    [eidtButton setBackgroundImage:[UIImage imageNamed:@"pinkPencel"] forState:UIControlStateNormal];
    [eidtButton addTarget:self action:@selector(checkAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:eidtButton];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 1)];
    [line setImage:[UIImage imageNamed:@"change_card_cellline"]];
    [tableHeaderView addSubview:line];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 50)];
    addressLabel.numberOfLines  = 2;
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [tableHeaderView addSubview:addressLabel];
    
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, tableView.width-2, 6)];
    [lineImage setImage:[UIImage imageNamed:@"color_line"]];
    [tableHeaderView addSubview:lineImage];
    
    tableView.tableHeaderView = tableHeaderView;
    
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 400)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
    titleLabel.text = @"支付方式";
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [footerView addSubview:titleLabel];
    
    UIView * accountView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, tableView.width-20, 40)];
    accountView.layer.borderColor = MygrayColor.CGColor;
    accountView.layer.borderWidth = 0.5;
    [footerView addSubview:accountView];
    
//    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, accountView.width, 0.5)];
//    [line1 setBackgroundColor:MygrayColor];
//    [accountView addSubview:line1];
    UIImageView * zfbImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zfb_img"]];
    zfbImage.left = 10;
    zfbImage.top = 7;
    [accountView addSubview:zfbImage];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
    textLabel.text = @"支付宝支付";
    [accountView addSubview:textLabel];
    
    balanceOfCashLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, accountView.width-100, 20)];
    balanceOfCashLabel.numberOfLines = 1;
    [accountView addSubview:balanceOfCashLabel];
    
    
    
    UIButton * saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, accountView.bottom+30, tableView.width-40, 40)];
    [saveBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [saveBtn pinkStyle];
    [footerView addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(paymentBill:) forControlEvents:UIControlEventTouchUpInside];
    
    tableView.tableFooterView = footerView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear ) {
        if (!_isAppointmentPay) {
            [super startRequest];
            [client findBillById:_billId];
        }else{
            bill = [[OnlineBill alloc] init];
            
            bill.ID = [_appointmentDic getStringValueForKey:@"id" defaultValue:@""];
            bill.totalPrice = [_appointmentDic getStringValueForKey:@"price" defaultValue:@""];
            
            CartItemAndBillItem * ware = [[CartItemAndBillItem alloc] init];
            ware.wareName = [_appointmentDic getStringValueForKey:@"workName" defaultValue:@""];
            ware.skuPrice = [_appointmentDic getStringValueForKey:@"price" defaultValue:@""];
            ware.num = @"1";
            ware.picture = [_appointmentDic getStringValueForKey:@"workPicture" defaultValue:@""];
            [contentArr addObjectsFromArray:@[ware]];
            
            [tableView reloadData];
            
            
            addressItem = [[AddressItem alloc] init];
            
            addressItem.receiverName =[_appointmentDic getStringValueForKey:@"receiverName" defaultValue:@""];
            addressItem.receiverPhone = [_appointmentDic getStringValueForKey:@"receiverPhone" defaultValue:@""];
            addressItem.receiverAddress =[_appointmentDic getStringValueForKey:@"receiverAddress" defaultValue:@""];
            
            if (![addressItem.receiverAddress hasValue]) {
               addressItem.receiverAddress = [_appointmentDic getStringValueForKey:@"serviceAddress" defaultValue:@""];
            }
             bill.receiverAddress = addressItem.receiverAddress;
            nameLabel.text =addressItem.receiverName;
            phoneLabel.text = addressItem.receiverPhone;
            addressLabel.text = addressItem.receiverAddress;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -request did finish;
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
        NSArray * list = [obj objectForKey:@"list"];
        if (list.count>0) {
            bill = [OnlineBill objWithJsonDic:list[0]];
            
            if (bill.receiverName.hasValue) {
                addressItem = [[AddressItem alloc] init];
                
                addressItem.receiverName = bill.receiverName;
                addressItem.receiverPhone = bill.receiverPhone;
                addressItem.receiverAddress = bill.receiverAddress;
                
                nameLabel.text =addressItem.receiverName;
                phoneLabel.text = addressItem.receiverPhone;
                addressLabel.text = addressItem.receiverAddress;
            }else{
                client = [[BSClient alloc]initWithDelegate:self action:@selector(requestAddressDidFinish:obj:)];
                [client findAddressItems];
            }
            
            [contentArr addObjectsFromArray:bill.items];
            [tableView reloadData];
        }
    }
    
    return YES;
}

-(void)requestAddressDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj objectForKey:@"list"];
        if (list.count>0) {
            addressItem = [AddressItem objWithJsonDic:list[0]];
            
            nameLabel.text =addressItem.receiverName;
            phoneLabel.text = addressItem.receiverPhone;
            addressLabel.text = addressItem.receiverAddress;
        }
    }
}


- (void)requestUpdateBillAddressDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self payment];
    }
}
#pragma mark -tableView delegate;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.topLine =
    cell.imageView.hidden = NO;
    cell.bottomLine = YES;
    CartItemAndBillItem * ware = [contentArr objectAtIndex:indexPath.row];
    cell.textLabel.text = ware.wareName;
    NSString * detailString = [NSString stringWithFormat:@"%@元  x%@",[ware skuPrice],[ware num]];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:detailString];
    [attStr addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica" size:16] range:NSMakeRange(0, detailString.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(0, [ware skuPrice].length+1)];
    cell.detailTextLabel.attributedText = attStr;
    [cell update:^(NSString *name) {
        cell.textLabel.top += 5;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.height = 40;
        cell.textLabel.width = cell.width-100;
        cell.detailTextLabel.top -=10;
    }];
    return cell;
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    CartItemAndBillItem *item = [contentArr objectAtIndex:indexPath.row];
    return item.picture;
}

#pragma mark - manager address delegate
-(void)managerAddressCheckedAddress:(AddressItem *)address{
    addressItem = address;
    
    nameLabel.text =addressItem.receiverName;
    phoneLabel.text = addressItem.receiverPhone;
    addressLabel.text = addressItem.receiverAddress;
}

#pragma mark -Util
-(void)checkAddressItem:(UIButton *)button{
    ManagerAddressViewController * con = [[ManagerAddressViewController alloc]init];
    con.delegate = self;
    [self pushViewController:con];
}


-(void)paymentBill:(UIButton *)button{
    if (!addressItem) {
        [self showText:@"地址信息错误"];
        return;
    }
    if (![addressItem.receiverAddress isEqualToString:bill.receiverAddress]) {
        client = [[BSClient alloc] initWithDelegate:self action:@selector(requestUpdateBillAddressDidFinish:obj:)];
        if (_isAppointmentPay) {
            [client updateAppointmentAddress:nil AppointmentId:bill.ID OrAddressId:addressItem.ID];
        }else{
            [client updateBillAddress:bill.ID addressId:addressItem.ID];
        }
    }else{
        [self payment];
    }
}

-(void)payment{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088011939647307";
    NSString *seller = @"2563806247@qq.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANVoZPROkFqXeM6ppRaj73PVgU6w4q8P0dPujCYeC1OXYEA9RbrbpmKTkGhh5jxXbv5jAEVi4JAy7fmJspnabzO+KI8WOjVyM8rw/CwZNSaV3aA6peIwdSljUeNEWUKYWMu/mckYCu+uTPIZOTrn3g1wyehMUiS+c8lhER9+7YDfAgMBAAECgYEAv81h3sm1qBY3d9a1D9IrZnpgC2+jbR/UwJvHzoJ2P5zv3wyy3SyJMFPcGFTU7yrOEUi9d59UoYWEqSB/KxRNmBkhUAE+rIGFFd1jaKEso914Fk6BbgKuuCTyuVpJbDElMgU+uMOMp3MBAhLeRqaUuJ3DGZUT806Fkz/D86Ko9HECQQD0YmVWEiurKK5P5vrOY5DrsXwbvLXslYFaYm6OpGQeq2T53NFbDCziAeM94y8oyjABjZdV+GxGlqpBzyEvBEyjAkEA340Vdco430Mg3EFQq1eiZgzd5qMpe6rCb2gG5O3R0RLNTly1P7bNBZL7pai0PHoZjspPPY1O7oLgxjvQ0nfilQJAUXhcAA2esTimo8yE4DkhHvHURgrrOyu8K72UzcjP98l7qDCNOqUccVvfvcn29sowptPlF6vxrLadm8LJdTshsQJAKaKvMob9XKe2AQ+xJJhnyLXwxjnxSfUdzX4EerLIdzYXQtcFct5rBPTBJbNsDi93fx6y73XYE5gQoRsW43wsmQJBAKRpVF8R09x0OKUMaYeBzt7AWadBmNBgfNKMjll/YCOr6RZjlyL5QSmqf2Gz6mVYdt9WenecPWaXZEV3oe0jwQA=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = bill.ID; //订单ID（由商家自行制定）
    order.productName = bill.ID; //商品标题
    order.productDescription =bill.ID; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",bill.totalPrice.doubleValue]; //商品价格
    order.notifyURL =  @"http://api.cloudvast.com/alipay/notify.htm"; //回调URL
    
    if (_isAppointmentPay) {
        order.notifyURL = @"http://api.cloudvast.com/alipay/notifyAppointment.htm";
    }
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"cloudSalePlatform";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
}

@end
