//
//  EditInfoViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-14.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "EditInfoViewController.h"
#import "CameraActionSheet.h"
#import "UploadPreViewController.h"
#import "QhtShop.h"
#import "QhtShopListViewController.h"


@interface EditInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, updateDidDelegate>{
    UITextField * nickNameField;
//    UIButton * maleBtn;
//    UIButton * femaleBtn;
    UIButton *addAvatar;
    UIImage * avatarImage;
    
    UITapGestureRecognizer *tap;
    UIScrollView *scrollView;
    UIButton *nextBtn;
    UIView *sexView;
    
    UIButton * sexBtn;
}

@end

@implementation EditInfoViewController

-(id)init{
    if (self = [super init]) {
        nickNameField = [[UITextField alloc]init];
    }
    return self;
}


#define LineAndLabelColor RGBCOLOR(203, 203, 203)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    self.navigationItem.title = @"个人资料";
    
    CGRect mainRect = [[UIScreen mainScreen]bounds];
    
    addAvatar = [[UIButton alloc]initWithFrame:CGRectMake((mainRect.size.width-100)/2, 100, 100, 100)];
    [addAvatar setBackgroundImage:[UIImage imageNamed:@"update_avatar"] forState:UIControlStateNormal];
    [addAvatar addTarget:self action:@selector(updateAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addAvatar];
    
    UILabel *addAvatarLabel = [[UILabel alloc]initWithFrame:CGRectMake((mainRect.size.width-74)/2, addAvatar.bottom+10, 74, 20)];
    [addAvatarLabel setText:@"上传头像"];
    [addAvatarLabel setTextColor:[UIColor grayColor]];
    [scrollView addSubview:addAvatarLabel];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect nameFrame = CGRectMake((rect.size.width-230)/2, addAvatarLabel.bottom+30, 230, 42);
    UIView *nickNameView = [[UIView alloc]initWithFrame:nameFrame];
    nickNameView.backgroundColor = [UIColor whiteColor];
    nickNameView.layer.borderColor =LineAndLabelColor.CGColor;
    nickNameView.layer.borderWidth = 0.5;
    nickNameField.frame = CGRectMake(70, 0, 170, 42);
    UILabel *nickNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    nickNamelabel.text = @"昵 称";
    nickNamelabel.textColor = [UIColor grayColor];
    [nickNamelabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line1.backgroundColor = LineAndLabelColor;
    [nickNameView addSubview:line1];
    [nickNameView addSubview:nickNamelabel];
    [nickNameView addSubview:nickNameField];
    [scrollView addSubview:nickNameView];
    
    sexView = [[UIView alloc]initWithFrame:[nickNameView frame]];
    sexView.top = nickNameView.bottom+20;
    sexView.backgroundColor = [UIColor whiteColor];
    sexView.layer.borderColor =LineAndLabelColor.CGColor;
    sexView.layer.borderWidth = 0.5;
    
    sexBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, sexView.width, sexView.height)];
    [sexBtn setTitle:@"女" forState:UIControlStateNormal];
    [sexBtn setTitleColor:MygrayColor forState:UIControlStateNormal];
    [sexBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, 180, 20, 30)];
    sexBtn.tag = 0;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(210, 6, 6, 30);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"arrow_right" isCache:YES].CGImage;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    [[sexBtn layer] addSublayer:layer];
    [sexBtn addTarget:self action:@selector(sexChange) forControlEvents:UIControlEventTouchUpInside];
//    sexBtnView.backgroundColor = RGBCOLOR(86, 183, 236);
//    sexBtnView.layer.borderColor = RGBCOLOR(86, 183, 236).CGColor;
//    sexBtnView.layer.borderWidth = 1;
//    [maleBtn setFrame:CGRectMake(50, 0, 50, 31)];
//    [femaleBtn setFrame:CGRectMake(0, 0, 50, 31)];
//    [maleBtn setBackgroundImage:[UIImage imageNamed:@"male_nor"] forState:UIControlStateNormal];
//    [maleBtn setBackgroundImage:[UIImage imageNamed:@"male_seldected"] forState:UIControlStateSelected];
//    [maleBtn addTarget:self action:@selector(sexMaleChange:) forControlEvents:UIControlEventTouchUpInside];
//    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"female_nor"] forState:UIControlStateNormal];
//    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"female_selected"] forState:UIControlStateSelected];
//    [femaleBtn addTarget:self action:@selector(sexFeMaleChange:) forControlEvents:UIControlEventTouchUpInside];
//    femaleBtn.selected = YES;
//    [sexBtnView addSubview:maleBtn];
//    [sexBtnView addSubview:femaleBtn];
//    [femaleBtn setBackgroundColor:[UIColor whiteColor]];

    UILabel *sexlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    sexlabel.text = @"性 别";
    sexlabel.textColor = [UIColor grayColor];
    [sexlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line2.backgroundColor = LineAndLabelColor;
    [sexView addSubview:line2];
    [sexView addSubview:sexBtn];
    [sexView addSubview:sexlabel];
    [scrollView addSubview:sexView];
    
    nextBtn = [[UIButton alloc] initWithFrame:[sexView frame]];
    nextBtn.top = sexView.bottom+30;
    [nextBtn setTitle:@"完   成" forState:UIControlStateNormal];
    [nextBtn commonStyle];
    [nextBtn titleLabel].font = [UIFont systemFontOfSize:16];
    [nextBtn setBackgroundColor:RGBCOLOR(86, 183, 236)];
    [nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
    //键盘监听
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)sexChange{
    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:@"性别选择" TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"女",@"男"]];
    actionSheet.tag = 1;
    [actionSheet show];
}


-(void)clickNextBtn:(UIButton *)sender{
    NSMutableDictionary *profile = [NSMutableDictionary dictionary];
    [profile setObject:self.token forKey:@"token"];
    if (!avatarImage && !nickNameField.text) {
        return;
    }
    if (avatarImage) {
        [profile setObject:[UIImage rotateImage:avatarImage] forKey:@"file"];
    }
    if (sexBtn.tag==0) {
        [profile setObject:@"FEMALE" forKey:@"gender"];
    }else{
        [profile setObject:@"MALE" forKey:@"gender"];
    }
    if (nickNameField.text) {
        [profile setObject:nickNameField.text forKey:@"nickname"];
    }
    
    if ([super startRequest]) {
        [client updateProfile:profile];
    }
}

#pragma mark - request finish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        User *user =[BSEngine currentEngine].user;
        user.nickName = [obj objectForKey:@"nickName"];
        user.avatar = [obj objectForKey:@"avatar"];
        user.name = [obj objectForKey:@"name"];
        [[BSEngine currentEngine]setCurrentUser:user password:nil tok:nil];
        
        NSUInteger shopCount = _qhtMembers.count;
        shopCount += _recommendMembers.count;
        
        if (shopCount>0) {
            if (shopCount==1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
                QhtShop *shop = _qhtMembers.count!=0?[_qhtMembers objectAtIndex:0]:[_recommendMembers objectAtIndex:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberCard object:shop.shopId];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showChangeShop:_qhtMembers recommendShop:_recommendMembers];
            }
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
            }];
        }
    }
    return YES;
}

-(void)updateAvatarAction:(UIButton *)sender{
    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:nil TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"拍一张",@"从相册选择"]];
    actionSheet.tag = 0;
    [actionSheet show];
}


#pragma mark -头像修改方法
- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (sender.tag == 0) {
        if (buttonIndex == 2) {
            return;
        }
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
    }else if (sender.tag == 1){
        if (buttonIndex ==2) {
            return ;
        }else{
            sexBtn.tag = buttonIndex;
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

-(void)saveBtnPressed:(UIImage *)image{
    [addAvatar setBackgroundImage:image forState:UIControlStateNormal];
    avatarImage = image;
    [self popViewController];
}

#pragma mark -键盘
- (void)keyboardWillShow:(NSNotification *)note{
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [scrollView addGestureRecognizer:tap];
    
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGPoint point =scrollView.contentOffset;
    CGFloat myY = sexView.top - keyboardRect.origin.y+105;
    if (myY <=0) {
        return;
    }
    point.y = myY;
    [scrollView setContentOffset:point animated:YES];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGPoint point =scrollView.contentOffset;
    point.y =0;
    [scrollView setContentOffset:point animated:YES];
    
    [tap removeTarget:self action:@selector(tapped:)];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer {
    [nickNameField resignFirstResponder];
}


-(void)showChangeShop:(NSArray *)qhtMemberArry recommendShop:(NSArray *)recommendShops{
    QhtShopListViewController *con = [[QhtShopListViewController alloc]init];
    con.qhtShops = qhtMemberArry;
    con.recommendShops  = recommendShops;
    [self.navigationController pushViewController:con animated:YES];
}
@end
