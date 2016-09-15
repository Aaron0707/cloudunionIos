//
//  MineViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "MineViewController.h"
#import "BaseTableViewCell.h"
#import "UIImage+FlatUI.h"
#import "UIImageView+WebCache.h"

#import "User.h"
#import "UserInfoViewController.h"
#import "MyCostViewController.h"
#import "FavShopsViewController.h"
#import "SystemSettingViewController.h"
#import "AccountServiceViewController.h"
#import "OnlineConsumeViewController.h"
#import "AppointmentBillViewController.h"
#import "Globals.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "RedEnvelopeRecordViewController.h"
@interface MineViewController ()<UMSocialUIDelegate> {
    BOOL                    isInThis;
    UIImageView             * headView;
    NSString * myCity;
    UILabel * livelab;
}

@property (nonatomic, strong) User *user;
@end

@implementation MineViewController
@synthesize user;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    self.user = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人中心";
    self.tableViewCellHeight = 44;
    isInThis = NO;
    UIImageView * touch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 135)];
    touch.image = LOADIMAGE(@"Mine");
//    tableView.tableHeaderView = touch;
    tableView.top = 0;
    self.view.backgroundColor =
    tableView.backgroundColor = RGBCOLOR(248, 248, 248);
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 150, 190)];
    UIView * tableHeaderView1 = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 150, 190)];
    //    tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView setBackgroundColor:[UIColor grayColor]];
    [tableHeaderView1 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:tableHeaderView1];
    [self.view addSubview:tableHeaderView];


    [self setRightBarButtonImage:[UIImage imageNamed:@"change_member_card"] highlightedImage:nil selector:@selector(btnSharePressed)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.tintColor =RGBCOLOR(63, 175, 225);

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *text = [user readConfigWithKey:@"myCity"];
    if (text) {
        myCity = [NSString stringWithFormat:@"常住地：%@",text];
    }else{
        myCity = @"常住地：";
    }
    user = [[BSEngine currentEngine] user];
    [tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)sender {
    return 3;
}

#define TitleArray @[@[@"在线消费",@"预约记录",@"门店消费",@"充值记录",@"我的会员卡"],@[@"收藏商家",@"红包记录"],@[@"设置"]]
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    BaseTableViewCell * cell = (BaseTableViewCell *)[super tableView:sender cellForRowAtIndexPath:indexPath];
    
    
    if (indexPath.section==0 &&indexPath.row==0) {
        static NSString * CellIdentifier = @"BaseTableViewCellHeader";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSString * name = user.ownerName;
        cell.textLabel.text = name;
        [cell setBottomLine:(indexPath.row == [TitleArray[indexPath.section] count] - 1)];
        [cell addArrowRight];
        if (livelab) {
            [livelab removeFromSuperview];
        }
        livelab = [UILabel linesText:myCity font:[UIFont boldSystemFontOfSize:13] wid:200 lines:1 color:[UIColor grayColor]];
        livelab.width += 8;
        livelab.height += 8;
        livelab.origin = CGPointMake(cell.imageView.right + 5, 40);
        [cell.contentView addSubview:livelab];
        cell.topLineView.hidden = (indexPath.row == 0);
        return cell;
    }else{
        static NSString * CellIdentifier = @"BaseTableViewCell";
        BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSString * str = nil;
        if (indexPath.section==0) {
           str =  TitleArray[indexPath.section][indexPath.row-1];
        }else{
            str = TitleArray[indexPath.section][indexPath.row];
        }
        cell.textLabel.text = str;
        [cell setBottomLine:(indexPath.row == [TitleArray[indexPath.section] count])];
        [cell addArrowRight];
        
        cell.topLineView.hidden = (indexPath.row == 0);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BaseTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 &&indexPath.row==0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[user avatar]] placeholderImage:[Globals getImageUserHeadDefault]];
        [cell update:^(NSString *name) {
            cell.imageView.frame = CGRectMake(10, 14, 46, 46);
            cell.textLabel.left = cell.imageView.right + 10;
            cell.textLabel.top = -10;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 23;
            cell.topLineView.frame = CGRectMake(14, 0.5, cell.width - 14, 0.5);
        }];
        cell.backgroundColor = RGBCOLOR(237, 237, 237);
    }else{
        NSString * str = nil;
        if (indexPath.section==0) {
            str =  TitleArray[indexPath.section][indexPath.row-1];
        }else{
            str = TitleArray[indexPath.section][indexPath.row];
        }
        cell.imageView.image = LOADIMAGECACHES(str);
        [cell update:^(NSString *name) {
            cell.imageView.frame = CGRectMake(10, 13, 34, 34);
            cell.textLabel.left = cell.imageView.right + 15;
            
            cell.topLineView.frame = CGRectMake(14, 0.5, cell.width - 14, 0.5);
        }];
    }
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [TitleArray[section] count]+1;
    }
    return [TitleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)sender heightForFooterInSection:(NSInteger)section {
    return 21;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        return 74;
    }
    return 60;
}

- (UIView*)tableView:(UITableView *)sender viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sender.width, 21)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    id con = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
             con = [[UserInfoViewController alloc] init];
        }else if (indexPath.row ==1) {
            con = [[OnlineConsumeViewController alloc] init];
        }else if (indexPath.row ==2) {
            con = [[AppointmentBillViewController alloc] init];
        }else if(indexPath.row ==3 || indexPath.row ==4){
            con = [[MyCostViewController alloc] initWithConsume:indexPath.row == 3];
        }else{
            con = [[AccountServiceViewController alloc] init];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row==0) { 
            con = [[FavShopsViewController alloc] init];
            ((FavShopsViewController*)con).isFav = (indexPath.row == 0);
        }else{
            con = [[RedEnvelopeRecordViewController alloc]init];
        }
    } else {
        con = [[SystemSettingViewController alloc] init];
    }
    if (con) {
        [self pushViewController:con];
    }
}

- (void)btnSharePressed {
    
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.cloudvast.com/m/m.jsp?phone=%@&type=IOS&deveiceId=%@",[user phone],[Globals getMyUUID]];
    //    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址，需要#import "UMSocialWechatHandler.h"
    [UMSocialWechatHandler setWXAppId:@"wx0d064c4cb90ecef8" appSecret:@"50bbaae1d49e923aec82c501804ed2e7"  url:shareUrl];
    
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:shareUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMShareKey
                                      shareText:UMShareMessage
                                     shareImage:[UIImage imageNamed:@"about"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite]
                                       delegate:self];
}

@end
