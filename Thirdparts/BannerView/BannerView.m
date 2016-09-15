//
//  BannerView.m
//  LfMall
//
//  Created by keen on 13-8-5.
//  Copyright (c) 2013年 XizueSoft. All rights reserved.
//

#import "BannerView.h"
#import "UIColor+FlatUI.h"
#import "UIImage+FlatUI.h"

@interface BannerView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@interface BannerCell ()

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation BannerView
@synthesize delegate;
@synthesize selectedPage;
@synthesize numberOfPages;
@synthesize scrollView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault {
    self.backgroundColor = [UIColor clearColor];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];

    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.width - 60, self.height - 30, 60, 30)];
    _pageControl.numberOfPages = 0;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];  //将UIPageControl添加到主界面上。
}

- (void)setSelectedPage:(NSInteger)page {
    if (selectedPage != page) {
        if (selectedPage >= 0 && selectedPage < numberOfPages) {
            selectedPage = page;
            _pageControl.currentPage = page;
        }
    }
}

- (void)setNumberOfPages:(NSInteger)number {
    if (numberOfPages != number) {
        numberOfPages = number;
    }
}

- (BannerCell*)cellForPage:(NSInteger)page {
    BannerCell * cell = nil;
    for (BannerCell * sub in scrollView.subviews) {
        if ([sub isKindOfClass:[BannerCell class]] && sub.pageIndex == page) {
            cell = sub;
            break;
        }
    }
    return cell;
}

- (void)setScrollViewHeight:(CGFloat)height
{
    self.height = 
    scrollView.height = height;
}

- (void)reloadData {
    for (BannerCell * sub in scrollView.subviews) {
        if ([sub isKindOfClass:[BannerCell class]]) {
            [sub removeFromSuperview];
            break;
        }
    }
    self.numberOfPages = [delegate numberOfPagesInBannerView:self];
    _pageControl.numberOfPages = numberOfPages;
    CGSize size = [_pageControl sizeForNumberOfPages:numberOfPages];
    _pageControl.left = self.width - size.width - 10;
    scrollView.contentSize = CGSizeMake(numberOfPages * scrollView.width, scrollView.height);
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.selectedPage = 0;
    CGFloat offX = scrollView.contentOffset.x;
    int idx0 = ((int)offX) / scrollView.width;
    int idx1 = -1;
    if (offX - (idx0 * scrollView.width)) {
        idx1 = idx0 + 1;
    }
    [self loadDataForPage:idx0];
    if (idx1 >= 0) {
        [self loadDataForPage:idx1];
    }
}

- (void)loadDataForPage:(NSInteger)page {
    if (page >= 0 && page < numberOfPages) {
        BannerCell * cell = [self cellForPage:page];
        if (cell == nil) {
            CGRect frame = CGRectMake(page * scrollView.width, 0, scrollView.width, scrollView.height);
            cell = [delegate bannerView:self cellForPage:page];
            cell.frame = frame;
            if ([delegate respondsToSelector:@selector(bannerView:willDisplayCell:forPage:)]) {
                [delegate bannerView:self willDisplayCell:cell forPage:page];
            }
            [scrollView addSubview:cell];
        }
    }
}

- (void)tapped:(UITapGestureRecognizer*)recognizer {
    if ([delegate respondsToSelector:@selector(bannerView:tappedOnPage:)]) {
        [delegate bannerView:self tappedOnPage:selectedPage];
    }
}

-(void)setPageControlHiden:(BOOL)isHiden{
    self.pageControl.hidden = isHiden;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat offX = sender.contentOffset.x;
    int idx0 = ((int)offX) / (int)sender.width;
    int idx1 = -1;
    int outterVal = offX - (idx0 * sender.width);
    if (outterVal > 0) {
        if (idx0 + 1 < [delegate numberOfPagesInBannerView:self]) {
            idx1 = idx0 + 1;
        }
    }
    [self loadDataForPage:idx0];
    if (idx1 >= 0) {
        [self loadDataForPage:idx1];
    }
    int manyIDX = offX + sender.width/2;
    self.selectedPage = manyIDX / (int)sender.width;
    
}
@end

@implementation BannerCell

- (id)initWithPage:(NSInteger)page {
    if (self = [super init]) {
        self.backgroundColor = [UIColor grayColor];
        self.pageIndex = page;
//        self.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
