//
//  WareListViewController.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-25.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "WareListViewController.h"
#import "UIButton+NSIndexPath.h"
#import "ImageTouchView.h"
#import "Globals.h"
#import "UIImageView+WebCache.h"
#import "Ware.h"
#import "BaseTableViewCell.h"
#import "BuyWareViewController.h"
#import "WareDetailViewController.h"
#import "WareCategory.h"
@interface WareListViewController ()<ImageTouchViewDelegate>{

    UITableView * categoryTableView;
    NSMutableArray * categoryDatasource;
    
    NSMutableDictionary *cacheData;
}

@end

@implementation WareListViewController

-(id)init{
    if (self = [super init]) {
        categoryDatasource = [NSMutableArray array];
        cacheData = [NSMutableDictionary  dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self enableSlimeRefresh];
    self.navigationItem.title = @"商品列表";
    
    [self setRightBarButton:@"选择分类" selector:@selector(changeCagetory:)];
    
    categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(-100, 0, 90, tableView.height) style:UITableViewStylePlain];
    categoryTableView.delegate = self;
    categoryTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    categoryTableView.dataSource = self;
    categoryTableView.showsVerticalScrollIndicator = NO;
    categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:categoryTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)popViewController{
    categoryTableView.hidden =YES;
    [super popViewController];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client findWaresWithShopId:_shopId page:currentPage];
    }else{
        [tableView reloadData];
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Ware * it = [Ware objWithJsonDic:obj];
            [contentArr addObject:it];
        }];
        [tableView reloadData];
        if (categoryDatasource.count !=0) {
            return  YES;
        }
        client = [[BSClient alloc] initWithDelegate:self action:@selector(requestCategoryDidFinish:obj:)];
        [client findWareCategoryByShopId:_shopId];
    }
    return YES;
}

-(void)requestWaresDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Ware * it = [Ware objWithJsonDic:obj];
            [contentArr addObject:it];
        }];
        [tableView reloadData];
        
    }
}


-(void)requestCategoryDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj objectForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
            WareCategory *category = [WareCategory objWithJsonDic:obj1];
            [categoryDatasource addObject:category];
        }];
        [categoryTableView reloadData];
    }
}

#pragma mark -table数据 和delegate
-(NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section{
    if (sender !=tableView ) {
        return categoryDatasource.count;
    }
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (sender !=tableView ) {
        return 40;
    }
    
    Ware * it = contentArr[indexPath.row];
    CGFloat height = 10;
    height += [self heightofText:it.name fontSize:15];
    height += [self heightofText:it.price fontSize:15];
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (sender !=tableView) {
        static NSString * CellIdentifier = @"BaseTableViewCellForCategory";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.bottomLine =
        cell.imageView.hidden = YES;
        cell.topLine = NO;
        
        WareCategory * category = [categoryDatasource objectAtIndex:indexPath.row];
        cell.textLabel.text = category.name;
        
        return cell;
    }
    

    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    int tag = 178;
    UIButton * buyBtn = VIEWWITHTAG(cell.contentView, tag++);   // 立即抢购
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.tag =200;
        buyBtn.size = CGSizeMake( 70, 25);
        buyBtn.layer.borderColor = MyPinkColor.CGColor;
        buyBtn.layer.borderWidth =1;
        [buyBtn setTitleColor:MyPinkColor forState:UIControlStateNormal];
        [buyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyWareAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buyBtn];
    }
    
    UIImageView * line0 = [self lineWithTag:tag++ inCell:cell];   //
    buyBtn.hidden           = YES;
    
     Ware *ware = [contentArr objectAtIndex:indexPath.row];
    ImageTouchView *imageTouch = [[ImageTouchView alloc]initWithFrame:CGRectMake(10, 10, 70, 70) delegate:self];
    [imageTouch sd_setImageWithURL:[NSURL URLWithString:ware.picture] placeholderImage:[Globals getImageDefault]];
    imageTouch.tag = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    [cell.contentView addSubview:imageTouch];
    [self createMyBadge:cell Value:ware.badge Left:YES];
    
    cell.imageView.hidden = YES;
    cell.selected = NO;
    cell.detailTextLabel.text   = @"";
    buyBtn.indexPath = indexPath;
    [cell update:^(NSString *name) {
       
        cell.textLabel.frame = CGRectMake(95, 0, cell.width-110, 40);
        cell.textLabel.text =ware.name;
        cell.textLabel.textColor = RGBCOLOR(79, 79, 79);
        
        line0.top = cell.textLabel.bottom;
        line0.left = cell.textLabel.left;
        line0.width = 200;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", ware.price]];
        [attrTitle addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(0, ware.price.length)];
        [attrTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, ware.price.length)];
        cell.detailTextLabel.attributedText = attrTitle;
        cell.detailTextLabel.left = cell.textLabel.left;
        cell.detailTextLabel.top = cell.textLabel.bottom+4;
        cell.detailTextLabel.height = 40;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        buyBtn.origin = CGPointMake(cell.width - 80, cell.detailTextLabel.top + 9);
        
//        buyBtn.hidden   =
        line0.hidden    =NO;
        
    }];
    cell.selectionStyle = NO;
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (sender !=tableView ) {
        WareCategory * category = [categoryDatasource objectAtIndex:indexPath.row];
        NSArray * allKey = [cacheData allKeys];
        [contentArr removeAllObjects];
        if ([allKey containsObject:category.ID]) {
            [contentArr addObjectsFromArray:[cacheData getArrayForKey:category.ID]];
            [tableView reloadData];
        }else{
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestWaresDidFinish:obj:)];
            currentPage = 1;
            [client findwareWithCategoryId:category.ID shopId:_shopId query:nil page:currentPage];
        }
        return;
    }
    WareDetailViewController *con = [[WareDetailViewController alloc]init];
    Ware *ware = [contentArr objectAtIndex:indexPath.row];
    ware.badge = @"0";
    con.wareId  = ware.id;
    [self pushViewController:con];
}

-(void)imageTouchViewDidSelected:(ImageTouchView *)sender{
    WareDetailViewController *con = [[WareDetailViewController alloc]init];
    Ware *ware = [contentArr objectAtIndex:[sender.tag integerValue]];
    con.wareId  = ware.id;
    ware.badge = @"0";
    [self pushViewController:con];
}

- (UIImageView *)lineWithTag:(int)tag inCell:(BaseTableViewCell *)cell {
    UIImageView * line = VIEWWITHTAG(cell.contentView, tag);
    if (!line) {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, cell.width - 20, 0.5)];
        line.backgroundColor = RGBCOLOR(215, 215, 214);
        line.tag = tag;
        [cell.contentView addSubview:line];
    }
    line.hidden = YES;
    return line;
}

- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
    CGFloat height = 22;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    height += size.height;
    return height;
}

-(void)prepareLoadMoreWithPage:(int)page maxID:(int)mID{
    [client findWaresWithShopId:_shopId page:page];
}

#pragma mark - buy button
- (void)buyWareAtIndexPath:(UIButton*)sender {
    NSIndexPath * idx = sender.indexPath;
    Ware * it = contentArr[idx.row];
    BuyWareViewController * con = [[BuyWareViewController alloc] init];
    con.item = it;
    [self pushViewController:con];
}

- (void)changeCagetory:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [button setTitle:@"所有商品" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"选择分类" forState:UIControlStateNormal];
    }
    
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.5];
    //动画的内容
    [tableView beginUpdates];
    if (tableView.left==0) {
        tableView.width -=100;
        tableView.left +=100;
        categoryTableView.left +=100;
    }else{
        tableView.left = 0;
        tableView.width +=100;
        categoryTableView.left -=100;
        if ([super startRequest]) {
            currentPage = 1;
            [client findWaresWithShopId:_shopId page:currentPage];
        }
    }
    [tableView endUpdates];
    [tableView reloadData];
    //动画结束
    [UIView commitAnimations];
}
@end
