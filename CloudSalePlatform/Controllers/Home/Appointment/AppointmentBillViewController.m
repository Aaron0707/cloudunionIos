//
//  AppointmentBillViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/3/2.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "AppointmentBillViewController.h"
#import "UIImage+FlatUI.h"
#import "BaseTableViewCell.h"
#import "PaymentViewController.h"
#import "UIButton+NSIndexPath.h"
#import "CreateCommentViewController.h"

@interface AppointmentBillViewController (){
    
    NSString * currentStatus;
    
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
}

@end

@implementation AppointmentBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约记录";
//    [tableView setBackgroundColor:[UIColor clearColor]];
    [self setRightBarButton:@"全部订单" selector:@selector(findBillByType:)];
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIView *buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 40)];
    [buttonsView setBackgroundColor:kBlueColor];
    
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, rect.size.width/4-2, 40)];
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width/4-2, 0, rect.size.width/4-2, 40)];
    button3 = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width/4-2)*2, 0, rect.size.width/4-2, 40)];
    button4 = [[UIButton alloc]initWithFrame:CGRectMake((rect.size.width/4-2)*3, 0, rect.size.width/4-2, 40)];

    
    [button1 setTitle:@"待付款" forState:UIControlStateNormal];
    [button2 setTitle:@"已付款" forState:UIControlStateNormal];
    [button3 setTitle:@"已完成" forState:UIControlStateNormal];
    [button4 setTitle:@"已退款" forState:UIControlStateNormal];
    button1.titleLabel.font =
    button2.titleLabel.font =
    button3.titleLabel.font =
    button4.titleLabel.font =[UIFont systemFontOfSize:14];
    button1.tag = 1;
    button2.tag = 2;
    button3.tag = 3;
    button4.tag = 4;
    button1.selected = YES;
    
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button3 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];
    [button4 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0] forState:UIControlStateSelected];

    
    [button1 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(findBillByType:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsView addSubview:button1];
    [buttonsView addSubview:button2];
    [buttonsView addSubview:button3];
    [buttonsView addSubview:button4];
    

    tableView.top +=40;
    tableView.height -=40;
    [self.view addSubview:buttonsView];
    
    currentStatus = @"UNPAYED";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client findAppointmentsWithStatus:currentStatus creatorDeleted:NO pageSzie:0 page:currentPage];
    }
}


#pragma mark - Request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [contentArr removeAllObjects];
        NSArray * list = [obj objectForKey:@"list"];
        [contentArr addObjectsFromArray:list];
        [tableView reloadData];
    }
    return YES;
}

-(void)requestDeleteAppBillDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [tableView reloadData];
    }
}

#pragma mark - TableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return contentArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}


-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel * statusLabel = VIEWWITHTAG(cell.contentView, 101);
    UILabel * billNumberLabel = VIEWWITHTAG(cell.contentView, 102);
    UILabel * priceLabel = VIEWWITHTAG(cell.contentView, 103);
    
    UIButton * btn1 = VIEWWITHTAG(cell.contentView, 104);
    UIButton * btn2 = VIEWWITHTAG(cell.contentView, 105);
    
    UIView * line2 = VIEWWITHTAG(cell.contentView, 106);
    
    UILabel * consumeCodeLabel = VIEWWITHTAG(cell.contentView, 107);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.topLine =
        cell.bottomLine = NO;
        [cell setBackgroundColor:[UIColor clearColor]];
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, sender.width, 170)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:backView];
        [cell.contentView sendSubviewToBack:backView];
        
        statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
        statusLabel.tag = 101;
        
        billNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, sender.width-110, 20)];
        billNumberLabel.tag = 102;
        billNumberLabel.textAlignment = NSTextAlignmentRight;
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(10, 50, sender.width-20, 0.5)];
        [line1 setBackgroundColor:MygrayColor];
        [cell.contentView addSubview:line1];
        
        line2 = [[UIView alloc]init];
        [line2 setBackgroundColor:MygrayColor];
        line2.tag = 106;
        [cell.contentView addSubview:line2];
        
        priceLabel = [[UILabel alloc]init];
        priceLabel.tag = 103;
        
        statusLabel.font =
        billNumberLabel.font =
        priceLabel.font = [UIFont systemFontOfSize:14];
        
        [cell.contentView addSubview:statusLabel];
        [cell.contentView addSubview:billNumberLabel];
        [cell.contentView addSubview:priceLabel];
        
        btn1 = [[UIButton alloc]init];
        
        btn2 = [[UIButton alloc]init];
        btn1.tag = 104;
        btn2.tag = 105;
        [btn1 addTarget:self action:@selector(billProcess:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(billProcess:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btn1];
        [cell.contentView addSubview:btn2];
        
        consumeCodeLabel = [[UILabel alloc]init];
        consumeCodeLabel.tag = 107;
        consumeCodeLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:consumeCodeLabel];
    }
    consumeCodeLabel.hidden = YES;
    
    NSDictionary * dic = [contentArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic getStringValueForKey:@"workName" defaultValue:@""];
    
//    NSString * statusString = [dic getStringValueForKey:@"status" defaultValue:@""];
    if ([currentStatus isEqualToString:@"UNPAYED"]) {
        statusLabel.text = @"待付款";
        statusLabel.textColor = MyPinkColor;
        
        [btn1 setTitle:@"确认支付" forState:UIControlStateNormal];
        [btn2 setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn1 pinkStyle2];
        [btn2 pinkBorderStyle];
        btn1.indexPath = indexPath;
        
        btn1.hidden =
        btn2.hidden = NO;
        
    }else if([currentStatus isEqualToString:@"PAYED"]){
        statusLabel.text = @"已付款";
        statusLabel.textColor = MygreenColor;
        
        btn1.hidden =
        btn2.hidden = YES;
        
        consumeCodeLabel.hidden = NO;
        NSString * str = [NSString stringWithFormat:@"消费码: %@",[dic getStringValueForKey:@"consumeCode" defaultValue:@""]];
        NSMutableAttributedString * attrStr =[[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(4,str.length-4)];
        consumeCodeLabel.attributedText = attrStr;
        
    }else if ([currentStatus isEqualToString:@"COMPLETED"]){
        statusLabel.text = @"已完成";
        statusLabel.textColor = MyPinkColor;
        
        [btn1 setTitle:@"删除" forState:UIControlStateNormal];
        [btn2 setTitle:@"评价" forState:UIControlStateNormal];
        
        [btn1 pinkStyle2];
        [btn2 blueBorderStyle];
        btn1.hidden =
        btn2.hidden = NO;
    }else if([currentStatus isEqualToString:@"REVERSEPAYED"]){
        statusLabel.text = @"已退款";
        statusLabel.textColor = MyPinkColor;
        
        btn1.hidden =
        btn2.hidden = YES;
    }
    
    btn1.titleLabel.font =
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    
    billNumberLabel.text = [NSString stringWithFormat:@"订单号:%@",[dic getStringValueForKey:@"" defaultValue:@""]];
    priceLabel.text = [NSString stringWithFormat:@"合计:￥%@",[dic getStringValueForKey:@"workPrice" defaultValue:@""]];
    
    NSString *tempStr = priceLabel.text;
    if (tempStr.length>4) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:tempStr];
    
        [str addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(3, tempStr.length-3)];
        
        priceLabel.attributedText = str;
    }
    
    [cell update:^(NSString *name) {
        cell.bottomLineView.width-=20;
        cell.bottomLineView.left = 10;
        cell.textLabel.numberOfLines = 2;
        
        line2.frame = CGRectMake(10, cell.imageView.bottom+10, sender.width-20, 0.5);
        priceLabel.frame = CGRectMake(10, line2.bottom+10, sender.width-110, 20);
        
        if (!btn1.hidden && !btn2.hidden) {
            btn1.frame = CGRectMake(sender.width-180, line2.bottom+10, 80, 30);
            btn2.frame = CGRectMake(sender.width-90, line2.bottom+10, 80, 30);
        }else if (!btn1.hidden){
            btn1.frame = CGRectMake(sender.width-90, line2.bottom+10, 80, 30);
        }else if (!btn2.hidden){
            btn2.frame = CGRectMake(sender.width-90, line2.bottom+10, 80, 30);
        }
        
        if (!consumeCodeLabel.hidden) {
            consumeCodeLabel.frame = CGRectMake(sender.width-180, line2.bottom+10, 170, 30);
            consumeCodeLabel.numberOfLines = 1;
        }
    }];

    return cell;
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = [contentArr objectAtIndex:indexPath.row];
    
    return [dic getStringValueForKey:@"workPicture" defaultValue:@""];
}

#pragma mark - Private
-(void)findBillByType:(UIButton *)button{
    if (button.selected) {
        return;
    }
    button.selected = YES;
    currentPage = 1;
        switch (button.tag) {
            case 1:
                currentStatus = @"UNPAYED";
                button3.selected =
                button4.selected =
                button2.selected = NO;
                break;
                
            case 2:
                currentStatus = @"PAYED";
                button3.selected =
                button4.selected =
                button1.selected = NO;
                break;
            case 3:
                currentStatus = @"COMPLETED";
                button1.selected =
                button4.selected =
                button2.selected = NO;
                break;
            case 4:
                currentStatus = @"REVERSEPAYED";
                button3.selected =
                button1.selected =
                button2.selected = NO;
                break;
                
            default:
                currentStatus = @"";
                break;
        }
    if([super startRequest]){
        if (needToLoad) {
            self.loading = YES;
        }
       [client findAppointmentsWithStatus:currentStatus creatorDeleted:NO pageSzie:0 page:currentPage];
    }
}

-(void)billProcess:(UIButton *)button{
    NSDictionary * dic = [contentArr objectAtIndex:button.indexPath.row];
    if ([currentStatus isEqualToString:@"UNPAYED"]) {
        if (button.tag == 104) {
            PaymentViewController * con = [[PaymentViewController alloc] init];
            con.isAppointmentPay = YES;
            con.appointmentDic = dic;
            [self pushViewController:con];
        }else if (button.tag ==105){
            
            NSString * appId = [dic getStringValueForKey:@"id" defaultValue:@""];
            if (![appId hasValue]) {
                return;
            }
            
            if (needToLoad) {
                self.loading = YES;
            }
            
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDeleteAppBillDidFinish:obj:)];
            [client deleteAppointmentByCreator:appId];
            [contentArr removeObject:dic];
        }
        
    }else if ([currentStatus isEqualToString:@"COMPLETED"]){
        if (button.tag == 104) {
            NSString * appId = [dic getStringValueForKey:@"id" defaultValue:@""];
            if (![appId hasValue]) {
                return;
            }
            
            if (needToLoad) {
                self.loading = YES;
            }
            
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDeleteAppBillDidFinish:obj:)];
            [client deleteAppointmentByCreator:appId];
            [contentArr removeObject:dic];
        }else if (button.tag ==105){
            CreateCommentViewController * con = [[CreateCommentViewController alloc]init];
            con.commentType = WORKS;
            con.targetId = [dic getStringValueForKey:@"workId" defaultValue:@""];
            con.referId = [dic getStringValueForKey:@"id" defaultValue:@""];
            [self pushViewController:con];
        }

    }else if([currentStatus isEqualToString:@"REVERSEPAYED"]){

    }
}
@end
