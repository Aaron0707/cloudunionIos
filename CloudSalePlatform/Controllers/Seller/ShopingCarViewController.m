//
//  ShopingCarViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/12/26.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//

#import "ShopingCarViewController.h"
#import "BaseTableViewCell.h"
#import "ShoppingCartItem.h"
#import "UIButton+NSIndexPath.h"
#import "CartItemAndBillItem.h"
#import "WareDetailViewController.h"
#import "PaymentViewController.h"

@interface ShopingCarViewController (){
    NSMutableSet *checkedItems;
    NSMutableArray * checkedBtns;
    
    UILabel *checkedCountLabel;
    UILabel *totalPriceLabel;
    
    UIButton *checkAllBtn;
    UIButton * buyButton;
    UIButton * deleteButton;
    
    UIButton * rightBtn;
}
@end

@implementation ShopingCarViewController


-(id)init{
    if (self = [super init]) {
        checkedBtns = [NSMutableArray array];
        checkedItems = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableSlimeRefresh];
    self.navigationItem.title = @"购物车";
    tableView.top +=2;
    tableView.height -=55;
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-168, tableView.width, 55)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:footerView];
    
    checkAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(7, 10, 25, 25)];
    [checkAllBtn setBackgroundImage:[UIImage imageNamed:@"unchecked_pink"] forState:UIControlStateNormal];
    [checkAllBtn setBackgroundImage:[UIImage imageNamed:@"checked_pink"] forState:UIControlStateSelected];
    [checkAllBtn addTarget:self action:@selector(checkedShoppingcartItem:) forControlEvents:UIControlEventTouchUpInside];
    checkAllBtn.indexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    [checkedBtns addObject:checkAllBtn];
    [footerView addSubview:checkAllBtn];
    
    UILabel * allCheck = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 40, 25)];
    allCheck.text = @"全选";
    [allCheck setFont:[UIFont systemFontOfSize:14]];
    [footerView addSubview:allCheck];
    
    buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(tableView.width-100, 15, 80, 30);
    [buyButton pinkStyle];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:buyButton];
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(tableView.width-100, 15, 80, 30);
    [deleteButton pinkStyle];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [deleteButton setTitle:@"删除选项" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delegateCartItem:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.hidden = YES;
    [footerView addSubview:deleteButton];
    
    totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 13, tableView.width-190, 20)];
    [totalPriceLabel setTextColor:MyPinkColor];
    [totalPriceLabel setFont:[UIFont systemFontOfSize:14]];
    totalPriceLabel.text = @"合计：￥0.00";
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:totalPriceLabel];
    
    checkedCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 28, tableView.width-190, 20)];
    [checkedCountLabel setTextColor:MygrayColor];
    [checkedCountLabel setFont:[UIFont systemFontOfSize:12]];
    checkedCountLabel.text = @"共计0件商品";
    checkedCountLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:checkedCountLabel];
    
    
    rightBtn =[self buttonWithTitle:@"编辑" image:nil selector:@selector(editCart:)];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [rightBtn setTitleColor:MygreenColor forState:UIControlStateNormal];
    
    UIBarButtonItem * itemRight = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = itemRight;
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.tintColor =MyPinkColor;
    [super viewDidAppear:animated];
    if ([super startRequest]) {
        //         if (isFirstAppear) {
        [client findShoppingCartItems];
    }
    
    [checkedItems removeAllObjects];
    [self updateTotalPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -requestDidFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
        NSArray * list = [obj objectForKey:@"list"];
        [contentArr removeAllObjects];
        [list enumerateObjectsUsingBlock:^(id b, NSUInteger idx, BOOL *stop) {
            ShoppingCartItem * item = [ShoppingCartItem objWithJsonDic:b];
            if (item.items.count !=0) {
                [contentArr addObject:item];
            }
        }];
        [tableView reloadData];
    }
    return YES;
}

-(void)requestCreateBillDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *billId = [obj getStringValueForKey:@"msg" defaultValue:@""];
        if (billId.hasValue) {
            PaymentViewController * con = [[PaymentViewController alloc] init];
            con.billId = billId;
            [self pushViewController:con];
        }
    }
}

-(void)requestUpdateCartItemDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
    }
}

-(void)requestDeleteCartItemDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        for (CartItemAndBillItem * ware in checkedItems) {
            ware.num = @"0";
        }
        
        for (ShoppingCartItem *item in contentArr) {
            NSMutableArray * newCartItems = [NSMutableArray array];
            for (CartItemAndBillItem *cartItem in item.items) {
                if (![cartItem.num isEqualToString:@"0"]) {
                    [newCartItems addObject:cartItem];
                }else{
                    [checkedItems removeObject:cartItem];
                }
            }
            if (newCartItems.count==0) {
                [contentArr removeObject:item];
            }
            if (newCartItems.count!= item.items.count) {
                item.items = [newCartItems copy];
            }
        }
        [self updateTotalPrice];
        [tableView reloadData];
        
        __block int allCount = 0;
        [contentArr enumerateObjectsUsingBlock:^(ShoppingCartItem * obj, NSUInteger idx, BOOL *stop) {
            allCount +=obj.items.count;
        }];
        if (allCount == 0) {
            checkAllBtn.selected = NO;
        }else{
            checkAllBtn.selected = (checkedItems.count ==allCount);
        }
    }
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    [self setLoading:YES];
    [checkedItems removeAllObjects];
    [self updateTotalPrice];
    checkAllBtn.selected = NO;
    [contentArr removeAllObjects];
    [client findShoppingCartItems];
}

#pragma mark -TableView method of delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return contentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ShoppingCartItem *item = [contentArr objectAtIndex:section];
    return item.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}

-(UIView *)tableView:(UITableView *)sender viewForHeaderInSection:(NSInteger)section{
    UIView * sectionHeaderView = [[UIView alloc] init];
    [sectionHeaderView setBackgroundColor:[UIColor whiteColor]];
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(7, 10, 25, 25)];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"unchecked_pink"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checked_pink"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkedShoppingcartItem:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.indexPath = [NSIndexPath indexPathForRow:-1 inSection:section];

    BOOL checkedAllOfShop = YES;
    ShoppingCartItem * item = contentArr[section];
    for (CartItemAndBillItem * wsc in item.items) {
        if (![checkedItems containsObject:wsc]) {
            checkedAllOfShop = NO;
        }
    }
    checkBtn.selected = checkedAllOfShop;
    
    [checkedBtns addObject:checkBtn];
    [sectionHeaderView addSubview:checkBtn];
    
    UILabel * shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, tableView.width - 100, 40)];
    shopNameLabel.numberOfLines = 1;
    shopNameLabel.text = item.wareOrgName;
    [sectionHeaderView addSubview:shopNameLabel];
    return sectionHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel * priceLabel = VIEWWITHTAG(cell.contentView, 101);
    UIButton *checkBtn  = VIEWWITHTAG(cell.contentView, 102);
    
    UIButton *upButton = VIEWWITHTAG(cell.contentView, 103);
    UIButton *downButton = VIEWWITHTAG(cell.contentView, 104);
    UITextField  *numberField = VIEWWITHTAG(cell.contentView, 105);
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        priceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(tableView.width-90, 15, 80, 50)];
        [priceLabel setTextColor:MyPinkColor];
        priceLabel.numberOfLines = 2;
        priceLabel.tag = 101;
        priceLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:priceLabel];
        
        checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(7, 37, 25, 25)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"unchecked_pink"] forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"checked_pink"] forState:UIControlStateSelected];
        [checkBtn addTarget:self action:@selector(checkedShoppingcartItem:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.tag = 102;
        [checkedBtns addObject:checkBtn];
        [cell.contentView addSubview:checkBtn];
        
        upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [upButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [upButton addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [downButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        upButton.tag = 103;
        downButton.tag = 104;
        [cell.contentView addSubview:upButton];
        [cell.contentView addSubview:downButton];
        
        numberField = [[UITextField alloc] init];
        numberField.textAlignment = NSTextAlignmentCenter;
        numberField.layer.borderWidth = 0.5;
        numberField.layer.borderColor = MygrayColor.CGColor;
        numberField.tag = 105;
        [cell.contentView addSubview:numberField];
    }
    
    cell.superTableView = sender;
    cell.indexPath = indexPath;
    
    checkBtn.indexPath = indexPath;
    
    ShoppingCartItem * item = [contentArr objectAtIndex:indexPath.section];
    CartItemAndBillItem * ware = item.items[indexPath.row];
    checkBtn.selected = [checkedItems containsObject:ware];
    
    upButton.hidden =
    downButton.hidden =
    numberField.hidden = !rightBtn.selected;
    upButton.indexPath =
    downButton.indexPath = indexPath;
    [cell update:^(NSString *name) {
        cell.textLabel.text = ware.wareName;
        cell.textLabel.numberOfLines =2;
        cell.textLabel.top -=15;
        cell.textLabel.width = tableView.width -200;
        cell.textLabel.left +=30;
        cell.detailTextLabel.text = rightBtn.selected?@"数量：":[NSString stringWithFormat:@"数量：%@",ware.num];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",[ware skuPrice]];
        cell.detailTextLabel.left +=30;
        cell.detailTextLabel.top -=10;
        cell.imageView.left +=30;
        numberField.text = ware.num;
        
        upButton.frame = CGRectMake(cell.textLabel.left +100, 56, 25, 25);
        downButton.frame = CGRectMake(cell.textLabel.left +35, 56, 25, 25);
        numberField.frame = CGRectMake(cell.textLabel.left +65, 56, 30, 25);
    }];
    
    if (!deleteButton.hidden) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!deleteButton.hidden) {
        return;
    }
    
    ShoppingCartItem * item = [contentArr objectAtIndex:indexPath.section];
    CartItemAndBillItem * ware = item.items[indexPath.row];
    WareDetailViewController *con = [[WareDetailViewController alloc] init];
    con.wareId = ware.wareId;
    [self pushViewController:con];
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCartItem * item = [contentArr objectAtIndex:indexPath.section];
    CartItemAndBillItem * ware = item.items[indexPath.row];
    return ware.picture;
}

#pragma mark - create bill delegate
-(void)createBillSuccess{
    [contentArr removeAllObjects];
    [checkedItems removeAllObjects];
    [tableView reloadData];
    
    [self updateTotalPrice];
}


#pragma mark -Util
-(void)checkedShoppingcartItem:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSIndexPath * indexPath = btn.indexPath;
    if (indexPath && indexPath.section >-1) {
        ShoppingCartItem * item = [contentArr objectAtIndex:indexPath.section];
        if (indexPath.row >-1) {
            CartItemAndBillItem *ware = [item.items objectAtIndex:indexPath.row];
            if (btn.selected) {
                [checkedItems addObject:ware];
            }else{
                [checkedItems removeObject:ware];
            }
            
            BOOL checkedAllOfShop = YES;
            UIButton *tempBtn = nil;
            for (UIButton *button in checkedBtns) {
                if (button.indexPath.section == btn.indexPath.section && button.indexPath.row == -1) {
                    tempBtn = button;
                }
            }
            for (CartItemAndBillItem * wsc in item.items) {
                if (![checkedItems containsObject:wsc]) {
                    checkedAllOfShop = NO;
                }
            }
            tempBtn.selected = checkedAllOfShop;
        }else{
            if (btn.selected) {
                [checkedItems addObjectsFromArray:item.items];
                NSLog(@"items %lu",(unsigned long)[item.items count]);
            }else{
                [item.items enumerateObjectsUsingBlock:^(ShoppingCartItem * obj, NSUInteger idx, BOOL *stop) {
                    [checkedItems removeObject:obj];
                }];
            }
            
            [checkedBtns enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL *stop) {
                if (button.indexPath.section == btn.indexPath.section && button.indexPath.row!=-1) {
                    button.selected = btn.selected;
                }
            }];
        }
    }else{
        if (btn.selected) {
            [contentArr enumerateObjectsUsingBlock:^(ShoppingCartItem *item, NSUInteger idx, BOOL *stop) {
                [checkedItems addObjectsFromArray:item.items];
            }];
        }else{
            [checkedItems removeAllObjects];
        }
        [checkedBtns enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL *stop) {
            button.selected = btn.selected;
        }];
    }
    
    NSLog(@"选择量 %lu",(unsigned long)[checkedItems count]);
    __block int allCount = 0;
    [contentArr enumerateObjectsUsingBlock:^(ShoppingCartItem * obj, NSUInteger idx, BOOL *stop) {
        allCount +=obj.items.count;
    }];
    checkAllBtn.selected = (checkedItems.count ==allCount && checkedItems.count!=0);
    [self updateTotalPrice];
}

-(void)updateTotalPrice{
    float totalPrice = 0;
    for (CartItemAndBillItem * obj in checkedItems) {
        totalPrice +=(obj.skuPrice.floatValue)*(obj.num.intValue);
    }
    totalPriceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",totalPrice];
    checkedCountLabel.text =[NSString stringWithFormat:@"共计%lu件商品",(unsigned long)[checkedItems count]];
}


-(void)buy:(UIButton *)btn{
    if (checkedItems.count ==0) {
        [self showText:@"请选择商品"];
        return;
    }
    
    NSMutableArray * data = [NSMutableArray array];
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestCreateBillDidFinish:obj:)];
    [checkedItems enumerateObjectsUsingBlock:^(CartItemAndBillItem * obj, BOOL *stop) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:obj.wareId forKey:@"wareId"];
        if (obj.skuId.hasValue) {
          [dic setObject:obj.skuId forKey:@"skuId"];
        }
        [dic setObject:obj.num forKey:@"num"];
        [dic setValue:obj.ID forKey:@"shoppingCartItemId"];
        [data addObject:dic];
    }];
    [client createBill:nil data:data];
}

-(void)delegateCartItem:(UIButton *)btn{
    NSMutableArray *list = [NSMutableArray array];
    for (CartItemAndBillItem * ware in checkedItems) {
        [list addObject:ware.ID];
    }
    
    if (list.count!=0) {
        [self setLoading:YES];
        client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestDeleteCartItemDidFinish:obj:)];
        [client deleteShoppingCartItems:list];
    }
    
    [self editCart:(UIButton *)self.navigationItem.rightBarButtonItem.customView];
    
}

-(void)editCart:(UIButton *)btn{
    btn.selected = !btn.selected;
    totalPriceLabel.hidden =
    checkedCountLabel.hidden =
    buyButton.hidden = btn.selected;
    deleteButton.hidden = !btn.selected;
    [tableView reloadData];
}

-(void)changeNumber:(UIButton *)btn{
    NSIndexPath *path = btn.indexPath;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:path];
    UITextField * filed = VIEWWITHTAG(cell.contentView,105);
    if (btn.tag == 103) {
        filed.text = [NSString stringWithFormat:@"%i",(filed.text.intValue+1)];
    }else{
        if ([filed.text isEqualToString:@"1"]) {
            return;
        }
        filed.text = [NSString stringWithFormat:@"%i",(filed.text.intValue-1)];
    }
    
    ShoppingCartItem * item = [contentArr objectAtIndex:path.section];
    CartItemAndBillItem * ware = item.items[path.row];
    ware.num = filed.text;
    [self updateTotalPrice];
    
    [self setLoading:YES];
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestUpdateCartItemDidFinish:obj:)];
    [client updateShoppingCartItemById:ware.ID num:ware.num];
}



@end
