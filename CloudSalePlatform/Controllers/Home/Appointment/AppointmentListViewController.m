////
////  AppointmentListViewController.m
////  CloudSalePlatform
////
////  Created by cloud on 14/10/27.
////  Copyright (c) 2014年 Kiwaro. All rights reserved.
////
//
//#import "AppointmentListViewController.h"
//#import "BaseTableViewCell.h"
//#import "Employee.h"
//#import "UIButton+NSIndexPath.h"
//#import "Globals.h"
//
//@interface AppointmentListViewController ()
//
//@end
//
//@implementation AppointmentListViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self enableSlimeRefresh];
//    self.navigationItem.title = @"我的预约";
//    // Do any additional setup after loading the view.
//    [tableView setBackgroundColor:[UIColor whiteColor]];
//    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 18.0f, 20.0f)];
//    UIImage *backImage = [UIImage imageNamed:@"back_bakc"];
//    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backButtonItem];
//
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//     self.tabBarController.tabBar.tintColor =kBlueColor;
//    if (isFirstAppear && [super startRequest]) {
//        [client findAppointments:10 page:currentPage];
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//#pragma mark -table数据
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return contentArr.count;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Employee * it = contentArr[indexPath.row];
//    CGFloat height = 65;
//    height += ([self heightofText:it.remark fontSize:15].height+22);
//    return height;
//}
//-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * CellIdentifier = @"BaseTableViewCell";
//    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
//    int tag = 178;
//    UIButton * buyBtn = VIEWWITHTAG(cell.contentView, tag++);
//    if (!cell) {
//        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    buyBtn.hidden           =
//    cell.imageView.hidden   = NO;
//    buyBtn.indexPath = indexPath;
//    
//    //处理预约备注
//    User *user = [BSEngine currentEngine].user;
//    Employee *employee = [contentArr objectAtIndex:indexPath.row];
//    
//    [cell update:^(NSString *name) {
//        cell.imageView.hidden = NO;
//        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:employee.avatar]]];
//        cell.imageView.frame = CGRectMake(5, 10, 34, 34);
//        
//        cell.textLabel.frame = CGRectMake(50, 0, 100, 40);
//        cell.textLabel.text =employee.name;
//        cell.textLabel.textColor = RGBCOLOR(79, 79, 79);
//        
//        cell.detailTextLabel.text = employee.phone;
//        cell.detailTextLabel.left = cell.textLabel.left;
//        cell.detailTextLabel.top =18;
//        cell.detailTextLabel.height = 40;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
//    }];
//    
//    UIView *remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 55)];
//    [cell.contentView addSubview:remarkView];
//
//    UIImageView *userAvatarView =[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 34, 34)];
//    [userAvatarView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]]];
//    [remarkView addSubview:userAvatarView];
//
//    CGSize mYsize = [self heightofText:employee.remark fontSize:15];
//    UILabel *remarkLabel = [[UILabel alloc]init];
//    [remarkLabel setText:employee.remark];
//    remarkLabel.width = self.view.width-40;
//    remarkLabel.height = mYsize.height;
//    remarkLabel.left = 50;
//    remarkLabel.top = userAvatarView.top;
//    remarkLabel.textColor =RGBCOLOR(79, 79, 79);
//    remarkLabel.font =[UIFont systemFontOfSize:15];
//    [remarkView addSubview:remarkLabel];
//    
//    UILabel *userNameLabel = [[UILabel alloc]init];
//    [userNameLabel setText:user.ownerName];
//    userNameLabel.width = 100;
//    userNameLabel.height = 20;
//    userNameLabel.left = 50;
//    userNameLabel.top = remarkLabel.bottom+5;
//    userNameLabel.textColor =RGBCOLOR(79, 79, 79);
//    userNameLabel.font =[UIFont systemFontOfSize:11];
//    [remarkView addSubview:userNameLabel];
//    
//    UILabel *createTimeLabel = [[UILabel alloc] init];
//    createTimeLabel.width = 70;
//    createTimeLabel.height = 20;
//    createTimeLabel.left = self.view.width-70;
//    createTimeLabel.top = userNameLabel.top;
//    createTimeLabel.text = [Globals timeStringWith:employee.createTime.doubleValue/1000];
//    createTimeLabel.font = [UIFont systemFontOfSize:11];
//    createTimeLabel.textColor = [UIColor grayColor];
//    [remarkView addSubview:createTimeLabel];
//    
//    UIImage *bcgImg = [UIImage imageNamed:@"appointment_remark"];
//    bcgImg = [bcgImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 5, 30) resizingMode:UIImageResizingModeTile];
//    UIImageView *temp = [[UIImageView alloc]initWithImage:bcgImg];
//    CGRect rc = remarkView.frame;
//    temp.frame = rc;
//    [cell.contentView addSubview:temp];
//    [cell.contentView sendSubviewToBack:temp];
//    return cell;
//}
//
//- (UIImageView *)lineWithTag:(int)tag inCell:(BaseTableViewCell *)cell {
//    UIImageView * line2 = VIEWWITHTAG(cell.contentView, tag);
//    if (!line2) {
//        line2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, cell.width - 20, 0.5)];
//        line2.backgroundColor = RGBCOLOR(215, 215, 214);
//        line2.tag = tag;
//        [cell.contentView addSubview:line2];
//    }
//    line2.hidden = YES;
//    return line2;
//}
//
//- (CGSize)heightofText:(NSString*)text fontSize:(int)fontSize{
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
//    return size;
//}
//
//
//- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
//    
//    [client findAppointments:10 page:page];
//}
//
//#pragma mark -requestFinish
//-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray * list = [obj getArrayForKey:@"list"];
//        [contentArr removeAllObjects];
//        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Employee * it = [Employee objWithJsonDic:obj];
//            [contentArr addObject:it];
//        }];
//    }
//    [tableView reloadData];
//    return YES;
//}
//
//#pragma mark -backhome
//-(void)backHome:(id)sender{
//    [self.tabBarController setSelectedIndex:_sourceSelectIndex];
//    [self.tabBarController setViewControllers:self.sourceRootControllers animated:YES];
//}
//@end
