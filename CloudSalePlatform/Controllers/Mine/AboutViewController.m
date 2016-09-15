//
//  AboutViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseTableViewCell.h"
#import "WebViewController.h"
#import "Globals.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width , 260)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"about")];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    imageView.frame = CGRectMake((view.width - 70)/2, 80, 86, 85);
    [view addSubview:imageView];
    tableView.tableHeaderView = view;
    self.tableViewCellHeight = 42;
    [contentArr addObjectsFromArray:@[@"关于云联平台",@"用户协议",@"客服电话"]];
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell * cell = (BaseTableViewCell*)[super tableView:sender cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = contentArr[indexPath.row];
    cell.detailTextLabel.text = indexPath.row == 2?@"400-800-3826":@"";
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;

    cell.imageView.hidden = YES;
    [cell addArrowRight];
    cell.topLineView.hidden = (indexPath.row == 0);
    cell.textLabel.textColor = RGBCOLOR(112, 112, 112);
    cell.detailTextLabel.textColor = kBlueColor;
    
    cell.backgroundColor = tableView.backgroundColor;
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView.frame = CGRectMake(10, 0, tableView.width - 20, cell.height);
    
    [cell update:^(NSString *name) {
        cell.detailTextLabel.width = cell.width - 150;
        cell.detailTextLabel.left = 116;
        cell.detailTextLabel.font =
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.left = 20;
        cell.arrowlayer.frame = CGRectMake(cell.width - 30, 0, 6, cell.height);
        [self needRadius:indexPath cell:cell];
    }];
    return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 2) {
        WebViewController * con = [[WebViewController alloc] init];
        if (indexPath.row == 0) {
            con.url = AboutPage;
            con.title = @"关于云联平台";
        } else {
//            con.url = AgreementPage;
            con.url = @"http://api.cloudvast.com/legal/privacypolicy.html";
            con.title = @"用户协议";
        }
        [self pushViewController:con];
    } else {
        [Globals callAction:@"400-800-3826" parentView:self.view];
    }
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

@end
