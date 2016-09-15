//
//  ServiceDetailViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-30.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "MemberDetail.h"
#import "BaseTableViewCell.h"
#import "Globals.h"
#import "UIImageView+WebCache.h"

@interface ServiceDetailViewController ()
@property (nonatomic, strong, readonly) MemberDetail * item;
@end

@implementation ServiceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员卡片";
    tableView.allowsSelection = NO;
    self.tableViewCellHeight = 50;
//    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 145)];
//    view.image = [Globals getImageUserHeadDefault];
//    [view sd_setImageWithURL:[NSURL URLWithString:_item.gallery] placeholderImage:LOADIMAGE(@"big_acc")];
//    tableView.tableHeaderView = view;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [client memberDetail:_memberId];
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        _item = [MemberDetail objWithJsonDic:obj];
        [tableView reloadData];
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1+(_item.times.count>0?1:0)+(_item.directs.count>0?1:0);
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return _item.times.count+1;
    } else {
        return _item.directs.count+1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier]; if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.imageView.hidden = YES;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"我的卡金";
                cell.detailTextLabel.text =_item.balanceOfCash;
                break;
            case 1:
                cell.textLabel.text = @"我的赠金";
                cell.detailTextLabel.text =_item.balanceOfBonus;
                break;
            case 2:
                cell.textLabel.text = @"我的云浩币";
                cell.detailTextLabel.text =_item.balanceOfUnionCurrency;
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        cell.detailTextLabel.text = @"";
        if (indexPath.row == 0) {
            cell.textLabel.text = @"服务次数";
        } else {
            TimeInDetail * it = _item.times[indexPath.row-1];
            cell.textLabel.text = it.poolName;
            cell.detailTextLabel.text = it.remainedTimes;
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"定向金额";
        } else {
            DirectInDetail * it = _item.directs[indexPath.row-1];
            cell.textLabel.text = it.categoryName;
            cell.detailTextLabel.text = it.remainedAmount;
        }
    }
    [cell update:^(NSString *name) {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = RGBCOLOR(73, 73, 73);
        cell.detailTextLabel.left = cell.width - 120;
        cell.detailTextLabel.width = 100;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)sender heightForFooterInSection:(NSInteger)section {
    return 14;
}

- (UIView*)tableView:(UITableView *)sender viewForFooterInSection:(NSInteger)section {

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sender.width, 14)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
