//
//  OnlineAppointmentViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/2/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "OnlineAppointmentViewController.h"
#import "Employee.h"
#import "EmployeeViewCell.h"
#import "EmployeeDetailViewController.h"
#import "WorksOfEmployeeViewCell.h"
#import "WorksOfEmployeeDetailViewController.h"
#import "Works.h"

@interface OnlineAppointmentViewController (){
    UISegmentedControl * topControl;
}
@end

@implementation OnlineAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    topControl = [[UISegmentedControl alloc] initWithItems:@[@"员工",@"作品"]];
    topControl.tintColor = kBlueColor;
    topControl.selectedSegmentIndex = 0;
    topControl.width +=20;
    
    [topControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = topControl;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setTintColor:MyPinkColor];
    if (isFirstAppear && [super startRequest]) {
        [client findEmployeesByShopId:_shopId page:currentPage];
    }else{
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -requestFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [contentArr removeAllObjects];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Employee * it = [Employee objWithJsonDic:obj];
            [contentArr addObject:it];
        }];
        [tableView reloadData];
    }
    return YES;
}

-(void)requestWorksDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableArray * temp  = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Works * it = [Works objWithJsonDic:obj];
            [temp addObject:it];
        }];
        [self addIntoContentArr:temp];
        [tableView reloadData];
    }
}

#pragma mark -table数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (topControl.selectedSegmentIndex ==0) {
        return 60;
    }
    return 180;
}
-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (topControl.selectedSegmentIndex ==0) {
        static NSString * CellIdentifier = @"EmployeeViewCell";
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
        EmployeeViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        Employee * it = contentArr[indexPath.row];
        [cell setItem:it];
        return cell;
    }else{
        static NSString * CellIdentifier = @"WorksOfEmployeeViewCell";
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
        WorksOfEmployeeViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray * it = contentArr[indexPath.row];
        cell.superTableView = tableView;
        cell.indexPath = indexPath;
        [cell setItem:it];
        return cell;
    }
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    if (topControl.selectedSegmentIndex == 0) {
        Employee * it = contentArr[indexPath.row];
        return it.avatar;
    }else {
        return nil;
    }
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if (topControl.selectedSegmentIndex == 0) {
        EmployeeDetailViewController *con = [[EmployeeDetailViewController alloc] init];
        Employee *employee = [contentArr objectAtIndex:indexPath.row];
        employee.badge = @"0";
        con.employeeId = employee.ID;
        [self.navigationController pushViewController:con animated:YES];
    }else {
        if (indexPath.section==0) {
            return;
        }
        
        NSArray * array = contentArr[indexPath.row];
        NSDictionary *dic = array[indexPath.section-1];
        NSString *workId = [dic getStringValueForKey:@"id" defaultValue:@""];
        if ([workId hasValue]) {
            WorksOfEmployeeDetailViewController * con = [[WorksOfEmployeeDetailViewController alloc]initWithWorkId:workId];
            [self pushViewController:con];
        }
    }
}

#pragma mark - Util
- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
    CGFloat height = 22;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    height += size.height;
    return height;
}
-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index =seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self reloadEmployee];
            break;
        default:
            [self reloadProduce];
            break;
    }
}

-(void)reloadEmployee{
    [contentArr removeAllObjects];
    [super startRequest];
    [client findEmployeesByShopId:_shopId page:1];
}

-(void)reloadProduce{
    [contentArr removeAllObjects];
    if (needToLoad) {
        self.loading = YES;
    }
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestWorksDidFinish:obj:)];
    [client findEmpWorks:_shopId empId:nil p:1];
}

-(void)addIntoContentArr:(NSArray *)array{
    NSUInteger num = array.count;
    if (num==0) {
        return;
    }
    CGFloat totalRow =num==1?1:num/2;
    for (int i = 0; i<totalRow; i++) {
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int j =0; j<2; j++) {
            if (array.count >(i*2+j)) {
                Works * works = array[i*2+j];
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:works.picture forKey:@"imagePath"];
                [dic setObject:works.name forKey:@"name"];
                [dic setObject:works.ID forKey:@"id"];
                [tempArr addObject:dic];
            }
        }
        [contentArr addObject:tempArr];
    }
}
@end
