//
//  UploadPreViewController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "UploadPreViewController.h"
#import "NSDictionaryAdditions.h"
#import "Globals.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"

#define IMG_Width 273
#define IMG_Height 416

@interface UploadPreViewController ()<UIScrollViewDelegate> {
    UIButton *btnDel;
    CGFloat imageScale;
    CGFloat imageMinScale;
    CGFloat hw;
    CGFloat std_hw;
}

@end

@implementation UploadPreViewController
@synthesize imageView;
@synthesize scrollView;
@synthesize image,shotView;
@synthesize del;

- (id)init {
    if (self = [super initWithNibName:@"UploadPreViewController" bundle:nil]) {
        // Custom initialization

    }
    return self;
}

- (void)dealloc {
    self.shotView = nil;
    self.del = nil;
   
    self.scrollView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBCOLOR(221, 221, 221);
    [self setEdgesNone];
//    [self setRightBarButtonImage:[UIImage imageNamed:@"OK" isCache:YES] highlightedImage:nil selector:@selector(saveBtnPressed)];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:@"保存" forState:UIControlStateNormal];
    [sendButton setTitleColor:MygreenColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(saveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.scrollView.zoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.showsHorizontalScrollIndicator =
    self.scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    screenFrame = scrollView.frame;
    screenFrame.origin = CGPointZero;
    CGFloat kw = screenFrame.size.width;
    CGFloat kh = screenFrame.size.height;
    hw = self.image.size.height/self.image.size.width;
    CGFloat contentWidth = kw;
    CGFloat contentHeight = kh;
    
    std_hw = screenFrame.size.height/screenFrame.size.width;
    imageScale = self.image.size.width/kw;
    if (self.image.size.height/kh > imageScale) {
        imageScale = self.image.size.height/kh;
    }
    imageScale += 0.8;
    if (imageScale < 5.) {
        imageScale = 5.;
    }
    
    self.imageView.image = self.image;
    if (hw > std_hw) {
        contentWidth = contentHeight/hw;
        [imageView setFrame:CGRectMake((kw-contentWidth)/2, 0, contentWidth, contentHeight)];
        imageMinScale = kw / contentWidth;
    } else if (hw < std_hw) {
        contentHeight = contentWidth*hw;
        [imageView setFrame:CGRectMake(0, (kh-contentHeight)/2, contentWidth, contentHeight)];
        imageMinScale = kh / contentHeight;
    } else{
        [imageView setFrame:CGRectMake(0, 0, kw, kh)];
        imageMinScale = 1.0f;
    }
    if (imageScale < imageMinScale + 0.8) {
        imageScale = imageMinScale + 0.8;
    }
    self.scrollView.maximumZoomScale = imageScale;
    
    UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    self.navigationItem.title = @"裁剪头像";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.clipsToBounds = NO;
    [scrollView setZoomScale:imageMinScale animated:YES];
    scrollView.minimumZoomScale = imageMinScale;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.clipsToBounds = YES;
}

- (void)addUseBtn {
    imageView.contentMode = UIViewContentModeScaleToFill;
//    [self addBarButtonItem:nil img:[UIImage imageNamed:@"" isCache:YES] action:@selector(picOp:) isRight:YES];
}

- (UIImage*)image {
    return image;
}

- (void)setImage:(UIImage*)img {
    if (image) {
        image = nil;
    }
    image = img;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)sender {
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView*)sender {
    CGRect frame = imageView.frame;
    
    if (hw > std_hw) {
        frame.origin.x = (screenFrame.size.width-frame.size.width)/2;
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
    } else if (hw < std_hw) {
        frame.origin.y = (screenFrame.size.height-frame.size.height)/2;
        if (frame.origin.y < 0) {
            frame.origin.y = 0;
        }
    }
    
    [imageView setFrame:frame];
}

- (UIImage*)getShotImage {
    CGPoint point = scrollView.contentOffset;
    CGSize scrollSize = scrollView.frame.size;
    CGSize viewSize = imageView.frame.size;
    CGFloat perX = point.x / viewSize.width; // 起始x点比例
    CGFloat perY = point.y / viewSize.height; // 起始y点比例
    CGFloat perW = scrollSize.width / viewSize.width; // 长度比例
    CGFloat perH = scrollSize.height / viewSize.height; // 高度比例
    CGRect rect = CGRectMake(perX * image.size.width, perY * image.size.height, perW * image.size.width, perH * image.size.height);
    UIImage * croppedImage = [self.imageView.image croppedImage:rect];
//    CGSize newSize = CGSizeMake(self.imageView.frame.size.width*2, self.imageView.frame.size.height*2);

    croppedImage = [croppedImage resizeImageGreaterThan:300];
//    UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
    return croppedImage;
}

- (void)picOp:(UIButton*)sender {
    [super startRequest];
    if (sender.tag == 109) {
#ifdef DEBUG
        DLog(@"del Pic");
#endif
        self.image = nil;
        [self back];
    } else {
#ifdef DEBUG
        DLog(@"use Pic");
#endif
        // 上传之前需要压缩
        self.image = [self getShotImage];
    }
}

- (void)doubleTap {
    if (scrollView.zoomScale > imageMinScale) {
        [scrollView setZoomScale:imageMinScale animated:YES];
    } else {
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }
}

- (void)saveBtnPressed {
    self.image = [self getShotImage];
    if ([del respondsToSelector:@selector(saveBtnPressed:)]) {
        [del saveBtnPressed:self.image];
    }else{
        [self saveImage];
    }
}

-(void)saveImage{
    [super startRequest];
    [client editAvatar:self.image];
}

#pragma mark - Request

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary*)obj {
    if (![super requestDidFinish:sender obj:obj]) {
        return NO;
    }
    if ([del respondsToSelector:@selector(updateDid:path:)]) {
        [del updateDid:self.image path:[obj getStringValueForKey:@"msg" defaultValue:@""]];
    }
    [self popViewController];
    return YES;
}

@end
