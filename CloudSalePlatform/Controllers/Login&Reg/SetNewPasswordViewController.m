//
//  SetNewPasswordViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-10-14.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "SetNewPasswordViewController.h"

@interface SetNewPasswordViewController (){
    
    UITextField * passwordField;
    UITextField * confirmPasswordField;
    
    UITapGestureRecognizer *tap;
    UIScrollView *scrollView;
    UIButton *nextBtn;
    UIView *confirmPasswordView;
}
    
@end

@implementation SetNewPasswordViewController

-(id)init{
    if (self=[super init]) {
        passwordField = [[UITextField alloc]init];
        [passwordField setSecureTextEntry:YES];
        confirmPasswordField = [[UITextField alloc]init];
        [confirmPasswordField setSecureTextEntry:YES];
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
    self.navigationItem.title = @"新密码";

    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect phoneFrame = CGRectMake((rect.size.width-230)/2, 150, 230, 42);
    UIView *passwordView = [[UIView alloc]initWithFrame:phoneFrame];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.borderColor =LineAndLabelColor.CGColor;
    passwordView.layer.borderWidth = 0.5;
    passwordField.frame = CGRectMake(70, 0, 170, 42);
    UILabel *passwordlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    if (self.needOldPassword) {
        passwordlabel.text = @"原密码";
    }else{
        passwordlabel.text = @"密 码";
    }
    passwordlabel.textColor = [UIColor grayColor];
    [passwordlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line1.backgroundColor = LineAndLabelColor;
    [passwordView addSubview:line1];
    [passwordView addSubview:passwordlabel];
    [passwordView addSubview:passwordField];
    [scrollView addSubview:passwordView];
    
    confirmPasswordView = [[UIView alloc]initWithFrame:[passwordView frame]];
    confirmPasswordView.top = passwordView.bottom+20;
    confirmPasswordView.backgroundColor = [UIColor whiteColor];
    confirmPasswordView.layer.borderColor =LineAndLabelColor.CGColor;
    confirmPasswordView.layer.borderWidth = 0.5;
    confirmPasswordField.frame = CGRectMake(70, 0, 170, 42);
    UILabel *confirmPasswordlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    if (self.needOldPassword) {
        confirmPasswordlabel.text = @"新密码";
    }else{
        confirmPasswordlabel.text = @"确 认";
    }
    confirmPasswordlabel.textColor = [UIColor grayColor];
    [confirmPasswordlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line2.backgroundColor = LineAndLabelColor;
    [confirmPasswordView addSubview:line2];
    [confirmPasswordView addSubview:confirmPasswordlabel];
    [confirmPasswordView addSubview:confirmPasswordField];
    [scrollView addSubview:confirmPasswordView];
    
    
    nextBtn = [[UIButton alloc] initWithFrame:[passwordView frame]];
    nextBtn.top = confirmPasswordView.bottom+30;
    [nextBtn setTitle:@"提   交" forState:UIControlStateNormal];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)clickNextBtn:(UIButton *)sender{
    
    //判断验证码是否正确然后跳转
    if (!passwordField.text || !confirmPasswordField.text) {
        return;
    }
    if (self.needOldPassword) {
        if ([super startRequest]) {
            [client resetPassword:self.phone new:confirmPasswordField.text old:passwordField.text];
        }
    }else{
        if ([passwordField.text isEqualToString:confirmPasswordField.text]) {
            if ([super startRequest]) {
                [client resetPassword:self.phone new:passwordField.text old:nil];
            }
        }else{
            [self showText:@"两次输入不一致"];
        }
    }
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    return YES;
}

#pragma mark -键盘
- (void)keyboardWillShow:(NSNotification *)note{
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [scrollView addGestureRecognizer:tap];
    
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGPoint point =scrollView.contentOffset;
    CGFloat myY = confirmPasswordView.top - keyboardRect.origin.y+105;
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
    [passwordField resignFirstResponder];
    [confirmPasswordField resignFirstResponder];
}
@end
