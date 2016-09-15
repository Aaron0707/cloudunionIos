//
//  CommentsViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-29.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CommentsViewController.h"
#import "Comment.h"
#import "BaseTableViewCell.h"
#import "Globals.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"评论列表";
    [self enableSlimeRefresh];
    needToLoad = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear && [super startRequest]) {
        [self setLoading:YES content:@"正在获取评论列表"];
        [client findCommentWithId:_shopId wareId:_wareId page:currentPage];
    }
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    if (isloadByslime) {
        [self setLoading:YES content:@"正在重新获取评论列表"];
    } else {
        [self setLoading:YES content:@"正在加载更多评论"];
    }
    [client findCommentWithId:_shopId wareId:_wareId page:page];
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Comment * it = [Comment objWithJsonDic:obj];
            [contentArr addObject:it];
        }];
        [tableView reloadData];
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 10;
    Comment * it = contentArr[indexPath.row];
    CGSize size = [it.creatorName sizeWithFont:[UIFont systemFontOfSize:10] maxWidth:sender.width - 45 maxNumberLines:1];
    height += size.height + 10;
    size = [it.content sizeWithFont:[UIFont systemFontOfSize:13] maxWidth:sender.width - 35 maxNumberLines:0];
    height += size.height + 15;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel * unitLable = VIEWWITHTAG(cell.contentView, 11);   // 商品服务名字 / 时间
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        unitLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, sender.width - 35, 40)];
        unitLable.tag = 11;
        [cell.contentView addSubview:unitLable];
    }
    Comment * it = contentArr[indexPath.row];

    cell.imageView.hidden = YES;
    [cell update:^(NSString *name) {
        UIFont * font = [UIFont systemFontOfSize:12];
        NSString * str = it.creatorName;
        if (str.length == 0) {
            str = @"匿名用户";
        }
        CGSize size = [str sizeWithFont:font maxWidth:cell.width - 45 maxNumberLines:1];
        cell.textLabel.font = font;
        cell.textLabel.text = str;
        unitLable.textColor =
        cell.textLabel.textColor =MygrayColor;
        cell.textLabel.top = 10;
        cell.textLabel.width = size.width;
        cell.textLabel.height = 14;
        unitLable.hidden = NO;
        unitLable.font = font;
        unitLable.frame = CGRectMake(cell.textLabel.right + 10, cell.textLabel.top, 120, 18);
        unitLable.text = [Globals convertDateFromString:it.createTime timeType:2];
        
        cell.detailTextLabel.text = it.content;
        cell.detailTextLabel.left = 10;
        cell.detailTextLabel.top = cell.textLabel.bottom+10;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        size = [it.content sizeWithFont:cell.detailTextLabel.font maxWidth:cell.width - 45 maxNumberLines:1];
        cell.detailTextLabel.height = size.height;
    }];
    return  cell;
}
@end
