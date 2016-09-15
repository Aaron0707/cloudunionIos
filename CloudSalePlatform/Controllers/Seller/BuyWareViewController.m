//
//  BuyWareViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BuyWareViewController.h"
#import "Ware.h"
#import "UIButton+Bootstrap.h"
#import "DAKeyboardControl.h"
#import "MemberDetail.h"

@interface BuyWareViewController () {
    IBOutlet UIButton * btn;
    IBOutlet UILabel * name;       // 单价 ¥
    IBOutlet UILabel * price;       // 单价 ¥
    IBOutlet UITextField * number; // 数量
    IBOutlet UILabel * totalprice;
    IBOutlet UITextField * paymentOfCard;
    IBOutlet UITextField * paymentOfUnionCurrency;
    IBOutlet UIScrollView * scrollView;
    NSString * password;
    int numbers;
    NSString * balanceOfCash; // 卡金余额
    NSString * balanceOfUnionCurrency; //云浩币余额
}

@end

@implementation BuyWareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付购买";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [btn navBlackStyle];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    name.text = _item.name;
    totalprice.text =
    price.text = [NSString stringWithFormat:@"¥%@",_item.price];
    price.textColor = MyPinkColor;
    totalprice.textColor =MyPinkColor;
    balanceOfCash =
    balanceOfUnionCurrency = @"0";
    paymentOfCard.placeholder = [NSString stringWithFormat:@"现有卡金余额%@", balanceOfCash];
    paymentOfUnionCurrency.placeholder = [NSString stringWithFormat:@"现有云浩币余额%@", balanceOfUnionCurrency];
    numbers = 1;
    __block BuyWareViewController * blockView = self;
    [blockView.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGRect tFrame = [scrollView convertRect:currentInputView.frame fromView:scrollView];
        CGFloat tmpY = tFrame.origin.y - keyboardFrameInView.origin.y - tFrame.size.height;
        [scrollView setOrigin:CGPointMake(0, -keyboardFrameInView.size.height -(tmpY>0?-tmpY:tmpY))];
        if (closing) {
            [scrollView setOrigin:CGPointMake(0, 0)];
        }
    } constraintBasedActionHandler:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    needToLoad = NO;
    [super startRequest];
    client.tag = @"findBalance";
    [self setLoading:YES content:@"正在获取您的账户余额"];
    [client findBalance:_item.id];
}

- (IBAction)opNumber:(UIButton*)sender {
    numbers = number.text.intValue;
    if (sender.tag == 0) {
        if (numbers != 1) {
            numbers -= 1;
        }
    } else {
        numbers += 1;
    }
    number.text = [NSString stringWithFormat:@"%d", numbers];
    NSString *priceString = [price.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    totalprice.text = [NSString stringWithFormat:@"¥%.2f", numbers*priceString.doubleValue];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        password = tf.text;
        [super startRequest];
        [self setLoading:YES content:@"支付中"];
        [client buyWare:_item.id amount:number.text paymentOfCard:paymentOfCard.text paymentOfUnionCurrency:paymentOfUnionCurrency.text password:password];
    }
}

- (IBAction)buy:(id)sender {
    [self resignAllKeyboard:scrollView];
    [scrollView setOrigin:CGPointMake(0, 0)];
    
    double number1 = paymentOfCard.text.hasValue?paymentOfCard.text.doubleValue:0;
    double number2 = paymentOfUnionCurrency.text.hasValue?paymentOfUnionCurrency.text.doubleValue:0;
    
    if ((number1+number2) !=_item.price.doubleValue*number.text.intValue) {
        [self showText:@"支付金额不符"];
        return;
    }
    
    if (paymentOfUnionCurrency.text && paymentOfUnionCurrency.text.length > 0 && [paymentOfUnionCurrency.text integerValue]>0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"消费确认"
                                                        message:@"请输入您的云浩币密码"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"完成", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else {
        [super startRequest];
        [self setLoading:YES content:@"支付中"];
        [client buyWare:_item.id amount:number.text paymentOfCard:paymentOfCard.text paymentOfUnionCurrency:paymentOfUnionCurrency.text password:password];
    }

}

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        if ([sender.tag isEqualToString:@"findBalance"]) {
            balanceOfCash = [obj getStringValueForKey:@"balanceOfCash" defaultValue:@"0"];
            balanceOfUnionCurrency = [obj getStringValueForKey:@"balanceOfUnionCurrency" defaultValue:@"0"];
            
            paymentOfCard.placeholder = [NSString stringWithFormat:@"现有卡金余额%@", balanceOfCash];
            paymentOfUnionCurrency.placeholder = [NSString stringWithFormat:@"现有云浩币余额%@", balanceOfUnionCurrency];
//            if ([@"0" isEqualToString:balanceOfCash]) {
//                paymentOfCard.userInteractionEnabled = NO;
//            }
//            if ([@"0" isEqualToString:balanceOfUnionCurrency]) {
//                paymentOfUnionCurrency.userInteractionEnabled = NO;
//            }
        } else if ([sender.tag isEqualToString:@"MyInfo"]) {
            NSDictionary * dic = [obj getArrayForKey:@"list"][0];
            User * it = [User objWithJsonDic:dic];
            [[BSEngine currentEngine] setCurrentUser:it password:[BSEngine currentEngine].passWord tok:nil];
            [self popViewController];
        } else {
            if (sender.customErrorCode == 1) {
                [self showText:@"交易成功!"];
                [super startRequest];
                [client MyInfo];
                client.tag = @"MyInfo";
            }
        }
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)sender {
    if (sender == number) {
        numbers = number.text.intValue;
        totalprice.text = [NSString stringWithFormat:@"%.2f", numbers*price.text.doubleValue];
    }
}

@end
