//
//  RedEnvelopeRecordViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 15/1/9.
//  Copyright (c) 2015年 YunHaoRuanJian. All rights reserved.
//

#import "RedEnvelopeRecordViewController.h"
#import "Gift.h"
#import "BaseTableViewCell.h"
#import "Globals.h"

@interface RedEnvelopeRecordViewController ()

@end

@implementation RedEnvelopeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包记录";
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([super startRequest]) {
        [client findRedEnvelopes];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = object;
            NSArray * gifts = [dic objectForKey:@"list"];
            NSMutableArray * temp = [NSMutableArray array];
            for (NSDictionary * gt in gifts) {
                Gift * gift = [Gift objWithJsonDic:gt];
                [temp addObject:gift];
            }
            [dic removeObjectForKey:@"list"];
            [dic setValue:[temp copy] forKey:@"gifts"];
            [dic setValue:@"0" forKey:@"isShowRecord"];
            [contentArr addObject:dic];
        }];
        [tableView reloadData];
    }
    return YES;
}


#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = contentArr[indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        return 40;
    }else{
        return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = contentArr[indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary * it = item;
        static NSString * CellIdentifier = @"BaseTableViewCell";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text =[it objectForKey:@"orgName"];
        cell.imageView.hidden = NO;
        [cell addArrowRight];
        
        cell.topLine  = NO;
        cell.bottomLine = YES;
        
        [cell update:^(NSString *name) {
            cell.imageView.frame = CGRectMake(20, 12, 15, 15);
            if ([[it objectForKey:@"isShowRecord"] isEqualToString:@"1"]) {
                cell.imageView.image = [UIImage imageNamed:@"triangle-red"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"triangle-green"];
            }
            cell.textLabel.left = 55;
        }];
        return cell;
    }else{
        Gift * it = item;
        static NSString * CellIdentifier = @"BaseTableViewCellWithGift";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [it.type isEqualToString:@"WARE"]?it.targetName:it.content;
        cell.imageView.hidden = YES;
        cell.detailTextLabel.text = [Globals sendTimeString:it.createTime.doubleValue];
        [cell update:^(NSString *name) {
            cell.textLabel.left =
            cell.detailTextLabel.left = 20;
            cell.textLabel.top = -10;
//             cell.bottomLineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"change_card_cellline"]];
            cell.bottomLineView.left =10;
            cell.detailTextLabel.top = 20;
            
            cell.textLabel.numberOfLines = 2;
        }];
        
        cell.topLine = NO;
        cell.bottomLine = YES;
       
        
        return cell;
    }
}

-(void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = contentArr[indexPath.row];
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary * it = item;
        if ([[it objectForKey:@"isShowRecord"] isEqualToString:@"1"]) {
            [it setValue:@"0" forKey:@"isShowRecord"];
            NSArray * list = [it objectForKey:@"gifts"];
            for (Gift * gift in list) {
                [contentArr removeObject:gift];
            }
            [tableView reloadData];
        }else{
            [it setValue:@"1" forKey:@"isShowRecord"];
            NSArray * list = [it objectForKey:@"gifts"];
            for (int i=0; i<list.count; i++) {
                [contentArr insertObject:list[i] atIndex:i+indexPath.row+1];
            }
            [tableView reloadData];
        }
    }
}


@end
