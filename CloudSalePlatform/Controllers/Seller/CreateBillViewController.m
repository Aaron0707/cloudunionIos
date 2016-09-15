//
//  CreateBillViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/6.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "CreateBillViewController.h"
#import "AddressItem.h"
#import "WareSku.h"
#import "Ware.h"
#import "PaymentViewController.h"

@interface CreateBillViewController (){
    AddressItem * addressItem;
    UILabel * nameLabel;
    UILabel * phoneLabel;
    UILabel * addressLabel;
    
    UILabel * balanceOfCashLabel;
    
    
    UIView * boxView;
    UILabel * wareNameLabel;
    UILabel * warePriceLabel;
    UILabel * wareSkuLeftLabel;
    UILabel * wareSkuRightLabel;
    UILabel * wareCountLeftLabel;
    UILabel * wareTotalPriceLeftLabel;
    UILabel * wareTotalPriceRightLabel;
    
    UIButton *upButton;
    UIButton *downButton;
    UITextField  *numberField;
}

@end

@implementation CreateBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交订单";
    
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (self.view.width-40)/3, 20)];
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-40)/3+20, 10, (self.view.width-40)/3, 20)];
    UIImageView * line  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, self.view.width-20, 1)];
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.view.width-20, 50)];
    UIButton *eidtButton  = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 5, 30, 30)];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (self.view.width-40)/3, 20)];
    nameLabel.numberOfLines  = 1;
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:nameLabel];
    
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-40)/3+20, 10, (self.view.width-40)/3, 20)];
    phoneLabel.numberOfLines  = 1;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:phoneLabel];
    
    eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 5, 30, 30)];
    [eidtButton setBackgroundImage:[UIImage imageNamed:@"pinkPencel"] forState:UIControlStateNormal];
    //        [eidtButton addTarget:self action:@selector(editAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:eidtButton];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, self.view.width-20, 1)];
    [line setImage:[UIImage imageNamed:@"change_card_cellline"]];
    [headerView addSubview:line];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.view.width-20, 50)];
    addressLabel.numberOfLines  = 2;
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [headerView addSubview:addressLabel];
    
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, self.view.width-2, 6)];
    [lineImage setImage:[UIImage imageNamed:@"color_line"]];
    [headerView addSubview:lineImage];
    [self.view addSubview:headerView];
    
    boxView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.bottom+10, self.view.width, 160)];
    [boxView setBackgroundColor:[UIColor whiteColor]];
    boxView.layer.borderWidth = 0.5;
    boxView.layer.borderColor = MygrayColor.CGColor;
    [self.view addSubview:boxView];
    
    wareNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.width-130, 20)];
    [boxView addSubview:wareNameLabel];
    
    warePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-110, 10, 80, 20)];
    warePriceLabel.textAlignment = NSTextAlignmentRight;
    [warePriceLabel setTextColor:MyPinkColor];
    [boxView addSubview:warePriceLabel];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, boxView.width, 0.5)];
    [line1 setBackgroundColor:MygrayColor];
    [boxView addSubview:line1];
    
    wareSkuLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 40, 20)];
    wareSkuLeftLabel.text = @"规格";
    [boxView addSubview:wareSkuLeftLabel];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(69, 50, 1, 20)];
    [line2 setBackgroundColor:MygrayColor];
    [boxView addSubview:line2];
    
    wareSkuRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 50, boxView.width-80, 20)];
    wareSkuRightLabel.textAlignment = NSTextAlignmentRight;
    [boxView addSubview:wareSkuRightLabel];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, boxView.width, 0.5)];
    [line3 setBackgroundColor:MygrayColor];
    [boxView addSubview:line3];
    
    
    wareCountLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 40, 20)];
    wareCountLeftLabel.text = @"数量";
    [boxView addSubview:wareCountLeftLabel];
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(69, 90, 1, 20)];
    [line4 setBackgroundColor:MygrayColor];
    [boxView addSubview:line4];
    
    ///
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.width-85, 90, 35, 25)];
    numberField.textAlignment = NSTextAlignmentCenter;
    numberField.layer.borderWidth = 0.5;
    numberField.layer.borderColor = MygrayColor.CGColor;
    numberField.text = @"1";
    [boxView addSubview:numberField];
    
    upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
    downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
    upButton.tag = 108;
    downButton.tag = 109;
    downButton.frame = CGRectMake(self.view.width-110, 90, 25, 25);
    upButton.frame = CGRectMake(self.view.width-50, 90, 25, 25);
    [boxView addSubview:upButton];
    [boxView addSubview:downButton];
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, boxView.width, 0.5)];
    [line5 setBackgroundColor:MygrayColor];
    [boxView addSubview:line5];
    
    wareTotalPriceLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 40, 20)];
    wareTotalPriceLeftLabel.text = @"总价";
    [boxView addSubview:wareTotalPriceLeftLabel];
    
    UIView * line6 = [[UIView alloc] initWithFrame:CGRectMake(69, 130, 1, 20)];
    [line6 setBackgroundColor:MygrayColor];
    [boxView addSubview:line6];
    
    wareTotalPriceRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 130, boxView.width-80, 20)];
    wareTotalPriceRightLabel.textAlignment = NSTextAlignmentRight;
    wareTotalPriceRightLabel.textColor = MyPinkColor;
    [boxView addSubview:wareTotalPriceRightLabel];
    
    
    if (_wareSku) {
        wareTotalPriceRightLabel.text = [NSString stringWithFormat:@"%@元",_wareSku.price?_wareSku.price:@"0"];
        warePriceLabel.text  =  [NSString stringWithFormat:@"%@元",_wareSku.price?_wareSku.price:@"0"];
        wareSkuRightLabel.text = _wareSku.name;
    }else{
        wareTotalPriceRightLabel.text = [NSString stringWithFormat:@"%@元",_ware.price?_ware.price:@"0"];
        warePriceLabel.text  =  [NSString stringWithFormat:@"%@元",_ware.price?_ware.price:@"0"];
    }
    wareNameLabel.text = _ware.name;
    
    
    UIButton * saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, boxView.bottom+30, self.view.width-40, 40)];
    [saveBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [saveBtn commonStyle];
    [saveBtn addTarget:self action:@selector(createBill:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear &&[super startRequest]) {
        [client findAddressItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -request did finish;
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj objectForKey:@"list"];
        if (list.count>0) {
            addressItem = [AddressItem objWithJsonDic:list[0]];
            
            nameLabel.text =addressItem.receiverName;
            phoneLabel.text = addressItem.receiverPhone;
            addressLabel.text = addressItem.receiverAddress;
        }
    }
    return YES;
}

-(void)requestCreateBillDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *billId = [obj getStringValueForKey:@"msg" defaultValue:@""];
        if (billId.hasValue) {
            PaymentViewController * con = [[PaymentViewController alloc]init];
            con.billId = billId;
            [self pushViewController:con];
        }
    }
}


#pragma mark -Util
-(void)createBill:(UIButton *)button{
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestCreateBillDidFinish:obj:)];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:_ware.id forKey:@"wareId"];
    if (_wareSku) {
        [dic setObject:_wareSku.ID forKey:@"skuId"];
    }

    if (numberField.text.hasValue) {
        [dic setObject:numberField.text forKey:@"num"];
    }else{
        [dic setObject:@"0" forKey:@"num"];
    }
    [client createBill:addressItem.ID data:@[dic]];
}


-(void)changeNumber:(UIButton *)btn{
    if (![numberField.text hasValue]) {
        return;
    }
    if (btn.tag == 108) {
        numberField.text = [NSString stringWithFormat:@"%i",(numberField.text.intValue+1)];
    }else{
        if ([numberField.text isEqualToString:@"1"]) {
            return;
        }
        numberField.text = [NSString stringWithFormat:@"%i",(numberField.text.intValue-1)];
    }
    if (_wareSku) {
        wareTotalPriceRightLabel.text = [NSString stringWithFormat:@"%.2f",numberField.text.intValue*_wareSku.price.doubleValue];
    }else{
        wareTotalPriceRightLabel.text = [NSString stringWithFormat:@"%.2f元",numberField.text.intValue*_ware.price.doubleValue];
    }
}

@end
