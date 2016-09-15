//
//  LoginController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#define highlightedColor RGBCOLOR(169, 203, 233)
#define nolmalColor RGBCOLOR(218, 218, 219)
#import "LoginController.h"
#import "TextInput.h"

#import "RegisterUserViewController.h"
#import "ForgetPassWordViewController.h"
#import "HelpViewController.h"
#import "BasicNavigationController.h"
#import "APService.h"
#import "QhtShopListViewController.h"
#import "QhtShop.h"
#import "UserType.h"
#import "UserTypeViewController.h"

@interface LoginController () {
    IBOutlet KTextField     *   tfUserName;
    IBOutlet KTextField     *   tfPassWord;
    IBOutlet UIButton       *   btnLogin;
    IBOutlet UIButton       *   registerLogin;
    IBOutlet UIScrollView   *   scrollView;
    IBOutlet UIImageView    *   imageViewAcc;
    IBOutlet UIImageView    *   imageViewPas;
    
    UIButton * helpBtn;
    UIButton * resetPWBtn;
    
    UITapGestureRecognizer *tap;
    
    NSMutableArray *qhtMembers;
    NSMutableArray *recommendMembers;
    NSMutableArray *userTypes;
}

@end

@implementation LoginController

- (id)init {
    if (self = [super initWithNibName:@"LoginController" bundle:nil]) {
        // Custom initialization
        qhtMembers = [NSMutableArray array];
        recommendMembers = [NSMutableArray array];
        userTypes = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    Release(tfUserName);
    Release(tfPassWord);
    Release(btnLogin);
    Release(scrollView);
}

#define LineAndLabelColor RGBCOLOR(203, 203, 203)
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setEdgesNone];
    
    imageViewAcc.layer.masksToBounds =
    imageViewPas.layer.masksToBounds = YES;
    imageViewAcc.layer.borderWidth =
    imageViewPas.layer.borderWidth = 1;
    imageViewPas.layer.borderColor = nolmalColor.CGColor;
    imageViewAcc.layer.borderColor = nolmalColor.CGColor;
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    phonelabel.text = @"手  机";
    phonelabel.textColor = [UIColor grayColor];
    [phonelabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line1.backgroundColor = LineAndLabelColor;
    [imageViewAcc addSubview:phonelabel];
    [imageViewAcc addSubview:line1];
    
    UILabel *passwordlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 54, 42)];
    passwordlabel.text = @"密  码";
    passwordlabel.textColor = [UIColor grayColor];
    [passwordlabel setFont:[UIFont systemFontOfSize:15]];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 18)];
    line2.backgroundColor = LineAndLabelColor;
    [imageViewPas addSubview:passwordlabel];
    [imageViewPas addSubview:line2];
    
    self.view.backgroundColor = RGBCOLOR(241, 241, 244);
    [btnLogin commonStyle];
    [registerLogin commonStyle];
    [btnLogin setBackgroundColor:RGBCOLOR(86, 183, 236)];
    [btnLogin titleLabel].font = [UIFont systemFontOfSize:16];
    [registerLogin setBackgroundColor:RGBCOLOR(86, 183, 236)];
    
    CGRect rect = btnLogin.frame;
    helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x-10, btnLogin.bottom+5, 50, rect.size.height)];
    resetPWBtn = [[UIButton alloc] initWithFrame:CGRectMake(helpBtn.right+45, btnLogin.bottom+5, 90, rect.size.height)];
    resetPWBtn.right = btnLogin.right+10;
    [helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [helpBtn setTitleColor:RGBCOLOR(86, 183, 236) forState:UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetPWBtn setTitleColor:RGBCOLOR(86, 183, 236) forState:UIControlStateNormal];
    [resetPWBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [helpBtn setBackgroundColor:[UIColor clearColor]];
    [resetPWBtn setBackgroundColor:[UIColor clearColor]];
    resetPWBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [helpBtn addTarget:self action:@selector(clickHelpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [resetPWBtn addTarget:self action:@selector(clickResetPWBtn:) forControlEvents:UIControlEventTouchUpInside];
    [resetPWBtn titleLabel].font = [UIFont systemFontOfSize:16];
    
    [scrollView addSubview:helpBtn];
    [scrollView addSubview:resetPWBtn];
    
    [scrollView bringSubviewToFront:tfUserName];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
//#ifdef DEBUG
//    tfUserName.text = @"15196697089";
//    tfPassWord.text = @"123456";
//#else
    [self readLoginInfo];
//#endif
}

- (void)popViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnItemPressed:(UIButton*)sender {
    [tfPassWord resignFirstResponder];
    [tfUserName resignFirstResponder];
    if (tfUserName.text.length == 0) {
        // play go ...
        [tfUserName shakeAlert];
    } else if (tfPassWord.text.length == 0) {
        // play go again...
        [tfPassWord shakeAlert];
    } else {
        if ([super startRequest]) {
            [client loginWithUserPhone:tfUserName.text password:tfPassWord.text];
        }
    }
}

- (void)readLoginInfo {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    tfUserName.text = [defaults objectForKey:KBSLoginUserName];
    tfPassWord.text = [defaults objectForKey:KBSLoginPassWord];
}

- (void)saveLoginInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // save
    [defaults setObject:tfUserName.text forKey:KBSLoginUserName];
    [defaults setObject:tfPassWord.text forKey:KBSLoginPassWord];
    [defaults synchronize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [currentInputView resignFirstResponder];
    [tfPassWord resignFirstResponder];
    [tfUserName resignFirstResponder];
}

- (void)deleteLoginInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KBSLoginUserName];
    [defaults removeObjectForKey:KBSLoginPassWord];
    
	[defaults synchronize];
}

#pragma mark - Request

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSString * token = [obj objectForKey:@"msg"];
        NSArray * qhtMembersFromReq = [obj objectForKey:@"qhtMembers"];
        NSArray * certifications = [obj objectForKey:@"certifications"];
        [certifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UserType * type = [UserType objWithJsonDic:obj];
            [userTypes addObject:type];
            NSLog(@"dfasfdsafdsafdsafdsa %@",type.type);
        }];
        
        NSMutableArray * tags = [NSMutableArray array];
        [qhtMembersFromReq enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            QhtShop *shop = [QhtShop objWithJsonDic:obj];
            [qhtMembers addObject:shop];
            [tags addObject:[shop.shopId stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }];
        NSArray * recommendMembersFromReq = [obj objectForKey:@"recommendMembers"];
        [recommendMembersFromReq enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            QhtShop *shop = [QhtShop objWithJsonDic:obj];
            [recommendMembers addObject:shop];
        }];
        if (token) {
            
            User * item = [User objWithJsonDic:[obj getDictionaryForKey:@"profile"]];
            item.certifications = certifications;
            item.phone = tfUserName.text;
            item.qhtMembers = [qhtMembers copy];
            item.recommendMembers = [recommendMembers copy];
            item.orgId = [obj objectForKey:@"orgId"];
            
            
            if ([certifications count] ==1) {
                UserType * type = [userTypes objectAtIndex:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberType object:type.type];
            }
            if ([item.orgId hasValue]) {
              [tags addObject:[item.orgId stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            }
            if (item) {
                // 登录成功
                [self saveLoginInfo];
                [[BSEngine currentEngine] setCurrentUser:item password:tfPassWord.text tok:token];
                //继续登录环信
                NSDictionary *rect = [[EaseMob sharedInstance].chatManager loginWithUsername:item.imUsername password:@"123456" error:nil];
                if (rect) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                }

                NSString *uuidString = [item.orgId stringByReplacingOccurrencesOfString:@"-" withString:@""];
                //设置tag
                NSMutableSet * set = [NSMutableSet set];
                [set addObjectsFromArray:tags];
                [APService setTags:set alias:uuidString callbackSelector:nil target:nil];
                client = [[BSClient alloc] initWithDelegate:self action:@selector(requestSetPushTokenFinish:obj:)];
                [client setPushToken:uuidString];
                NSUInteger shopCount = qhtMembers.count;
                shopCount += recommendMembers.count;
                
                NSLog(@"userTypes %lu",(unsigned long)userTypes.count);
                if (userTypes.count>1) {
                    if (shopCount == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
                        QhtShop *shop = qhtMembers.count!=0?[qhtMembers objectAtIndex:0]:[recommendMembers objectAtIndex:0];
                        [[BSEngine currentEngine] setUserIsShowNearShop:shop.isOpenUnion];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberCard object:shop.shopId];
                    }
                    UserTypeViewController * con = [[UserTypeViewController alloc] init];
                    con.userTypes = userTypes;
                    con.gotoQhtShopList = shopCount>1;
                    con.qhtMembers = qhtMembers;
                    con.recommendMembers = recommendMembers;
                    [self.navigationController pushViewController:con animated:YES];
                }else{
                if (shopCount>0) {
                    if (shopCount==1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
                        QhtShop *shop = qhtMembers.count!=0?[qhtMembers objectAtIndex:0]:[recommendMembers objectAtIndex:0];
                         [[BSEngine currentEngine] setUserIsShowNearShop:shop.isOpenUnion];
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
                }
            } else {
                // 登录失败
                sender.errorMessage = @"无法获取登录用户信息";
                [sender showAlert];
            }

        }
    }
    return YES;
}

-(void)showChangeShop:(NSArray *)qhtMemberArry recommendShop:(NSArray *)recommendShops{
    
    QhtShopListViewController *con = [[QhtShopListViewController alloc]init];
    con.qhtShops = qhtMemberArry;
    con.recommendShops  = recommendShops;
    
    [self.navigationController pushViewController:con animated:YES];
}

//- (void)getMyInfo {
//    if (needToLoad) {
//        self.loading = YES;
//    }
//    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestMyInfoDidFinish:obj:)];
//    [client MyInfo];
//}
//
//- (BOOL)requestMyInfoDidFinish:(BSClient*)sender obj:(NSDictionary *)obj {
//    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray * list = [obj objectForKey:@"list"];
//        User * item = [User objWithJsonDic:list[0]];
//        item.phone = tfUserName.text;
//        item.qhtMembers = [qhtMembers copy];
//        item.recommendMembers = [recommendMembers copy];
//        if (item) {
//            // 登录成功
//            [self saveLoginInfo];
//            [[BSEngine currentEngine] setCurrentUser:item password:tfPassWord.text tok:[BSEngine currentEngine].token];
//            //继续登录环信
//            NSLog(@"imUserApplicationName %@",item.imUsername);
//            NSDictionary *rect = [[EaseMob sharedInstance].chatManager loginWithUsername:item.imUsername password:@"123456" error:nil];
//            if (rect) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//            }
//            CFUUIDRef theUUID =CFUUIDCreate(NULL);
//            CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
//            CFRelease(theUUID);
//            NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-"withString:@""];
//            //设置tag
//            NSSet * set = [NSSet setWithObjects:[item.orgId stringByReplacingOccurrencesOfString:@"-" withString:@""], nil];
//            [APService setTags:set alias:uuidString callbackSelector:nil target:nil];
//            
//            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestSetPushTokenFinish:obj:)];
//            [client setPushToken:uuidString];
//            int shopCount = qhtMembers.count;
//            shopCount += recommendMembers.count;
//            
//            if (shopCount>0) {
//                if (shopCount==1) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
//                    QhtShop *shop = qhtMembers.count!=0?[qhtMembers objectAtIndex:0]:[recommendMembers objectAtIndex:0];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeMemberCard object:shop.shopId];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }else{
//                    [self showChangeShop:qhtMembers recommendShop:recommendMembers];
//                }
//            }else{
//                [self dismissViewControllerAnimated:YES completion:^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NtfLogin object:nil];
//                }];
//            }
//        } else {
//            // 登录失败
//            sender.errorMessage = @"无法获取登录用户信息";
//            [sender showAlert];
//        }
//        
//    }
//    return YES;
//}
//
-(void)requestSetPushTokenFinish:(id)sender obj:(NSDictionary *)obj{
    [super requestDidFinish:sender obj:obj];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    if (sender == tfUserName) {
        [tfPassWord becomeFirstResponder];
    } else if (sender == tfPassWord) {
        [self btnItemPressed:btnLogin];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender {
    imageViewAcc.layer.borderColor = (sender==tfUserName)?highlightedColor.CGColor:nolmalColor.CGColor;
    imageViewPas.layer.borderColor = (sender==tfPassWord)?highlightedColor.CGColor:nolmalColor.CGColor;
    return YES;
}

#pragma mark -键盘
- (void)keyboardWillShow:(NSNotification *)note{
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGPoint point =scrollView.contentOffset;
    point.y =btnLogin.frame.origin.y-keyboardRect.origin.y+50;
    [scrollView setContentOffset:point animated:YES];
    
       tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
     [self.view addGestureRecognizer:tap];
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
    [tfUserName resignFirstResponder];
    [tfPassWord resignFirstResponder];
}
#pragma mark -CLICK HELP OR RESET
-(void)clickHelpBtn:(id)sender{
    [self.navigationController pushViewController:[[HelpViewController alloc]init] animated:YES];
}

-(void)clickResetPWBtn:(id)sender{
    [self.navigationController pushViewController:[[ForgetPassWordViewController alloc]init] animated:YES];
}

- (IBAction)registerUser:(UIButton*)sender {
    [self.navigationController pushViewController:[[RegisterUserViewController alloc]init] animated:YES];
}
@end


