//
//  ActivityListViewController.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-26.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ActivityListViewController.h"
#import "Globals.h"
#import "Activity.h"
#import "ActivityDetailViewController.h"
#import "BaseTableViewCell.h"
#import "ImageTouchView.h"
#import "UIImageView+WebCache.h"
@interface ActivityListViewController ()<ImageTouchViewDelegate>

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableSlimeRefresh];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"店铺活动";
    
    tableView.width-=20;
    tableView.left+=10;
    tableView.top+=10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client findPromotionsByShopId:_shopId page:currentPage];
    }else{
        [tableView reloadData];
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Activity *activity = [Activity objWithJsonDic:obj];
            [contentArr addObject:activity];
        }];
        [tableView reloadData];
    }
    
    return YES;
}
#pragma mark -table 数据与代理
-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *title = VIEWWITHTAG(cell.contentView, 100);
    
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        title = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 0,0)];
        [title setNumberOfLines:0];
        [title setFont:[UIFont systemFontOfSize:16]];
        [title setLineBreakMode:NSLineBreakByWordWrapping];
        title.tag =100;
        [cell.contentView addSubview:title];
    }
    Activity * activity = [contentArr objectAtIndex:indexPath.row];
    cell.imageView.hidden = NO;
    cell.topLine = NO;
    cell.selectionStyle = NO;
    
    [self createMyBadge:cell Value:activity.badge Left:YES];
    
    CGSize size = [activity.title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(290,200) lineBreakMode:NSLineBreakByWordWrapping];
    [title setFrame:CGRectMake(5, 165, size.width, size.height)];
    title.text = activity.title;
    
    
    ImageTouchView *imageTouch = [[ImageTouchView alloc]initWithFrame:CGRectMake(0, 0, 300, 150) delegate:self];
    [imageTouch sd_setImageWithURL:[NSURL URLWithString:[activity imgPath]] placeholderImage:[Globals getImageDefault]];
    imageTouch.tag = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    [cell.contentView addSubview:imageTouch];
    [cell update:^(NSString *name){
        cell.imageView.frame = CGRectMake(0, 0, 300, 150);
        cell.height = 170+size.height;
    }];
    return cell;
}


-(void)imageTouchViewDidSelected:(ImageTouchView *)sender{
    NSInteger tag = [sender.tag integerValue];
    Activity * activity = [contentArr objectAtIndex:tag];
    activity.badge = @"0";
    ActivityDetailViewController *con = [[ActivityDetailViewController alloc] init];
    con.activityId = activity.ID;
    [self.navigationController pushViewController:con animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Activity * activity = [contentArr objectAtIndex:indexPath.row];
    CGSize size = [activity.title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(290,200) lineBreakMode:NSLineBreakByWordWrapping];
    return 180+size.height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

//- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath {
//    Activity * activity = [contentArr objectAtIndex:indexPath.row];
//    return activity.imgPath;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Activity * activity = [contentArr objectAtIndex:indexPath.row];
    activity.badge = @"0";
    ActivityDetailViewController *con = [[ActivityDetailViewController alloc] init];
    con.activityId = activity.ID;
    [self.navigationController pushViewController:con animated:YES];
}

-(void)prepareLoadMoreWithPage:(int)page maxID:(int)mID{
    [client findPromotionsByShopId:_shopId page:page];
}
@end
