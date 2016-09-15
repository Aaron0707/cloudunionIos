//

//  ChatListViewController.m

//  CloudSalePlatform

//

//  Created by yunhao on 14-9-27.

//  Copyright (c) 2014年 Kiwaro. All rights reserved.

//



#import "ChatListViewController.h"

#import "EaseMobBaseTableViewCell.h"

#import "ChatListCell.h"

#import "ApplyViewController.h"

#import "ChatViewController.h"

#import "ConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"

#import "SRRefreshView.h"

#import "Globals.h"

#import "UIImageView+WebCache.h"

#import "UIView+WebCacheOperation.h"

#import "KWAlertView.h"

#import <CommonCrypto/CommonDigest.h>

@interface ChatListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate,  SRRefreshDelegate,UITextViewDelegate,IChatManagerDelegate,KWAlertViewDelegate>



@property (strong, nonatomic) SRRefreshView *slimeView;

@property (nonatomic, strong)  NSMutableDictionary *allContact;



@end



@implementation ChatListViewController



-(id)init{
    
    self = [super init];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    super.willShowBackButton =YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"会话";
    
    [tableView addSubview:self.slimeView];

    [self.slimeView setLoadingWithExpansion];
 
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadChatListDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =MyPinkColor;
    User  *item =[[BSEngine currentEngine] user];
    if (![[EaseMob sharedInstance].chatManager isLoggedIn]) {
        NSDictionary *rect = [[EaseMob sharedInstance].chatManager loginWithUsername:item.imUsername password:@"123456" error:nil];
        if (rect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            NSLog(@"登陆环信");
            [self reloadChatListDataSource];
        }else{
             NSLog(@"登陆环信失败");
            [self showAlert:@"聊天登陆失败！！" isNeedCancel:NO];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBuddyRequest:) name:@"ReceiveBuddyRequest" object:nil];
    
}



- (void)didReceiveBuddyRequest:(NSNotification *)notification{
    [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:@"2"];
}


#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self reloadChatListDataSource];
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


#pragma mark -tableView DataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender

{
    return 1;
    
}



-(NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section{
    
    return contentArr.count;
    
}



-(CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
    
}



-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        
    }
    
    EMConversation *conversation = [contentArr objectAtIndex:indexPath.row];
    
    User *user = [_allContact objectForKey:conversation.chatter];
    cell.name = user.ownerName;
    
    if (!conversation.isGroup) {
        
        cell.placeholderImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]]];
        
    }
    
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    
    cell.time = [self lastMessageTimeByConversation:conversation];
    
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    
    if (indexPath.row % 2 == 1) {
        
        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        
    }else{
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return cell;
    
}





// Override to support conditional editing of the table view.

- (BOOL)tableView:(UITableView *)sender canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
    
}

- (void)tableView:(UITableView *)sender commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EMConversation *converation = [contentArr objectAtIndex:indexPath.row];
        
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO];
        
        [contentArr removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}



- (CGFloat)tableView:(UITableView *)sender heightForHeaderInSection:(NSInteger)section

{
    return 0;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)sender editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}



- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversation *conversation = [contentArr objectAtIndex:indexPath.row];
 
    ChatViewController *chatController;
    
    User * user = [_allContact objectForKey:conversation.chatter];
    
    NSString *title = user.ownerName;
    
    chatController = [[ChatViewController alloc] initWithChatter:conversation.chatter];
    
    chatController.title = title;
    
    chatController.tergatUserImageUrl = [NSURL URLWithString:user.avatar] ;
    
    [conversation markMessagesAsRead:YES];
    
    [self.navigationController pushViewController:chatController animated:YES];
    
    
    
}



#pragma mark - slimeRefresh delegate

//刷新列表

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView

{
    
//    [self reloadChatListDataSource];
    if ([super startRequest]) {
        [client contactList];
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





#pragma mark - My util



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



// 得到最后消息时间

-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation

{
    
    NSString *ret = @"";
    
    EMMessage *lastMessage = [conversation latestMessage];;
    
    if (lastMessage) {
        
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
        
    }
    
    
    
    return ret;
    
}

// 得到未读消息条数

- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation

{
    
    NSInteger ret = 0;
    
    ret = conversation.unreadMessagesCount;
    
    
    
    return  ret;
    
}



// 得到最后消息文字或者类型

-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation

{
    
    NSString *ret = @"";
    
    EMMessage *lastMessage = [conversation latestMessage];
    
    if (lastMessage) {
        
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        
        switch (messageBody.messageBodyType) {
                
            case eMessageBodyType_Image:{
                
                ret = @"[图片]";
                
            } break;
                
            case eMessageBodyType_Text:{
                
                // 表情映射。
                
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                
                ret = didReceiveText;
                
            } break;
                
            case eMessageBodyType_Voice:{
                
                ret = @"[声音]";
                
            } break;
                
            case eMessageBodyType_Location: {
                
                ret = @"[位置]";
                
            } break;
                
            case eMessageBodyType_Video: {
                
                ret = @"[视频]";
                
            } break;
                
            default: {
                
            } break;
                
        }
        
    }
    
    
    
    return ret;
    
}



#pragma mark - dataSource

- (void)reloadChatListDataSource {
    
    [contentArr removeAllObjects];
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      
                      ^(EMConversation *obj1, EMConversation* obj2){
                          
                          EMMessage *message1 = [obj1 latestMessage];
                          
                          EMMessage *message2 = [obj2 latestMessage];
                          
                          if(message1.timestamp > message2.timestamp) {
                              
                              return(NSComparisonResult)NSOrderedAscending;
                              
                          }else {
                              
                              return(NSComparisonResult)NSOrderedDescending;
                              
                          }
                          
                      }];
    
    [contentArr addObjectsFromArray:sorte];
    if (self.allContact.count!=0) {
        NSMutableArray *array = [NSMutableArray array];
        for (EMConversation *conversation in contentArr) {
            User *user = [_allContact objectForKey:conversation.chatter];
            if (user) {
                [array addObject:conversation];
            }
        }
       contentArr = [array mutableCopy];
      [tableView reloadData];
    }
}



-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    
    if ([super requestDidFinish:sender obj:obj]) {
        
        NSArray * list = [obj getArrayForKey:@"list"];
        
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            
            User * item = [User objWithJsonDic:obj];
            
            [temp setObject:item forKey:item.imUsername];
            
        }];
        
        self.allContact = temp;
        
        if (temp.count!=0) {
            
            [self reloadChatListDataSource];
            
        }
        
    }
    
    return YES;
    
}

-(void)kwAlertView:(KWAlertView *)sender didDismissWithButtonIndex:(NSInteger)index{
    [self popViewController];
}

-(void)popViewController{
    [self.tabBarController setSelectedIndex:_sourceSelectIndex];
    [self.tabBarController setViewControllers:self.sourceRootControllers animated:YES];
}

@end

