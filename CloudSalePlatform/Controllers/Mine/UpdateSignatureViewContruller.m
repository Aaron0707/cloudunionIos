//
//  UpdateSigtureViewContruller.m
//  CloudSalePlatform
//
//  Created by cloud on 11/27/14.
//  Copyright (c) 2014 YunHaoRuanJian. All rights reserved.
//

#import "UpdateSignatureViewContruller.h"
#import "TextInput.h"

@interface UpdateSignatureViewContruller ()<UITextViewDelegate>{
    KTextView * textView;
}

@end

@implementation UpdateSignatureViewContruller

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"修改签名";
    
    textView = [[KTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    textView.text = _currentSignature;
    [textView setPlaceholder:@"编辑或者随机选择一个签名"];
    [textView setplaceholderTextAlignment:NSTextAlignmentLeft];
    UIButton *changeSignature = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width/2-80)/2, 170, 80, 30)];
    [changeSignature setTitle:@"点我试试" forState:UIControlStateNormal];
    [changeSignature addTarget:self action:@selector(chageSignature:) forControlEvents:UIControlEventTouchUpInside];
    [changeSignature pinkStyle];
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width)*3/4-40, 170, 80, 30)];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveSignature:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn commonStyle];

    [self.view addSubview:changeSignature];
    [self.view addSubview:saveBtn];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *signature = [[obj getDictionaryForKey:@"profile"] getStringValueForKey:@"signature" defaultValue:@""];
        if (signature.hasValue) {
            User *user = [[BSEngine currentEngine] user];
            user.signature = signature;
            [[BSEngine currentEngine]setCurrentUser:user password:nil tok:nil];
        }
        [self popViewController];
    }else{
        [self showText:@"修改失败！"];
    }
    return YES;
}

-(BOOL)requestSignatureDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSString *signature = [obj getStringValueForKey:@"msg" defaultValue:@""];
        if (signature.hasValue) {
            textView.text = signature;
            if ([textView isFirstResponder]) {
                [textView resignFirstResponder];
            }
        }
    }else{
        [self showText:@"获取失败！"];
    }
    return YES;
}

- (void) chageSignature:(UIButton *)sender{
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestSignatureDidFinish:obj:)];
    [client randomSignature];
}

- (void) saveSignature:(UIButton *)sender{
    if (!textView.text.hasValue) {
        if (![textView isFirstResponder]) {
            [textView becomeFirstResponder];
        }
        return;
    }
    [textView resignFirstResponder];
    if ([super startRequest]) {
        NSMutableDictionary *profile = [NSMutableDictionary dictionary];
        [profile setObject:textView.text forKey:@"signature"];
        [client updateProfile:profile];
    }
}
@end
