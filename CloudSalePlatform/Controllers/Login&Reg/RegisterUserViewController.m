//
//  RegisterUserViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-13.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "Globals.h"
#import "KAlertView.h"
#import "QhtShop.h"
#import "APService.h"
#import "QhtShopListViewController.h"

@interface RegisterUserViewController (){
    
    UITextField * phoneField;
    UITextField * verificationField;
    UITextField * passwordField;
    UITextField * recommendPhoneField;
    
    UIView *passwordView;
    
    UIButton *verificationBtn;
    
    UIButton *checkBtn;
    
    UIScrollView *scrollView;
    UITapGestureRecognizer *tap;
    UISwipeGestureRecognizer *recognizer;
    
    UIButton *nextBtn;
}

@end


@implementation RegisterUserViewController


-(id)init{
    if (self=[super init]) {
        phoneField = [[UITextField alloc] init];
        verificationField = [[UITextField alloc]init];
        passwordField  = [[UITextField alloc] init];
        recommendPhoneField  = [[UITextField alloc] init];
        [passwordField setSecureTextEntry:YES];
    }
    return self;
}

#define LineAndLabelColor RGBCOLOR(203, 203, 203)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:scrollView];
    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    self.navigationItem.title = @"注册";
  
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect phoneFrame = CGRectMake((rect.size.width-230)/2, 43, 230, 42);
    UIView *phoneView = [[UIView alloc]initWithFrame:phoneFrame];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.borderColor =LineAndLabelColor.CGColor;
    phoneView.layer.borderWidth = 0.5;
    phoneField.frame = CGRectMake(70, 0, 160, 42);
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    phonelabel.text = @"手   机";
    phonelabel.textColor = [UIColor grayColor];
    [phonelabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line1.backgroundColor = LineAndLabelColor;
    [phoneView addSubview:line1];
    [phoneView addSubview:phonelabel];
    [phoneView addSubview:phoneField];
    [scrollView addSubview:phoneView];
    
    UIView *verificationView = [[UIView alloc]initWithFrame:[phoneView frame]];
    verificationView.top = phoneView.bottom+20;
    verificationView.backgroundColor = [UIColor whiteColor];
    verificationView.layer.borderColor =LineAndLabelColor.CGColor;
    verificationView.layer.borderWidth = 0.5;
    verificationField.frame = CGRectMake(70, 0, 110, 42);
    UILabel *verificationlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    verificationlabel.text = @"验证码";
    verificationlabel.textColor = [UIColor grayColor];
    [verificationlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line2.backgroundColor = LineAndLabelColor;
    verificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(180, 1, 50, 40)];
    [verificationBtn setBackgroundColor:MygreenColor];
    [verificationBtn setTitle:@"获取" forState:UIControlStateNormal];
    [verificationBtn addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
    [verificationView addSubview:verificationBtn];
    [verificationView addSubview:line2];
    [verificationView addSubview:verificationlabel];
    [verificationView addSubview:verificationField];
    [scrollView addSubview:verificationView];
    
    passwordView = [[UIView alloc]initWithFrame:[phoneView frame]];
    passwordView.top = verificationView.bottom+20;
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.borderColor =LineAndLabelColor.CGColor;
    passwordView.layer.borderWidth = 0.5;
    passwordField.frame = CGRectMake(70, 0, 160, 42);
    UILabel *passwordlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    passwordlabel.text = @"密   码";
    passwordlabel.textColor = [UIColor grayColor];
    [passwordlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line3.backgroundColor = LineAndLabelColor;
    [passwordView addSubview:line3];
    [passwordView addSubview:passwordlabel];
    [passwordView addSubview:passwordField];
    [scrollView addSubview:passwordView];
    
    UIView *recommendPhoneView = [[UIView alloc]initWithFrame:[phoneView frame]];
    recommendPhoneView.top = passwordView.bottom+20;
    recommendPhoneView.backgroundColor = [UIColor whiteColor];
    recommendPhoneView.layer.borderColor =LineAndLabelColor.CGColor;
    recommendPhoneView.layer.borderWidth = 0.5;
    recommendPhoneField.frame = CGRectMake(100, 0, 160, 42);
    UILabel *recommendPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 94, 42)];
    recommendPhoneLabel.text = @"推荐人手机";
    recommendPhoneLabel.textColor = [UIColor grayColor];
    [recommendPhoneLabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(90, 12, 1, 18)];
    line4.backgroundColor = LineAndLabelColor;
    [recommendPhoneView addSubview:recommendPhoneField];
    [recommendPhoneView addSubview:recommendPhoneLabel];
    [recommendPhoneView addSubview:line4];
    [scrollView addSubview:recommendPhoneView];
    
    checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(passwordView.left+22, 0, 12, 12)];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(agreeAgreement:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.top = recommendPhoneView.bottom+33;
    checkBtn.selected = YES;
    [scrollView addSubview:checkBtn];
    UILabel *agreementLabel1 = [[UILabel alloc]init];
    [agreementLabel1 setSize:CGSizeMake(85, 20)];
    agreementLabel1.top = recommendPhoneView.bottom+30;
    agreementLabel1.left = recommendPhoneView.left+38;
    agreementLabel1.text = @"我已阅读并同意";
    agreementLabel1.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:agreementLabel1];
    UILabel *agreementLabel2 = [[UILabel alloc]init];
    [agreementLabel2 setSize:CGSizeMake(110, 20)];
    agreementLabel2.top = recommendPhoneView.bottom+30;
    agreementLabel2.left = agreementLabel1.right;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"使用条款和隐私政策"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    agreementLabel2.attributedText = content;
    agreementLabel2.textColor = RGBCOLOR(86, 183, 236);
    agreementLabel2.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:agreementLabel2];
    
    nextBtn = [[UIButton alloc] initWithFrame:[phoneView frame]];
    nextBtn.top = checkBtn.bottom+30;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn commonStyle];
    [nextBtn setBackgroundColor:RGBCOLOR(86, 183, 236)];
    [nextBtn titleLabel].font = [UIFont systemFontOfSize:16];
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
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown)];
    [scrollView addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -back
-(void)popViewController{
    [self.navigationController setNavigationBarHidden:YES];
    [super popViewController];
}

#pragma mark -All button TouchUpInside
-(void)agreeAgreement:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(void)clickNextBtn:(UIButton *)sender{
    
    //验证注册信息然后跳转
    if(client || !phoneField.text || !verificationField.text || !passwordField.text || !checkBtn.selected){
        return;
    }
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestRegisterFinish:obj:)];
    [client registerPassport:phoneField.text verifyCode:verificationField.text Password:passwordField.text recommendPhone:recommendPhoneField.text];
}


-(void)getVerification:(UIButton *)sender{
   [phoneField resignFirstResponder];
    if (![Globals isPhoneNumber:phoneField.text]) {
        [KAlertView showType:KAlertTypeError text:@"请输入手机号码" for:0.8 animated:YES];
        [phoneField becomeFirstResponder];
        return;
    }
    if ([super startRequest]) {
        [client getVerifyCode:phoneField.text Type:REGISTER];
    }
}

#pragma mark - All requestFinish

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        verificationBtn.enabled = NO;
        [verificationBtn setBackgroundColor:MygrayColor];
        
        [self performSelector:@selector(openVerificationBtn) withObject:nil afterDelay:60.0f];
    }
    return YES;
}

-(void)openVerificationBtn{
    verificationBtn.enabled = YES;
    [verificationBtn setBackgroundColor:MygreenColor];
}
-(void)requestRegisterFinish:(BSClient *)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *token = [obj objectForKey:@"msg"];
        NSMutableArray * qhtMembers = [NSMutableArray array];
        NSMutableArray * recommendMembers = [NSMutableArray array];
        NSArray * qhtMembersFromReq = [obj objectForKey:@"qhtMembers"];
        [qhtMembersFromReq enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            QhtShop *shop = [QhtShop objWithJsonDic:obj];
            [qhtMembers addObject:shop];
        }];
        NSArray * recommendMembersFromReq = [obj objectForKey:@"recommendMembers"];
        [recommendMembersFromReq enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            QhtShop *shop = [QhtShop objWithJsonDic:obj];
            [recommendMembers addObject:shop];
        }];
//        [self getMyInfo];
        User * item = [User objWithJsonDic:[obj getDictionaryForKey:@"profile"]];
        item.phone = phoneField.text;
        item.qhtMembers = [qhtMembers copy];
        item.recommendMembers = [recommendMembers copy];
        if (item && token) {
            // 登录成功
            [self saveLoginInfo];
            [[BSEngine currentEngine] setCurrentUser:item password:passwordField.text tok:token];
            //继续登录环信
            NSLog(@"imUserApplicationName %@",item.imUsername);
            NSDictionary *rect = [[EaseMob sharedInstance].chatManager loginWithUsername:item.imUsername password:@"123456" error:nil];
            if (rect) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            }

            NSString * uuidString = [item.orgId stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //设置tag
            NSSet * set = [NSSet setWithObjects:[item.orgId stringByReplacingOccurrencesOfString:@"-" withString:@""], nil];
            [APService setTags:set alias:uuidString callbackSelector:nil target:nil];
            
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestSetPushTokenFinish:obj:)];
            [client setPushToken:uuidString];

            NSUInteger shopCount = qhtMembers.count;
            shopCount += recommendMembers.count;
            
            if (shopCount>0) {
                if (shopCount==1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
                    QhtShop *shop = qhtMembers.count!=0?[qhtMembers objectAtIndex:0]:[recommendMembers objectAtIndex:0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberCard object:shop.shopId];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self showChangeShop:qhtMembers recommendShop:recommendMembers];
                }
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
                }];
            }

            
        } else {
            // 登录失败
            sender.errorMessage = @"无法获取登录用户信息";
            [sender showAlert];
        }

    }
}

-(void)showChangeShop:(NSArray *)qhtMemberArry recommendShop:(NSArray *)recommendShops{
    QhtShopListViewController *con = [[QhtShopListViewController alloc]init];
    con.qhtShops = qhtMemberArry;
    con.recommendShops  = recommendShops;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)saveLoginInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // save
    [defaults setObject:phoneField.text forKey:KBSLoginUserName];
    [defaults setObject:passwordField.text forKey:KBSLoginPassWord];
    
    [defaults synchronize];
}

#pragma mark -键盘
- (void)keyboardWillShow:(NSNotification *)note{
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [scrollView addGestureRecognizer:tap];
    
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[[self getFirstReSponder:self.view] convertRect: recommendPhoneField.bounds toView:window];
    CGPoint point =scrollView.contentOffset;
    CGFloat myY = rect.origin.y - keyboardRect.origin.y+100;
    if (myY <=0) {
        return;
    }
    point.y = myY;
    [scrollView setContentOffset:point animated:YES];
}

-(UIView *)getFirstReSponder:(UIView *)view{
    for (UIView * firstResp in view.subviews) {
        if (firstResp.isFirstResponder) {
            return firstResp;
        }else{
            if (firstResp.subviews.count>0) {
                 UIView * view2= [self getFirstReSponder:firstResp];
                if (view2) {
                    return view2;
                }
            }
        }
    }
    return nil;
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
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
    [verificationField resignFirstResponder];
    [recommendPhoneField resignFirstResponder];
}


-(void)requestSetPushTokenFinish:(id)sender obj:(NSDictionary *)obj{
    [super requestDidFinish:sender obj:obj];
}


@end
