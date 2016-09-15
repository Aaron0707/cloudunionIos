//
//  ForgetPassWordViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-14.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ForgetPassWordViewController.h"

#import "SetNewPasswordViewController.h"

#import "Globals.h"
#import "KAlertView.h"

@interface ForgetPassWordViewController (){
    UITextField * phoneField;
    UITextField * verificationField;
    
    UIButton *verificationBtn;
    
    UITapGestureRecognizer *tap;
    UIScrollView *scrollView;
    UIButton *nextBtn;
    UIView *verificationView;
}

@end

@implementation ForgetPassWordViewController

-(id)init{
    if (self=[super init]) {
        phoneField = [[UITextField alloc] init];
        verificationField = [[UITextField alloc]init];
        
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
    
    self.navigationItem.title = @"忘记密码";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect phoneFrame = CGRectMake((rect.size.width-230)/2, 150, 230, 42);
    UIView *phoneView = [[UIView alloc]initWithFrame:phoneFrame];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.borderColor =LineAndLabelColor.CGColor;
    phoneView.layer.borderWidth = 0.5;
    phoneField.frame = CGRectMake(70, 0, 160, 42);
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    phonelabel.text = @"手   机";
    phonelabel.textColor = [UIColor grayColor];
    [phonelabel setFont:[UIFont systemFontOfSize:14]];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line1.backgroundColor = LineAndLabelColor;
    [phoneView addSubview:line1];
    [phoneView addSubview:phonelabel];
    [phoneView addSubview:phoneField];
    [scrollView addSubview:phoneView];

    verificationView = [[UIView alloc]initWithFrame:[phoneView frame]];
    verificationView.top = phoneView.bottom+20;
    verificationView.backgroundColor = [UIColor whiteColor];
    verificationView.layer.borderColor =LineAndLabelColor.CGColor;
    verificationView.layer.borderWidth = 0.5;
    verificationField.frame = CGRectMake(70, 0, 110, 42);
    UILabel *verificationlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    verificationlabel.text = @"验证码";
    verificationlabel.textColor = [UIColor grayColor];
    [verificationlabel setFont:[UIFont systemFontOfSize:14]];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line2.backgroundColor = LineAndLabelColor;
    verificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(180, 1, 50, 42)];
    [verificationBtn setBackgroundColor:MygreenColor];
    [verificationBtn setTitle:@"获取" forState:UIControlStateNormal];
    [verificationBtn addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
    [verificationView addSubview:verificationBtn];
    [verificationView addSubview:line2];
    [verificationView addSubview:verificationlabel];
    [verificationView addSubview:verificationField];
    [scrollView addSubview:verificationView];
    
    nextBtn = [[UIButton alloc] initWithFrame:[phoneView frame]];
    nextBtn.top = verificationView.bottom+30;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn commonStyle];
    [[nextBtn titleLabel] setFont:[UIFont systemFontOfSize:16]];
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

#pragma mark -back
-(void)popViewController{
    [self.navigationController setNavigationBarHidden:YES];
    [super popViewController];
}


#pragma mark -All button TouchUpInside
-(void)clickNextBtn:(UIButton *)sender{
    
    //判断验证码是否正确然后跳转
    if(client || !phoneField.text){
        return;
    }
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestVerifyCodeFinish:obj:)];
    [client verifyCode:phoneField.text Code:verificationField.text];
}

-(void)getVerification:(UIButton *)sender{
    if (![Globals isPhoneNumber:phoneField.text]) {
        [KAlertView showType:KAlertTypeError text:@"请输入手机号码" for:0.8 animated:YES];
        [phoneField becomeFirstResponder];
        return;
    }
    if ([super startRequest]) {
        [client getVerifyCode:phoneField.text Type:FORGETPASSWORD];
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

-(void)requestVerifyCodeFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        SetNewPasswordViewController *con = [[SetNewPasswordViewController alloc]init];
        con.phone = phoneField.text;
        [self.navigationController pushViewController:con animated:YES];
    }
}

#pragma mark -键盘
- (void)keyboardWillShow:(NSNotification *)note{
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [scrollView addGestureRecognizer:tap];
    
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGPoint point =scrollView.contentOffset;
    CGFloat myY = verificationView.top - keyboardRect.origin.y+105;
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
    [phoneField resignFirstResponder];
    [verificationField resignFirstResponder];
}

@end
