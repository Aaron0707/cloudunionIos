//
//  MyCostViewController.m
//  CloudSalePlatform
//
//  Created by kiwi on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MyCostViewController.h"
#import "Consume.h"
#import "Recharge.h"
#import "BaseTableViewCell.h"
#import "Globals.h"
//#import "NewCommentViewController.h"
#import "UIButton+NSIndexPath.h"
#import "ConsumeViewCell.h"
#import "RechargeViewCell.h"
#import "Qhtshop.h"

@interface MyCostViewController () {
    BOOL isConsume;
    NSMutableArray * shops;
    
    NSInteger selectRow;
    
    NSMutableDictionary * catchResult;
    NSString *currentSelectShopId;
}

@end

@implementation MyCostViewController

- (id)initWithConsume:(BOOL)isC
{
    if (self = [super init]) {
        isConsume = isC;
        shops = [NSMutableArray array];
        NSArray *qhtMembers = [BSEngine currentEngine].user.qhtMembers;
        NSMutableArray * shopIds = [NSMutableArray array];
        for (QhtShop *shop in qhtMembers) {
            shop.showRecord = NO;
            if (![shopIds containsObject:shop.shopId]) {
                [shopIds addObject:shop.shopId];
                
                [contentArr addObject:shop];
                [shops addObject:shop];
            }
        }
        
//         [shops addObjectsFromArray:[contentArr mutableCopy]];
//        [contentArr addObjectsFromArray:qhtMembers];
        selectRow = 0;
        
        catchResult = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = isConsume?@"门店消费":@"充值记录";
    self.tableViewCellHeight = 123;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (shops.count==1) {
        QhtShop *shop = [shops objectAtIndex:0];
         [client consumeRecord:isConsume shopId:shop.shopId];
        selectRow = 1;
        shop.showRecord = YES;
    }else{
        [tableView reloadData];
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id it = nil;
            if (isConsume) {
                it = [Consume objWithJsonDic:obj];
            } else {
                it = [Recharge objWithJsonDic:obj];
            }
            [contentArr insertObject:it atIndex:selectRow];
        }];
         [catchResult setObject:[contentArr copy] forKey:currentSelectShopId];
        [tableView reloadData];
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = contentArr[indexPath.row];
    if ([item isKindOfClass:[QhtShop class]]) {
        return 40;
    }
    if (isConsume) {
        return 213;
    } else {
        
        return 138;
    }
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = contentArr[indexPath.row];
    if ([item isKindOfClass:[QhtShop class]]) {
        QhtShop * it = item;
        static NSString * CellIdentifier = @"BaseTableViewCell";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text =it.shopName;
        cell.imageView.hidden = NO;
        [cell addArrowRight];
        
        [cell update:^(NSString *name) {
            cell.imageView.frame = CGRectMake(20, 12, 15, 15);
            if (it.isShowRecord) {
                cell.imageView.image = [UIImage imageNamed:@"triangle-red"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"triangle-green"];
            }
            cell.textLabel.left = 55;
        }];
        return cell;
    }else{
        if (isConsume) {
                Consume * it = item;
                static NSString * ConsumeCellIdentifier = @"ConsumeViewCell";
                if (!fileNib) {
                    fileNib = [UINib nibWithNibName:ConsumeCellIdentifier bundle:nil];
                    [sender registerNib:fileNib forCellReuseIdentifier:ConsumeCellIdentifier];
                }
                ConsumeViewCell * cell = [sender dequeueReusableCellWithIdentifier:ConsumeCellIdentifier];
                [cell setItem:it];
                cell.selected = NO;
                return cell;
        } else{
                Recharge * it = item;
                static NSString * CellIdentifier = @"RechargeViewCell";
                if (!fileNib) {
                    fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
                    [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
                }
                RechargeViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell setItem:it];
                cell.selected = NO;
                return cell;
        }
    }
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = contentArr[indexPath.row];
    for (QhtShop *shop in shops) {
        shop.showRecord = NO;
    }
    if ([item isKindOfClass:[QhtShop class]]) {
        [contentArr removeAllObjects];
        if (selectRow == indexPath.row+1) {
            QhtShop *shop = item;
            shop.showRecord = NO;
            [contentArr addObjectsFromArray:shops];
            [tableView reloadData];
            selectRow = 0;
        }else{
            selectRow = indexPath.row+1;
            QhtShop *shop = item;
            currentSelectShopId = shop.shopId;
            shop.showRecord = YES;
            if([[catchResult allKeys] containsObject:currentSelectShopId]){
                contentArr = [[catchResult getArrayForKey:currentSelectShopId] mutableCopy];
                [tableView reloadData];
            }else{
                 [contentArr addObjectsFromArray:shops];
                if (isFirstAppear && [super startRequest]) {
                    [client consumeRecord:isConsume shopId:currentSelectShopId];
                }
            }
        }
    }
}

@end
