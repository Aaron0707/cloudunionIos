//
//  ContactListViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ContactListViewController.h"
#import "EaseMobBaseTableViewCell.h"
#import "ChineseToPinyin.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "SRRefreshView.h"
#import "AddFriendViewController.h"
#import "Globals.h"
#import "ContactDetailViewController.h"

#import <CommonCrypto/CommonDigest.h>
@interface ContactListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate,  SRRefreshDelegate,UITextViewDelegate,IChatManagerDelegate>{
    UIButton *addButton;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UILabel *unapplyCountLabel;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (nonatomic, strong)  NSMutableDictionary *allContact;
@end

@implementation ContactListViewController

-(id)init{
    self = [super init];
    if (self) {
        _sectionTitles = [NSMutableArray array];
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad {
    super.willShowBackButton=YES;
    [super viewDidLoad];
    self.navigationItem.title = @"联系人";
    [tableView addSubview:self.slimeView];
//    [self.slimeView setLoadingWithExpansion];
    [self setEdgesNone];
    [self.searchBar setSearchBarBackgroundColor:RGBCOLOR(202, 199, 205)];
    [self.view addSubview:self.searchBar];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.top += 113;
    tableView.top += 44;
    tableView.height -= 44;
    [self.mySearchDisplayController.searchBar setNeedsDisplay];
    
    [addButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [tableView setBackgroundColor:[UIColor whiteColor]];
//    self.tabBarItem.badgeValue = @"10";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =RGBCOLOR(127, 49, 151);
    
    if (self.allContact.count==0) {
        if ([super startRequest]) {
            [client contactList];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBuddyRequest:) name:@"ReceiveBuddyRequest" object:nil];
    [self reloadApplyView];
}


- (void)didReceiveBuddyRequest:(NSNotification *)notification{
     [self reloadApplyView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}


- (void)didReceiveMessage:(EMMessage *)message{
     [[[self.tabBarController.tabBar items] objectAtIndex:0] setBadgeValue:@"1"];
}
#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark -requestFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        NSMutableArray * tempcatact = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            
            User * item = [User objWithJsonDic:obj];
            
            [temp setObject:item forKey:item.imUsername];
            [tempcatact addObject:item];
        }];
        
        self.allContact = temp;
        [contentArr removeAllObjects];
        [contentArr addObjectsFromArray:[self sortDataArray:tempcatact]];
        if (temp.count!=0) {
            [self reloadDataSource];
        }
        
    }
    
    return YES;

}

-(void)requestDeleteContactFinish:(BSClient *)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [tableView reloadData];
    }
}


#pragma mark -tableView DataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender
{
    if (sender == tableView) {
        return contentArr.count+1;
    }
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section{
    if (sender == tableView) {
        if (section==0) {
            return 1;
        }else{
            return [[contentArr objectAtIndex:(section - 1)] count];
        }
    }else{
        return filterArr.count;
    }

}

-(CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self contactListCell:sender cellForRowAtIndexPath:indexPath];
    
}
-(void)tableView:(UITableView *)sender willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
     if (sender == tableView) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                cell.imageView.image = [UIImage imageNamed:@"newFriends"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
        }
     }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)sender canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (sender != tableView) {
        return NO;
    }
    if (indexPath.section == 0) {
        return NO;
        [self isViewLoaded];
    }
    return YES;
}
- (void)tableView:(UITableView *)sender commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            EMBuddy *buddy = [[contentArr objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
            User * user =[[contentArr objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
            
            [tableView beginUpdates];
            [[contentArr objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView  endUpdates];
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error;
                [[EaseMob sharedInstance].chatManager removeBuddy:user.imUsername removeFromRemote:YES error:&error];
                if (!error) {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:user.imUsername deleteMessages:YES];
                }
                client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDeleteContactFinish:obj:)];
                [client deleteContact:user.imUsername targetImUsername:[BSEngine currentEngine].user.imUsername];

//            });
        }
    
}

- (CGFloat)tableView:(UITableView *)sender heightForHeaderInSection:(NSInteger)section
{

    if (section == 0 || [[contentArr objectAtIndex:(section - 1)] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)sender viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || [[contentArr objectAtIndex:(section - 1)] count] == 0)
    {
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)sender
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[contentArr objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)sender editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0 && sender == tableView) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
            }
        }else{
    //        User * user =[[contentArr objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    //        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:user.imUsername];
    //        chatVC.title = user.ownerName;
    //        chatVC.tergatUserImageUrl = [[NSURL alloc]initWithString:user.avatar];
    //        [self.navigationController pushViewController:chatVC animated:YES];
            User * user = nil;
            if (sender !=tableView) {
                user = [filterArr objectAtIndex:indexPath.row];
            }else{
                user = [[contentArr objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
            }
            ContactDetailViewController *con = [[ContactDetailViewController alloc] init];
            con.user =user;
            con.myFriend = YES;
            [self pushViewController:con];
        }

}


#pragma mark 创建联系人列表的cell
-(UITableViewCell *)contactListCell:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"EaseMobBaseTableViewCell";
    EaseMobBaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[EaseMobBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    if (tableView == sender) {
        
    
    if (indexPath.section == 0) {
        cell = (EaseMobBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if (cell == nil) {
            cell = [[EaseMobBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"newFriends"];
        cell.textLabel.text = @"申请与通知";
        [cell addSubview:self.unapplyCountLabel];
    } else{
        static NSString *CellIdentifier = @"ContactListCell";
        cell = (EaseMobBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseMobBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.indexPath = indexPath;
        User * user =[[contentArr objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]];
        cell.textLabel.text = user.ownerName;
    }
        
    }else{
        static NSString *CellIdentifier = @"ContactListCell";
        cell = (EaseMobBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseMobBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.indexPath = indexPath;
        User * user =[filterArr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]];
        cell.textLabel.text = user.ownerName;
    }
    return cell;
}
#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    
    if (self.allContact.count!=0) {
       [self reloadDataSource];
    }
    [_slimeView endRefresh];
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}


- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addController animated:YES];
}


#pragma mark - My util
- (UILabel *)unapplyCountLabel {
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 20, 20)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = [UIFont systemFontOfSize:11];
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.height / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    
    return _unapplyCountLabel;
}
- (SRRefreshView *)slimeView {
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (User *user in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
//        User *user = [_allContact objectForKey:buddy.username];
//        NSString *str = buddy.username;
         NSString *str = user.ownerName;
//        if (user && user.ownerName) {
//            str = user.ownerName;
//        }
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:str];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:user];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(User *obj1, User *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.ownerName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.ownerName];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;

}

- (void)reloadDataSource
{
    [self showHudInView:self.view hint:@"刷新数据..."];
//    [contentArr removeAllObjects];
//    
//    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
//    NSLog(@"环信好友个数 %i",buddyList.count);
//    NSMutableArray *buddys = [NSMutableArray array];
//    for (EMBuddy *buddy in buddyList) {
//        if (buddy.followState != eEMBuddyFollowState_NotFollowed) {
//            [buddys addObject:buddy];
//        }
//    }
//  
//    [contentArr addObjectsFromArray:[self sortDataArray:buddys]];
    
    [tableView reloadData];
    [self hideHud];
}

- (void)reloadApplyView
{
    NSInteger numb = [[[ApplyViewController shareController] dataSource] count];
    
    if (numb == 0) {
        self.unapplyCountLabel.hidden = YES;
    }
    else
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%li", (long)numb];
        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 20 ? size.width : 20;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
}

-(void)popViewController{
    [self.tabBarController setSelectedIndex:_sourceSelectIndex];
    [self.tabBarController setViewControllers:self.sourceRootControllers animated:YES];
}


#pragma mark - Filter
- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {
//    [contentArr enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop) {
//        
//            if ([user.ownerName rangeOfString:searchText].location <= user.ownerName.length) {
//                [filterArr addObject:user];
//            }
//    }];
    [contentArr enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        [arr enumerateObjectsUsingBlock:^(User *user, NSUInteger idx, BOOL *stop) {
            if ([user.ownerName rangeOfString:searchText].location <= user.ownerName.length) {
                                [filterArr addObject:user];
                            }
        }];
    }];
}
@end
