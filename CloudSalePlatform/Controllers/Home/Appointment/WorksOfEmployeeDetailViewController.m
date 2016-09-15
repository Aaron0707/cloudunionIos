//
//  WorksOfEmployeeDetailViewViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/10.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "WorksOfEmployeeDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Globals.h"
#import "BaseTableViewCell.h"
#import "Works.h"
#import "ActionSheetOne.h"
#import "AddressItem.h"

#import "ManagerAddressViewController.h"
#import "PaymentViewController.h"

@interface WorksOfEmployeeDetailViewController ()<ActionSheetOneDelegate,ManagerAddressDelegate>{
    UIImageView * image;
    UILabel * currentPriceLabel;
    UILabel * nameLabel;
    UILabel * timeOfWorkLabel;
    UILabel * durationLabel;
    
    Works * works;
    
    NSArray * LimitSettingOfTime;
    
    NSString * appointmentDate;
    NSString * appointmentTime;
    AddressItem * appointAddress;
}

@end

@implementation WorksOfEmployeeDetailViewController
-(instancetype)initWithWorkId:(NSString *)workId{
    
    if(self = [super init]){
        _workId = workId;
        appointAddress= [[AddressItem alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 370)];
    [tableHeaderView setBackgroundColor:[UIColor whiteColor]];
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 260)];
    [tableHeaderView addSubview:image];
    tableView.tableHeaderView = tableHeaderView;
    
    currentPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, image.bottom+10, tableView.width-20, 20)];
    [currentPriceLabel setTextColor:MyPinkColor];
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, currentPriceLabel.bottom-10, tableView.width-20, 50)];
    nameLabel.numberOfLines = 2;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom, tableView.width, 1)];
    [line setBackgroundColor:MygrayColor];
    line.alpha = 0.4;
    [tableHeaderView addSubview:line];
    
    timeOfWorkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom+10, (tableView.width-20)/2, 20)];
    durationLabel = [[UILabel alloc]initWithFrame:CGRectMake((tableView.width-20)/2+10, line.bottom+10, (tableView.width-20)/2, 20)];
    
    currentPriceLabel.font =
    nameLabel.font =
    timeOfWorkLabel.font=
    durationLabel.font = [UIFont systemFontOfSize:14];
    
    
    [tableHeaderView addSubview:currentPriceLabel];
    [tableHeaderView addSubview:nameLabel];
    [tableHeaderView addSubview:timeOfWorkLabel];
    [tableHeaderView addSubview:durationLabel];
    
    
    UIView * tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 60)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    tableView.tableFooterView = tableFooterView;
    
    
    UIView * backView  = [[UIView alloc ] initWithFrame:CGRectMake(0, 10, tableView.width, 50)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [tableFooterView addSubview:backView];
    [tableFooterView sendSubviewToBack:backView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((tableView.width-220)/2, 10, 220, 30)];
    [btn setTitle:@"选中商品" forState:UIControlStateNormal];
    [btn pinkStyle];
    [backView addSubview:btn];
    
    [btn addTarget:self action:@selector(createAppointment:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (isFirstAppear && [super startRequest]) {
        [client findEmpWorkDetail:_workId];
    }
    
}

#pragma mark - request did finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        //        NSArray * list  = [obj objectForKey:@"list"];
        //        if (list.count >=1) {
        works = [Works objWithJsonDic:obj];
        [self showWorksDetail];
        //        }
    }
    return YES;
}

-(void)requestLimitSettingDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        if (list.count>0) {
            LimitSettingOfTime = list;
            NSArray * temp = list[3];
            NSString * title = [temp[0] getStringValueForKey:@"ymd" defaultValue:@""];
            NSString *subtitle = [title substringWithRange:NSMakeRange(4, 4)];
            NSString * str = [NSString stringWithFormat:@"%@.%@",[subtitle substringToIndex:2],[subtitle substringFromIndex:2]];
            ActionSheetOne * sheet = [[ActionSheetOne alloc]initWithActionTab:@[@"今天",@"明天",@"后天",str] TextViews:list withDelegate:self];
            [sheet show];
        }
    }
}

-(void)requestCreateAppointmentDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSDictionary * appointment = [obj getDictionaryForKey:@"appointment"];
        NSMutableDictionary * mutableDic = [appointment mutableCopy];
        PaymentViewController * con = [[PaymentViewController alloc]init];
        con.isAppointmentPay = YES;
        if ([appointAddress.receiverAddress hasValue]) {
          [mutableDic setObject:appointAddress.receiverAddress forKey:@"receiverAddress"];
        }else{
          [mutableDic setObject:@"未选择地址信息" forKey:@"receiverAddress"];
        }
        if ([appointAddress.receiverName hasValue]) {
           [mutableDic setObject:appointAddress.receiverName forKey:@"receiverName"];
        }
    
        if ([appointAddress.receiverPhone hasValue]) {
            [mutableDic setObject:appointAddress.receiverPhone forKey:@"receiverPhone"];
        }
        
        if ([works.picture hasValue]) {
           [mutableDic setObject:works.picture forKey:@"workPicture"];
        }
        if ([works.name hasValue]) {
            [mutableDic setObject:works.name forKey:@"workName"];
        }
        
        con.appointmentDic = mutableDic;
        [self pushViewController:con];
    }
}
#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return 1;
    }
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && indexPath.row == 0) {
        return 80;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    //    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (!cell) {
    BaseTableViewCell * cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    
    if (indexPath.section==0 && indexPath.row==0) {
        cell.textLabel.text = @"预约时间";
        if (appointmentDate&&appointmentTime) {
            
            NSString * str = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@",[appointmentDate substringToIndex:4],[appointmentDate substringWithRange:NSMakeRange(4, 2)],[appointmentDate substringWithRange:NSMakeRange(6, 2)],[appointmentTime substringToIndex:2],[appointmentTime substringFromIndex:2]];
            cell.detailTextLabel.text = str;
        }
        [cell addArrowRight];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        cell.textLabel.text = @"服务地址";
        
        if (appointAddress) {
            cell.detailTextLabel.text = appointAddress.receiverAddress;
        }
        
        [cell addArrowRight];
    }else if (indexPath.section == 1 && indexPath.row ==0){
        
        cell.textLabel.text = [works.emp getStringValueForKey:@"name" defaultValue:@""];
        cell.detailTextLabel.text = [works.emp getStringValueForKey:@"phone" defaultValue:@""];
        [cell removeArrowRight];
    }else if (indexPath.section == 1 && indexPath.row ==1){
        cell.textLabel.text = @"客户评价";
        [cell addArrowRight];
    }
    
    [cell update:^(NSString *name) {
        if (indexPath.section!=1 || !(indexPath.row ==0 && indexPath.section==1)) {
            cell.imageView.frame = CGRectMake(10, 10, 24, 24);
            cell.textLabel.left = cell.imageView.right+10;
        }
        
        if (indexPath.section == 1 && indexPath.row ==0){
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[works.emp getStringValueForKey:@"avatar" defaultValue:@""]] placeholderImage:[Globals getImageDefault]];
            
            cell.detailTextLabel.top -=10;
        }
        
        if (indexPath.section==0) {
            cell.detailTextLabel.frame = CGRectMake(140, 10, 160, 20);
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            
            if (indexPath.row ==0) {
                [cell.imageView setImage:[UIImage imageNamed:@"clock"]];
            }else{
                [cell.imageView setImage:[UIImage imageNamed:@"address"]];
            }
        }else{
            if (indexPath.row==1) {
                [cell.imageView setImage:[UIImage imageNamed:@"works"]];
            }
        }
        
        
    }];
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row==0) {
        if (!LimitSettingOfTime) {
            client = [[BSClient alloc]initWithDelegate:self action:@selector(requestLimitSettingDidFinish:obj:)];
            [client findLimitSettings:works.orgId];
        }else{
            NSArray * temp = LimitSettingOfTime[3];
            NSString * title = [temp[0] getStringValueForKey:@"ymd" defaultValue:@""];
            NSString *subtitle = [title substringWithRange:NSMakeRange(4, 4)];
            NSString * str = [NSString stringWithFormat:@"%@.%@",[subtitle substringToIndex:2],[subtitle substringFromIndex:2]];
            ActionSheetOne * sheet = [[ActionSheetOne alloc]initWithActionTab:@[@"今天",@"明天",@"后天",str] TextViews:LimitSettingOfTime withDelegate:self];
            [sheet show];
        }
    }else if(indexPath.section == 0 && indexPath.row == 1){
        ManagerAddressViewController * con = [[ManagerAddressViewController alloc]init];
        con.delegate = self;
        [self pushViewController:con];
    }else if (indexPath.section == 1 && indexPath.row ==0){
        
    }else if (indexPath.section == 1 && indexPath.row ==1){
        
    }
}

#pragma mark -sheet delegate
-(void)actionSheet:(ActionSheetOne *)sender didDismissWithObj:(NSDictionary * )dic {
    NSLog(@"%@",dic);
    appointmentDate = [dic getStringValueForKey:@"ymd" defaultValue:@""];
    appointmentTime = [dic getStringValueForKey:@"startHm" defaultValue:@""];
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)managerAddressCheckedAddress:(AddressItem *)address{
    appointAddress = address;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - private util
-(void)showWorksDetail{
    
    if (!works) {
        return;
    }
    
    [image sd_setImageWithURL:[NSURL URLWithString:works.picture] placeholderImage:[Globals getImageDefault]];
    
    currentPriceLabel.text = [NSString stringWithFormat:@"￥%@",works.price];
    nameLabel.text = works.describe;
    timeOfWorkLabel.text = [NSString stringWithFormat:@"耗时：%@分钟",works.timeTake];
    durationLabel.text = @"保持：20天";
    
    self.navigationItem.title = works.name;
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)createAppointment:(UIButton *)sender{
    if (!appointmentDate || !appointmentTime) {
        [self showText:@"请选择预约时间"];
        return;
    }
    
    client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCreateAppointmentDidFinish:obj:)];
    
    [client createAppointment:_workId Ymd:appointmentDate Hm:appointmentTime Address:appointAddress.receiverAddress Remark:nil];
}

@end
