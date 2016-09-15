//
//  CityStreamControlViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/30.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "CityStreamControlViewController.h"
#import "BaseTableViewCell.h"
#import "TextInput.h"

@interface CityStreamControlViewController (){
    int stepCount;
    NSMutableString *fullAddress;
}

@end

@implementation CityStreamControlViewController

- (id)init{
    if (self = [super init]) {
        stepCount = 0;
        fullAddress = [[NSMutableString alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"区域选择";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client findProvinces:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -request did Finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        stepCount =1;
        [contentArr removeAllObjects];
        NSArray * list = [obj objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [contentArr addObject:obj];
        }];
        [tableView reloadData];
    }
    return YES;
}

- (void)requestCityDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        stepCount = 2;
        [contentArr removeAllObjects];
        NSArray * list = [obj objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [contentArr addObject:obj];
        }];
        [tableView reloadData];
    }
}

- (void)requestDistrictDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        stepCount = 3;
        [contentArr removeAllObjects];
        NSArray * list = [obj objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [contentArr addObject:obj];
        }];
        [tableView reloadData];
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
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       
    }
    cell.imageView.hidden = YES;
    NSDictionary * dic = [contentArr objectAtIndex:indexPath.row];
    if (stepCount==1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fullName"]];
    }else{
        cell.textLabel.text =[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }

    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [contentArr objectAtIndex:indexPath.row];
    NSString * code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    
    switch (stepCount) {
        case 1:
            [fullAddress appendString:[dic objectForKey:@"fullName"]];
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestCityDidFinish:obj:)];
            [client findCitysByProvinceCode:code query:nil];
            break;
        case 2:
            [fullAddress appendString:[dic objectForKey:@"name"]];
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDistrictDidFinish:obj:)];
            [client findDistrict:code];
            break;
//        case 2:
//            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDidFinish:obj:)];
//            [client findProvinces:nil];
        default:
            [fullAddress appendString:[dic objectForKey:@"name"]];
            if ([_delegate respondsToSelector:@selector(cityStreamControlDidFinish:districtCode:)]) {
                [_delegate cityStreamControlDidFinish:fullAddress districtCode:code];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}


@end
