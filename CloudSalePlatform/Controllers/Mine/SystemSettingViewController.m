//
//  SystemSettingViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "BaseTableViewCell.h"
#import "AboutViewController.h"

@interface SystemSettingViewController ()

@end

@implementation SystemSettingViewController

- (void)dealloc {
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    [contentArr addObjectsFromArray:@[@"关于我们"]];
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell * cell = (BaseTableViewCell *)[super tableView:sender cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = YES;
    cell.textLabel.text = contentArr[indexPath.row];
    [cell addArrowRight];
    return cell;
}
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
   
        AboutViewController * con = [[AboutViewController alloc] init];
        [self pushViewController:con];
}

@end
