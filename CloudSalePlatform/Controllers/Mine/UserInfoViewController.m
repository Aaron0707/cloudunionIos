//
//  UserInfoViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "UserInfoViewController.h"
#import "BaseTableViewCell.h"
#import "CameraActionSheet.h"
#import "UploadPreViewController.h"
#import "AppDelegate.h"
#import "KWAlertView.h"
#import "UIImageView+WebCache.h"
#import "Globals.h"
#import "TextInput.h"
#import "UpdateSignatureViewContruller.h"
#import "SetNewPasswordViewController.h"
#import "ManagerAddressViewController.h"

@interface UserInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, updateDidDelegate> {
    UIImageView * headView;
    
    KTextView *inputText;
    UIView *inputView;
     UIButton *sendBtn;
}

@end

@implementation UserInfoViewController

#define TitleArray @[@[@"头像",@"昵称",@"个性签名",@"性别"],@[@"修改密码",@"常用地址"]]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    [contentArr addObjectsFromArray:TitleArray];
    tableView.backgroundColor = self.view.backgroundColor =[UIColor whiteColor];
//      tableView.height -=150;
    CGFloat height = tableView.height - 352;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, height)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (Sys_Version >= 7) {
        height-=64;
    }
    [btn addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(15, height - 50, tableView.width - 30, 40);
    [btn navBlackStyle];
    [view addSubview:btn];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    tableView.tableFooterView = view;
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 7, 40, 40)];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = headView.height/2;
    headView.tag = 176;
    [headView sd_setImageWithURL:[NSURL URLWithString:[[[BSEngine currentEngine] user] avatar]] placeholderImage:[Globals getImageUserHeadDefault]];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [tableView reloadData];
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"修改成功"];
        User * currentUser = [[BSEngine currentEngine] user];
        User * afterUpdate = [User objWithJsonDic:[obj getDictionaryForKey:@"profile"]];
        
        currentUser.signature = afterUpdate.signature;
        currentUser.nickName = afterUpdate.nickName;
        currentUser.gender = afterUpdate.gender;
        
        [[BSEngine currentEngine] setCurrentUser:currentUser password:nil tok:nil];
        [tableView reloadData];
    }
    return YES;
}

- (void)signOut {
    [self showAlert:@"确定要注销当前账号吗？" isNeedCancel:YES];
}

- (void)kwAlertView:(KWAlertView*)sender didDismissWithButtonIndex:(NSInteger)index {
    if (index == 1) {
        [[AppDelegate instance] signOut];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [TitleArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 55;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell * cell = (BaseTableViewCell *)[super tableView:sender cellForRowAtIndexPath:indexPath];
    UIImageView * view = VIEWWITHTAG(cell.contentView, 176);
    if (!view && indexPath.row == 0 && indexPath.section==0) {
        [cell.contentView addSubview:headView];
    }
    cell.textLabel.text = TitleArray[indexPath.section][indexPath.row];
//    cell.imageView.hidden = YES;
    [cell setBottomLine:YES];
    cell.topLine = NO;
    [cell addArrowRight];
    User * user = [[BSEngine currentEngine] user];
    if (indexPath.section==0) {
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = user.ownerName;
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.text = user.signature;
        } else if (indexPath.row == 3)  {
            cell.detailTextLabel.text = [user.gender isEqualToString:@"FEMALE"]?@"女":@"男";
        }
    }else{
       if (indexPath.row == 1) {
           cell.detailTextLabel.text = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCity"];
        }
    }
    
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    [cell update:^(NSString *name) {
        cell.imageView.image = [UIImage imageNamed:TitleArray[indexPath.section][indexPath.row]];
        cell.imageView.frame = CGRectMake(14, 10, 34, 34);
        cell.textLabel.frame = CGRectMake(58, 16, 100, 20);
        cell.backgroundView.backgroundColor = sender.backgroundColor;
        if (indexPath.row != [TitleArray[indexPath.section] count]-1) {
            cell.bottomLineView.frame = CGRectMake(14, cell.height - 0.5, cell.width - 14, 0.5);
        }else{
            cell.bottomLineView.frame = CGRectMake(0, cell.height - 0.5, cell.width, 0.5);
        }
        
//        cell.topLineView.frame = CGRectMake(14, 0.5, cell.width - 14, 0.5);
        cell.detailTextLabel.frame = CGRectMake(120, 0, cell.width - 140, cell.height);
        cell.detailTextLabel.numberOfLines =1;
    }];
    return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:nil TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"拍一张",@"从相册选择"]];
            actionSheet.tag = 0;
            [actionSheet show];
        }else if (indexPath.row ==1){
             [self initInputTextWithSendBtnTag:-1];
            inputText.placeholder = @"修改昵称";
            [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
        }else if (indexPath.row == 2){
            UpdateSignatureViewContruller * con = [[UpdateSignatureViewContruller alloc]init];
            con.currentSignature = [BSEngine currentEngine].user.signature;
            [self pushViewController:con];
        }else{
            CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:@"性别选择" TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"女",@"男"]];
            actionSheet.tag = 1;
            [actionSheet show];
        }
    }else{
        if (indexPath.row == 0) {
            //修改密码
            SetNewPasswordViewController *con = [[SetNewPasswordViewController alloc]init];
            con.phone = [BSEngine currentEngine].user.phone;
            con.needOldPassword = YES;
            [self pushViewController:con];
        }else{
            [self pushViewController: [[ManagerAddressViewController alloc]init]];
        }
    }
}

- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    if (sender.tag==0) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if (buttonIndex == 0){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                [self showText:@"无法打开相机"];
            }
        } else if (buttonIndex == 1) {
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        [self presentModalController:picker animated:YES];
        
    }else{
         NSMutableDictionary *profile = [NSMutableDictionary dictionary];
        if (buttonIndex ==0){
            [profile setObject:@"FEMALE" forKey:@"gender"];
        }else{
            [profile setObject:@"MALE" forKey:@"gender"];
        }
        if ([super startRequest]) {
            [client updateProfile:profile];
        }
    }
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    img = [UIImage rotateImage:img];
    UploadPreViewController * up = [[UploadPreViewController alloc] init];
    up.image = img;
    up.del = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self pushViewController:up];
    }];
}


- (void)updateDid:(id)obj path:(NSString*)path {
    headView.image = obj;
    [[[BSEngine currentEngine] user] setAvatar:path];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = inputView.frame;
        rect.origin.y = keyboardRect.origin.y-110;
        inputView.frame = rect;
    }];
    [self.view bringSubviewToFront:inputView];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = inputView.frame;
        rect.origin.y = keyboardRect.origin.y;
        inputView.frame = rect;
    }];
}


- (void)initInputTextWithSendBtnTag:(int)tag{
    if(!inputText){
        inputText = [[KTextView alloc] init];
        inputText.layer.masksToBounds = YES;
        inputText.layer.cornerRadius = 3.0;
        inputText.returnKeyType = UIReturnKeyDefault;//键盘按钮名称
        inputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        [inputText setFrame:CGRectMake(20,10, rect.size.width-150, 30)];
        inputText.layer.borderColor = RGBACOLOR(210, 213, 218,1).CGColor;
        inputText.layer.borderWidth = 1;
        inputText.layer.cornerRadius = 4;
        inputView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 50)];
        //        inputView.backgroundColor = RGBACOLOR(210, 213, 218,1);
        inputView.layer.borderWidth =1;
        inputView.layer.borderColor =RGBACOLOR(210, 213, 218,1).CGColor;
        inputView.backgroundColor = [UIColor whiteColor];
        [inputView addSubview:inputText];
        
        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-60, 10, 50, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn pinkStyle];
        [inputView addSubview:cancelBtn];
        
        sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-120, 10, 50, 30)];
        [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(updateUserNickName:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn commonStyle];
        [inputView addSubview:sendBtn];
        
        [self.view addSubview:inputView];
    }
    sendBtn.tag = tag;
    inputText.text = @"";
    [inputText becomeFirstResponder];
}

- (void)tapped:(UIButton *)tap{
    [inputText resignFirstResponder];
}
- (void)updateUserNickName:(UIButton *)btn{
    if (!inputText.text.hasValue) {
        return;
    }
    [inputText resignFirstResponder];
    NSMutableDictionary *profile = [NSMutableDictionary dictionary];
    [profile setObject:inputText.text forKey:@"nickname"];
    //修改昵称
    if ([super startRequest]) {
        [client updateProfile:profile];
    }
}

@end
