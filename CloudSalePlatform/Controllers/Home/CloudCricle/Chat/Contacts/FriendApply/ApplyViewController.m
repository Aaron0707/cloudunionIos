/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ApplyViewController.h"
#import "UIViewController+HUD.h"
#import "ApplyFriendCell.h"
#import "ApplyEntity.h"
#import "User.h"
#import "BSClient.h"

static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ApplyFriendCellDelegate>{
    NSMutableDictionary *contactsArr;
}
@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        contactsArr = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.navigationItem.title = @"申请通知";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 18.0f, 20.0f)];
    UIImage *backImage = [UIImage imageNamed:@"back_bakc"];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
     [self loadDataSourceFromLocalDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.tableView reloadData];
    
}

-(void)showBackButton{}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        User * user = [contactsArr objectForKey:entity.applicantUsername];
        if (entity && user) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style integerValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = @"群组通知";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = @"群组通知";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
                cell.titleLabel.text = user.ownerName;
                cell.headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]];
            }
            cell.contentLabel.text = entity.reason;
        }
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:entity.reason];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style integerValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager acceptInvitationFromGroup:entity.groupId error:&error];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
        }
        
        [self hideHud];
        if (!error) {
            //云联系统好友添加
            BSClient *client = [[BSClient alloc] initWithDelegate:self action:@selector(requestDidFinish: obj:)];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            [client addContact:entity.applicantUsername targetImUsername:loginName];
            [self.dataSource removeObject:entity];
            [entity deleteEntity];
            [self.tableView reloadData];
            [self save];
        }
        else{
            [self showHint:@"接受失败"];
        }
    }
}
-(void)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    
}
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style integerValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleGroupInvitation) {
            [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:entity.groupId toInviter:entity.applicantUsername reason:@""];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            NSString *reason = [NSString stringWithFormat:@"被拒绝加入群组\'%@\'", entity.groupSubject];
            [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:entity.groupId groupname:entity.groupSubject toApplicant:entity.applicantUsername reason:reason];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:entity.applicantUsername reason:@"" error:&error];
        }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            [entity deleteEntity];
            [self.tableView reloadData];
            [self save];
        }
        else{
            [self showHint:@"拒绝失败"];
        }
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    [self save];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity *newEntity = [ApplyEntity createEntity];
            newEntity.applicantUsername = applyUsername;
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            [_dataSource insertObject:newEntity atIndex:0];
            
            if (![contactsArr objectForKey:applyUsername]) {
                BSClient * client = [[BSClient alloc]initWithDelegate:self action:@selector(requestUserDidFinish:obj:)];
                [client findProfileByImUserName:applyUsername];
            }
            
            [self.tableView reloadData];
            if (style != ApplyStyleFriend) {
                [self save];
            }
        }
    }
}

-(void)requestUserDidFinish:(id)sender obj:(NSDictionary *)obj{
    
    NSArray *list = [obj objectForKey:@"list"];
    if (list.count>0) {
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            User *user  = [User objWithJsonDic:obj];
            [contactsArr setValue:user forKey:user.imUsername];
        }];
        [self.tableView reloadData];
    }
}

- (void)loadDataSourceFromLocalDB
{
//    [_dataSource removeAllObjects];
//    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
//    if(loginName && [loginName length] > 0)
//    {
//        NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@ and style = %i", loginName, ApplyStyleFriend];
//        [ApplyEntity deleteAllMatchingPredicate:deletePredicate];
//        
//        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"receiverUsername = %@", loginName];
//        NSFetchRequest *request = [ApplyEntity requestAllWithPredicate:searchPredicate];
//        NSArray *applyArray = [ApplyEntity executeFetchRequest:request];
//        [self.dataSource addObjectsFromArray:applyArray];
//        
//        [self.tableView reloadData];
//    }
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
