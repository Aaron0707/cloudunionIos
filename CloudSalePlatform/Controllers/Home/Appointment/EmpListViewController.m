//
//  EmpListViewController.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-25.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "EmpListViewController.h"
#import "UIButton+NSIndexPath.h"
#import "BaseTableViewCell.h"
#import "Employee.h"
#import "BasicNavigationController.h"
#import "EmployeeDetailViewController.h"
#import "KWAlertView.h"
#import "ImageTouchView.h"
#import "Globals.h"
#import "UIImageView+WebCache.h"

@interface EmpListViewController ()<UITextViewDelegate,KWAlertViewDelegate,ImageTouchViewDelegate>{

    UITextView *inputText;
    
}
@end

@implementation EmpListViewController

-(id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableSlimeRefresh];

    self.navigationItem.title = @"员工预约";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 18.0f, 20.0f)];
    UIImage *backImage = [UIImage imageNamed:@"back_bakc"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark -table数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Employee * it = contentArr[indexPath.row];
    CGFloat height = 45;
    height += [self heightofText:it.name fontSize:15];
     height += [self heightofText:it.phone fontSize:15];
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton * buyBtn = VIEWWITHTAG(cell.contentView, 100);   // 立即抢购
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.size = CGSizeMake(50, 50);
        buyBtn.tag = 100;
        buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [buyBtn setBackgroundImage:[UIImage imageNamed:@"appointment_btn"] forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(appointmentAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buyBtn];
    }
     Employee *employee = [contentArr objectAtIndex:indexPath.row];
    ImageTouchView *imageTouch = [[ImageTouchView alloc]initWithFrame:CGRectMake(10, 10, 34, 34) delegate:self];
    [imageTouch sd_setImageWithURL:[NSURL URLWithString:employee.avatar] placeholderImage:[Globals getImageDefault]];
    imageTouch.tag = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    [cell.contentView addSubview:imageTouch];
    
    [self createMyBadge:cell Value:employee.badge Left:YES];
    
    buyBtn.hidden           = NO;
    cell.imageView.hidden   = YES;
    buyBtn.indexPath = indexPath;
    [cell update:^(NSString *name) {
        
        cell.textLabel.frame = CGRectMake(50, 0, 100, 40);
        cell.textLabel.text =employee.name;
        cell.detailTextLabel.text = employee.phone;
        cell.detailTextLabel.left = cell.textLabel.left;
        cell.detailTextLabel.top =20;
        cell.detailTextLabel.height = 40;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        buyBtn.origin = CGPointMake(cell.width - 45, cell.textLabel.top+5);
    
    }];
    cell.selectionStyle = NO;
    return cell;
}

-(void)imageTouchViewDidSelected:(ImageTouchView *)sender{
     NSInteger tag = [sender.tag integerValue];
    EmployeeDetailViewController *con = [[EmployeeDetailViewController alloc] init];
    Employee *employee = [contentArr objectAtIndex:tag];
    con.employeeId = employee.ID;
    employee.badge = @"0";
    [self.navigationController pushViewController:con animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EmployeeDetailViewController *con = [[EmployeeDetailViewController alloc] init];
    Employee *employee = [contentArr objectAtIndex:indexPath.row];
    employee.badge = @"0";
    con.employeeId = employee.ID;
    [self.navigationController pushViewController:con animated:YES];
}

- (UIImageView *)lineWithTag:(int)tag inCell:(BaseTableViewCell *)cell {
    UIImageView * line2 = VIEWWITHTAG(cell.contentView, tag);
    if (!line2) {
        line2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, cell.width - 20, 0.5)];
        line2.backgroundColor = RGBCOLOR(215, 215, 214);
        line2.tag = tag;
        [cell.contentView addSubview:line2];
    }
    line2.hidden = YES;
    return line2;
}

- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
    CGFloat height = 22;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    height += size.height;
    return height;
}

#pragma mark - buy button
- (void)appointmentAtIndexPath:(UIButton*)sender {
    NSIndexPath * idx = sender.indexPath;
    //打开键盘添加预约备注
//    BaseTableViewCell * cell = (BaseTableViewCell *)[tableView cellForRowAtIndexPath:idx];
    Employee * emp = contentArr[idx.row];
    inputText = [self createInputText:emp.name];
    inputText.tag = idx.row;
}


- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    [client findEmployeesByShopId:_shopId page:page];
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
    }
    [tableView reloadData];
    return YES;
}


-(void)doAppointmentFinish:(id)sender obj:(NSDictionary *)obj{
      if ([super requestDidFinish:sender obj:obj]) {
          [self.tabBarController setSelectedIndex:1];
      }
}



-(UITextView *)createInputText:(NSString *)labelText{
    if(!inputText){
        inputText = [[UITextView alloc] init];
        inputText.layer.masksToBounds = YES;
        inputText.layer.cornerRadius = 3.0;
        inputText.returnKeyType = UIReturnKeySend;//键盘按钮名称
        inputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
        inputText.delegate = self;
    }
    NSString *message = [NSString stringWithFormat:@"预约 %@",labelText];
    KWAlertView * alert = [[KWAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" textViews:[NSArray arrayWithObjects:inputText, nil] otherButtonTitles:@"取消", nil];
    [alert show];
    
    [inputText becomeFirstResponder];
    return inputText;
}


#pragma mark -KWAlertDelegate
-(void)kwAlertView:(KWAlertView *)sender didDismissWithButtonIndex:(NSInteger)index{
    if (index==1) {
        Employee *currentEmp = [contentArr objectAtIndex:inputText.tag];
        client = [[BSClient alloc]initWithDelegate:self action:@selector(doAppointmentFinish:obj:)];
        [client addAppointmentByEmpId:currentEmp.ID remark:inputText.text];
    }
}

#pragma mark -backhome
-(void)backHome:(id)sender{
    [self.tabBarController setSelectedIndex:_sourceSelectIndex];
    [self.tabBarController setViewControllers:self.sourceRootControllers animated:YES];
}

@end
