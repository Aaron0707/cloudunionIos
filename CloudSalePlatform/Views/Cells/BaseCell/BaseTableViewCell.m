//
//  BaseTableViewCell.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIImage+FlatUI.h"
#import "ImageTouchView.h"

@interface BaseTableViewCell () <ImageTouchViewDelegate>{
    ImageTouchView *imageView;
}

@property (nonatomic, readonly, strong) ImageTouchView * imageView;
@property (nonatomic, assign) BOOL          hasUpdate;
@end

@implementation BaseTableViewCell
@synthesize className, superTableView, indexPath, cornerRadius ,arrowlayer, bottomLineView, layoutBlock, topLineView, hasUpdate, bottomLine, topLine, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initialiseCell];
    }
    return self;
}

- (void)dealloc {
    self.className = nil;
    self.superTableView = nil;
    self.indexPath = nil;
    self.layoutBlock = nil;
    self.topLineView = nil;
    self.bottomLineView = nil;
    self.arrowlayer = nil;
}

- (void)awakeFromNib {
    [self initialiseCell];
}

- (void)addArrowRight {
    if (!self.arrowlayer) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.width - 16, (self.height - 9)/2, 6, self.height);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"arrow_right" isCache:YES].CGImage;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
        [[self layer] addSublayer:layer];
        self.arrowlayer = layer;
    }
}

- (void)removeArrowRight{
    [self.arrowlayer removeFromSuperlayer];
    self.arrowlayer = nil;
}

- (ImageTouchView*)imageView {
    if (!imageView) {
        imageView = [[ImageTouchView alloc] init];
        [self.contentView addSubview:imageView];
    }
    return imageView;
}

- (void)setSuperTableView:(UITableView *)tableView {
    if (superTableView != tableView) {
        superTableView = tableView;
        self.imageView.delegate = self;
    }

}

- (void)initialiseCell {
    self.hasUpdate = NO;
//    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapped:)];
//    [self.imageView addGestureRecognizer:recognizer];
//    self.imageView.userInteractionEnabled = YES;
    self.backgroundView = [[UIImageView alloc] init];
    [self.contentView insertSubview:self.backgroundView atIndex:0];
    UIImageView* selectedView = [[UIImageView alloc] init];
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    topLineView.image =
    topLineView.highlightedImage = LOADIMAGECACHES(@"bkg_gray_line");
    [self.contentView addSubview:topLineView];
    
    [self.contentView bringSubviewToFront:topLineView];
    
    self.bottomLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
    self.bottomLineView.image = 
    self.bottomLineView.highlightedImage = LOADIMAGECACHES(@"bkg_gray_line");
    
    self.backgroundColor = [UIColor whiteColor];
    selectedView.frame = self.frame;
    selectedView.backgroundColor = RGBCOLOR(246, 246, 246);
    selectedView.highlightedImage = [UIImage imageWithColor:RGBCOLOR(236, 236, 236) cornerRadius:0];
    self.backgroundView.frame = self.frame;
    
    self.selectedBackgroundView = selectedView;
    
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.tag = 0;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    
    self.detailTextLabel.textColor = RGBCOLOR(111, 111, 111);
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.tag = 1;
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.highlightedTextColor = [UIColor grayColor];
}

- (void)setTopLine:(BOOL)bl {
    if (bl) {
        [self.contentView addSubview:self.topLineView];
        [self.contentView bringSubviewToFront:topLineView];
    } else {
        [self.topLineView removeFromSuperview];
    }
}

- (void)setBottomLine:(BOOL)bl {
    if (bl) {
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView bringSubviewToFront:bottomLineView];
    } else {
        [self.bottomLineView removeFromSuperview];
    }
}

- (void)layoutSubviews {
    self.arrowlayer.frame = CGRectMake(self.arrowlayer.frame.origin.x, 0, 6, self.height);
    topLineView.top = 0.5;
    if (hasUpdate && !layoutBlock) {
        return;
    }
    bottomLineView.top = self.height - bottomLineView.height;
    self.imageView.frame = CGRectMake(10, (self.height - 60)/2, 60, 60);
    CGFloat left = self.imageView.hidden?10:(20+self.imageView.width);
    self.textLabel.frame = CGRectMake(left, 0, self.width - left - 10, self.height);
    self.detailTextLabel.frame = CGRectMake(self.imageView.hidden?110:self.textLabel.left, self.imageView.hidden?0:29, self.textLabel.width, self.height);
    
    
    self.backgroundView.height = 
    self.selectedBackgroundView.height =
    self.contentView.height = self.height;
    if (layoutBlock) {
        self.layoutBlock(@"layoutSubviews");
        self.layoutBlock = nil;
    }
}

- (void)setCornerRadius:(NSInteger)value {
    cornerRadius = value;
    if (cornerRadius >= 0) {
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderWidth = 0;
        self.imageView.layer.cornerRadius = cornerRadius;
        self.imageView.clipsToBounds = YES;
    }
}

- (void)update:(layoutCellView)block {
    self.hasUpdate = YES;
    self.layoutBlock = block;
}

- (void)setHeadImage:(UIImage*)image {
    self.imageView.image = image;
}

- (void)imageTouchViewDidSelected:(id)sender {
//- (void)headTapped:(UITapGestureRecognizer*)recognizer {
//    [UIView beginAnimations:@"DOWN" context:NULL];
//    [UIView setAnimationDelegate:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
//    self.alpha = 0.5;
//    [UIView commitAnimations];
    NSLog(@"点击cell 图片");
    if ([superTableView.delegate respondsToSelector:@selector(tableView:didTapHeaderAtIndexPath:)]) {
        [superTableView.delegate performSelector:@selector(tableView:didTapHeaderAtIndexPath:) withObject:superTableView withObject:indexPath];
    } else {
        if ([superTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [superTableView.delegate performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:superTableView withObject:indexPath];
        }
    }
}

@end
