//
//  CreateCommentViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 11/14/14.
//  Copyright (c) 2014 YunHaoRuanJian. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "TextInput.h"
#import "ImageTouchView.h"

@interface CreateCommentViewController ()<ImageTouchViewDelegate>{
    KTextView * textView;
    int score;
    NSMutableArray * stars;
}

@end

@implementation CreateCommentViewController

- (id)init{
    if (self = [super init]) {
        stars = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"发表评论";
    [self.view addSubview: [self starOfSocore]];
    
    textView = [[KTextView alloc] initWithFrame:CGRectMake(10, 60, self.view.width-20, 100)];
    textView.placeholder = @"说点什么吧...";
    [textView setplaceholderTextAlignment:NSTextAlignmentLeft];
    [textView setplaceholderFram:CGRectMake(0, 10, textView.width-10, 20)];
    [self.view addSubview:textView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, textView.top, self.view.width, 1)];
    [line1 setBackgroundColor: RGBACOLOR(175, 175, 175, 0.2)];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, textView.bottom, self.view.width, 1)];
    [line2 setBackgroundColor: RGBACOLOR(175, 175, 175, 0.2)];
    [self.view addSubview:line2];
    
    [self setRightBarButtonImage:[UIImage imageNamed:@"btn_addBlog"] highlightedImage:nil selector:@selector(createComment)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIView *)starOfSocore{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    
    UILabel * starLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 40)];
    starLabel.text = @"评分: ";
    starLabel.textColor = MygrayColor;
    [view addSubview:starLabel];
    
    for (int i=0; i<5; i++) {
        ImageTouchView *imageView = [[ImageTouchView alloc]initWithFrame:CGRectMake(90+i*30, 20, 20, 20) delegate:self];
        score = 3;
        if (i<score) {
            [imageView setImage:[UIImage imageNamed:@"create_comment_star"]];
        }else{
            [imageView setImage:[UIImage imageNamed:@"create_comment_star2"]];
        }
        imageView.tag = [NSString stringWithFormat:@"%i",i+1];
        [view addSubview:imageView];
        
        [stars addObject:imageView];
    }
    return view;
}

-(void)imageTouchViewDidSelected:(ImageTouchView *)sender{
    int tag = sender.tag.intValue;
    if (score ==tag) {
        return;
    }
    score = tag;
    for (int i = 0; i<5; i++) {
        ImageTouchView * imageView = [stars objectAtIndex:i];
        if (i<score) {
            [imageView setImage:[UIImage imageNamed:@"create_comment_star"]];
        }else{
           [imageView setImage:[UIImage imageNamed:@"create_comment_star2"]];
        }
    }
}

-(void)createComment{
    if (textView.text.hasValue && [super startRequest]) {
        [textView resignFirstResponder];
        
        if ([CommentTypeString(_commentType) isEqualToString:@"WORKS"]) {
            
            [client addEmpWorkComment:textView.text score:[NSString stringWithFormat:@"%i",score]  referId:_referId targetId:_targetId];
        }else{
        
        [client createComment:textView.text score:[NSString stringWithFormat:@"%i",score] referId:_referId targetId:_targetId targetType:_commentType];
        }
        return;
    }
    if (!textView.isFirstResponder) {
        [textView becomeFirstResponder];
    }
    [self showAlert:@"说点什么吧！！！" isNeedCancel:NO];
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    
    if ([super requestDidFinish:sender obj:obj]) {
        if ([_deletage respondsToSelector:@selector(createCommentSuccess:)]) {
            [_deletage createCommentSuccess:obj];
        }
        [self popViewController];
    }
    return YES;
}

@end
