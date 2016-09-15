//
//  InformationViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "InformationViewController.h"
#import "MessageOfPush.h"
#import "Globals.h"
#import "UIImage+FlatUI.h"
#import "BaseTableViewCell.h"
#import "MessageDetailViewController.h"
#import "ActivityDetailViewController.h"

#import "WareDetailViewController.h"

@interface InformationViewController (){
    BOOL selectedTag;
}

@property (nonatomic, strong) UIView  * headerView;
@end

@implementation InformationViewController

#define TitleArray @[@"用户消息",@"系统消息"]
- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableSlimeRefresh];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"message_background"]]];
    self.navigationItem.title = @"消息中心";
    
    self.tableViewCellHeight = 93;
    
    [self.navigationController.navigationBar setTintColor:BkgSkinColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =MygreenColor;
    if (isFirstAppear && [super startRequest]) {
        [self setLoading:YES content:@"正在获取消息列表"];
        [client messageList:currentPage];
    }
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    if (isloadByslime) {
        [self setLoading:YES content:@"正在重新获取消息列表"];
    } else {
        [self setLoading:YES content:@"正在加载更多消息"];
    }
    [client messageList:page];
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MessageOfPush * it = [MessageOfPush objWithJsonDic:obj];
            [contentArr addObject:it];
        }];
        [tableView reloadData];
    }
    return YES;
}
- (UIButton*)buttonWithTitle:(NSString*)title selector:(SEL)sel {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(101, 101, 101) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(138, 138, 138) cornerRadius:2] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(183, 183, 183) cornerRadius:2] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] cornerRadius:2] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentArr.count;
}

- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 35; // 上下边距30 + 内容和时间的距离10 + 时间15
    MessageOfPush * it = contentArr[indexPath.row];
    CGSize size = [it.contentDisplay sizeWithFont:[UIFont systemFontOfSize:13] maxWidth:sender.width - 60 maxNumberLines:3];
    height += size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    UILabel * timelab = VIEWWITHTAG(cell.contentView, 179);
    if (!timelab) {
        timelab = [[UILabel alloc] initWithFrame:CGRectZero];
        timelab.tag = 179;
        timelab.font = [UIFont systemFontOfSize:12];
        timelab.textAlignment = NSTextAlignmentRight;
        timelab.textColor = MygrayColor;
        [cell.contentView addSubview:timelab];
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {
            [(UILabel *)subView setText:@""];
        }else if([subView isMemberOfClass:[UIImageView class]]){
            [subView removeFromSuperview];
        }
    }
    
    MessageOfPush * it = contentArr[indexPath.row];
    timelab.text = it.createTime;
    UILabel *content = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 0,0)];
    CGSize size = [it.contentDisplay sizeWithFont:[UIFont systemFontOfSize:13] maxWidth:sender.width-60 maxNumberLines:3];
    [content setFrame:CGRectMake(60, 10, size.width, size.height)];
    content.text = it.contentDisplay;
    [content setNumberOfLines:0];
    [content setFont:[UIFont systemFontOfSize:13]];
    [cell.contentView addSubview:content];
    [cell update:^(NSString *name) {
        CGSize size = [timelab.text sizeWithFont:[UIFont systemFontOfSize:12] maxWidth:sender.width - 40 maxNumberLines:0];
        cell.textLabel.frame = CGRectMake(25, 20, cell.width - 30, cell.height - 55);
        cell.imageView.frame =  CGRectMake(10, 10, 34, 34);
        cell.detailTextLabel.font =
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.frame = CGRectMake(15, cell.textLabel.bottom + 10, 120, 15);
        timelab.frame = CGRectMake(cell.width - size.width - 10, cell.detailTextLabel.top,size.width, size.height);
    }];
    cell.topLine = YES;
    return cell;
}

-(void)tableView:(UITableView *)sender willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageOfPush * it = contentArr[indexPath.row];
    NSString *imageName = nil;
    if ([@"CONSUME" isEqualToString:it.type]) {
        imageName = @"门店消费";
    }else if ([@"RECHARGE" isEqualToString:it.type]){
        imageName = @"充值记录";
    }else if([@"ACTIVITY" isEqualToString:it.type]){
        imageName = @"push_message_act";
    }else if([@"BIRTHSMS" isEqualToString:it.type]){
        imageName = @"push_message_BIRTHSMS";
    }else{
        imageName = @"push_message";
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
}
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    MessageOfPush * it = [contentArr objectAtIndex:indexPath.row];
    if([@"ACTIVITY" isEqualToString:it.type]){
        ActivityDetailViewController * con = [[ActivityDetailViewController alloc] init];
        con.activityId = it.contentId;
        [self pushViewController:con];
    }else if([@"WARE" isEqualToString:it.type]){
        WareDetailViewController * con = [[WareDetailViewController alloc] init];
        con.wareId = it.contentId;
        [self pushViewController:con];
    }else{
        MessageDetailViewController * con = [[MessageDetailViewController alloc] init];
        con.message = it;
        [self pushViewController:con];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)sender commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageOfPush * it = contentArr[indexPath.row];
        
        [tableView beginUpdates];
        [contentArr removeObjectAtIndex:indexPath.row];
        [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView  endUpdates];
        client  = [[BSClient alloc] initWithDelegate:self action:@selector(requestRemoveMessage:obj:)];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [client removeMessageOfCenter:it.id];
//        });
    }
}

-(void)requestRemoveMessage:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSLog(@"删除消息！！！");
    }
}
@end
