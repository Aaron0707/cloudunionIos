//
//  AddBlogViewController.m
//  CloudSalePlatform
//
//  Created by yunhao on 14-9-29.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "AddBlogViewController.h"
#import "CameraActionSheet.h"
#import "TextInput.h"
#import "UIImage+Resize.h"

@interface AddBlogViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    KTextView *textView;
    
    UIButton * addImageBtn1;
    UIButton * addImageBtn2;
    
    NSMutableArray *images;
    UIView *backGroundView;
}

@end

@implementation AddBlogViewController

-(id)init{
    if (self = [super init]) {
        images = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加云联博";
    CGRect rect = [self.view bounds];
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 190)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    textView = [[KTextView alloc] initWithFrame:CGRectMake(10, 10, rect.size.width-20, 90)];
    textView.layer.borderWidth = 0.1;
    textView.layer.cornerRadius = 4;
    textView.delegate = self;
    textView.enablesReturnKeyAutomatically = YES;
    textView.returnKeyType = UIReturnKeyDone;
    [textView setPlaceholder:@"说点什么吧..."];
    [textView setplaceholderFram:CGRectMake(8, 5, 100, 20)];

    addImageBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, (rect.size.width-50)/4, (rect.size.width-50)/4)];
    addImageBtn2 = [[UIButton alloc] initWithFrame:CGRectMake((rect.size.width-50)/4+20, 110, (rect.size.width-50)/4, (rect.size.width-50)/4)];
    [addImageBtn1 setBackgroundImage:[UIImage imageNamed:@"smiley_add_btn_nor"] forState:UIControlStateNormal];
    [addImageBtn1 setBackgroundImage:[UIImage imageNamed:@"smiley_add_btn_pressed"] forState:UIControlStateHighlighted];
    [addImageBtn2 setBackgroundImage:[UIImage imageNamed:@"smiley_add_btn_nor"] forState:UIControlStateNormal];
    [addImageBtn2 setBackgroundImage:[UIImage imageNamed:@"smiley_add_btn_pressed"] forState:UIControlStateHighlighted];
    
    [backGroundView addSubview:addImageBtn1];
    [backGroundView addSubview:addImageBtn2];
    [backGroundView addSubview:textView];

    [addImageBtn1 addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn2 addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backGroundView];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [sendButton setTitleColor:RGBCOLOR(182, 206, 32) forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn_addBlog"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(addBlogAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

#pragma mark -Delegate
- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
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
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSUInteger count = images.count;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (count==0) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:addImageBtn1.frame];
            [imageView setImage:img];
            [self.view addSubview:imageView];
            [images addObject:imageView];
            addImageBtn1.hidden = YES;
        }else{
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:addImageBtn2.frame];
            [imageView setImage:img];
            [images addObject:imageView];
            [self.view addSubview:imageView];
            
            UIImageView *lastImageView = [images lastObject];
            if ((images.count)%4==0) {
                CGRect rect = lastImageView.frame;
                rect.origin.x =10;
                rect.origin.y +=lastImageView.frame.size.height+10;
                addImageBtn2.frame = rect;
            }else{
                CGRect rect = lastImageView.frame;
                rect.origin.x +=lastImageView.frame.size.width+10;
                addImageBtn2.frame = rect;
            }
            if (images.count==8) {
                addImageBtn2.hidden = YES;
            }
            if (images.count>=4) {
                backGroundView.height +=80;
            }
        }
    }];
}

#pragma mark -Util
-(void)addImage:(UIButton *)sender{
    [textView resignFirstResponder];
    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:nil TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:@[@"拍一张",@"从相册选择"]];
    [actionSheet show];
}

-(void)addBlogAction{
    if ([super startRequest]) {
        NSMutableDictionary *blog = [NSMutableDictionary dictionary];
        if (images.count!=0) {
            NSMutableArray *imgs = [NSMutableArray array];
            [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIImageView *view  = (UIImageView *)obj;
                [imgs addObject:[view.image resizeImageGreaterThan:300]];
            }];
            [blog setObject:imgs forKey:@"img"];
        }
        [blog setObject:textView.text forKey:@"content"];
        [client addBlog:blog];
    }
}
@end

