////
////  NewCommentViewController.m
////  CloudSalePlatform
////
////  Created by Kiwaro on 14-7-30.
////  Copyright (c) 2014年 Kiwaro. All rights reserved.
////
//
//#import "NewCommentViewController.h"
//#import "Consume.h"
//
//@interface NewCommentViewController () {
//    IBOutlet UIButton * button;
//    IBOutlet UITextView * textView;
//    IBOutlet UIButton * sbutton;
//    CommentShowType isAnonymous;
//    CommentShowType isAnonyGood;
//}
//
//@end
//
//@implementation NewCommentViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"我要评价";
//    [self setEdgesNone];
//    [button navBlackStyle];
//    textView.layer.masksToBounds = YES;
//    textView.layer.cornerRadius = 2;
//    textView.layer.borderWidth = 1;
//    textView.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
//    isAnonymous = forCommentNonAnonymous;
//    isAnonyGood = forCommentGood;
//    UIButton * btn = VIEWWITHTAG(self.view, 1);
//    btn.selected = YES;
//    __block NewCommentViewController * blockView = self;
//    [blockView.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
//        if (closing) {
//            self.view.top = Sys_Version>=7?64:0;
//        } else if (opening){
//            self.view.top = -30;
//        }
//    }];
//}
//
//- (IBAction)goodOrBad:(UIButton*)sender {
//    sender.selected = !sender.selected;
//    int tag = 0;
//    if (sender.tag == 1) {
//        tag = 2;
//        isAnonyGood = forCommentBad;
//    } else {
//        tag = 1;
//        isAnonyGood = forCommentGood;
//    }
//    UIButton * btn = VIEWWITHTAG(self.view, tag);
//    btn.selected = NO;
//}
//
//- (IBAction)Anonymous:(UIButton*)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        isAnonymous = forCommentNonAnonymous;
//    } else {
//        isAnonymous = forCommentAnonymous;
//    }
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [textView resignFirstResponder];
//}
//
//- (IBAction)sendRequest {
//    if (textView.text.length == 0) {
//        [self showText:@"说点什么吧！"];
//        return;
//    }
//    [super startRequest];
//    [client createComment:textView.text wareId:_item.wareId goodBad:isAnonyGood anonymous:isAnonymous];
//}
//
//- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary *)obj {
//    if ([super requestDidFinish:sender obj:obj]) {
//        [self showText:@"评论成功！"];
//        [self popViewController];
//    }
//    return YES;
//}
//
//@end
