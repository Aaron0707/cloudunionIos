//
//  XHImageViewer.m
//  XHImageViewer
//
//

#import "XHImageViewer.h"
#import "XHViewState.h"
#import "XHZoomingImageView.h"

@interface XHImageViewer ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) NSArray *imgViews;
@property (nonatomic, strong) NSArray *imgTitles;
@end

@implementation XHImageViewer

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.backgroundScale = 0.95;
    
    _imgTitles = [NSMutableArray array];
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    //    pan.maximumNumberOfTouches = 1;
    //    [self addGestureRecognizer:pan];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)setImageViewsFromArray:(NSArray*)views {
    NSMutableArray *imgViews = [NSMutableArray array];
    for(id obj in views){
        if([obj isKindOfClass:[UIImageView class]]){
            [imgViews addObject:obj];
            UIImageView *view = obj;
            
            XHViewState *state = [XHViewState viewStateForView:view];
            [state setStateWithView:view];
            
            view.userInteractionEnabled = NO;
        }
    }
    _imgViews = [imgViews copy];
}

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView viewTitles:(NSArray *)titles {
    [self setImageViewsFromArray:views];
    if (titles) {
       _imgTitles = [titles copy]; 
    }
    if(_imgViews.count > 0){
        if(![selectedView isKindOfClass:[UIImageView class]] || ![_imgViews containsObject:selectedView]){
            selectedView = _imgViews[0];
        }
        [self showWithSelectedView:selectedView];
    }
}

#pragma mark- Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (_scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5);
}

#pragma mark- View management

- (UIImageView *)currentView {
    return [_imgViews objectAtIndex:self.pageIndex];
}

- (void)showWithSelectedView:(UIImageView*)selectedView {
    
    for(UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    const NSInteger currentPage = [_imgViews indexOfObject:selectedView];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if(_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
    }
    
    
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    [self addSubview:_scrollView];
    [window addSubview:self];
    
    
    selectedView.frame = [window convertRect:selectedView.frame fromView:selectedView.superview];
    [window addSubview:selectedView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 1;
                         window.rootViewController.view.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
                         
                         selectedView.transform = CGAffineTransformIdentity;
                         
                         CGSize size = (selectedView.image) ? selectedView.image.size : selectedView.frame.size;
                         CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                         CGFloat W = ratio * size.width;
                         CGFloat H = ratio * size.height;
                         selectedView.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                     }
                     completion:^(BOOL finished) {
                         _scrollView.contentSize = CGSizeMake(_imgViews.count * fullW, 0);
                         _scrollView.contentOffset = CGPointMake(currentPage * fullW, 0);
                         
                         UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)];
                         [_scrollView addGestureRecognizer:gesture];
                         
                         for(UIImageView *view in _imgViews){
                             view.transform = CGAffineTransformIdentity;
                             
                             CGSize size = (view.image) ? view.image.size : view.frame.size;
                             CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             view.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                             
                             NSUInteger index = [_imgViews indexOfObject:view];
                             
                             XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake(index * fullW, 0, fullW, fullH)];
                             if (_imageSize.width!=0 && _imageSize.height!=0) {
                                 tmp.size = _imageSize;
                                 tmp.top = (fullH-_imageSize.height)/2;
                             }
                             tmp.imageView = view;
                             tmp.tag = index;
                             
                             if (_imgTitles.count>0) {
                                 UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//                                 titleScrollView.height-=(fullH+_imageSize.height)/2+10;
                                 titleScrollView.width =220;
//                                 titleScrollView.top = (fullH+_imageSize.height)/2+10;
                                 titleScrollView.tag = index;
                                 titleScrollView.left = index * fullW;
                                 titleScrollView.backgroundColor = [UIColor clearColor];
                                 titleScrollView.contentSize = CGSizeMake(220, self.height+500);
                                 titleScrollView.delegate = self;
                                 titleScrollView.showsVerticalScrollIndicator = NO;
                                 
                                 NSString * titleText = [_imgTitles objectAtIndex:index] ;
                                 CGSize textSize = [titleText sizeWithFont:[UIFont systemFontOfSize:14] maxWidth:200 maxNumberLines:10];
                                 
                                 UILabel * title  = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, textSize.width, textSize.height)];
                                 if (_imageSize.height!=0) {
                                     title.top = (fullH+_imageSize.height)/2+10;
                                 }else {
                                     title.top = (fullH+163)/2+10;
                                 }
                                 [title setFont:[UIFont systemFontOfSize:14]];
                                 [title setText:titleText];
                                 [title setNumberOfLines:0];
                                 [title setTextColor:[UIColor whiteColor]];
                                 [titleScrollView addSubview:title];
                                 title.alpha = 1;
                                 [_scrollView addSubview:titleScrollView];
                                 
                                 UIView * line = [[UIView alloc]initWithFrame:CGRectMake(index * fullW+230, (fullH+(_imageSize.height!=0?_imageSize.height:163))/2+10, 1, (fullH-(_imageSize.height!=0?_imageSize.height:163))/2-60)];
                                 [line setBackgroundColor:[UIColor whiteColor]];
                                 [_scrollView addSubview:line];
                                 
                                 UILabel * pageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(index * fullW+250, (fullH+(_imageSize.height!=0?_imageSize.height:163))/2+40, 15, 20)];
                                 UILabel * pageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(index * fullW+265, (fullH+(_imageSize.height!=0?_imageSize.height:163))/2+40, 20, 20)];
                                 pageLabel1.text = [NSString stringWithFormat:@"%lu",index+1];
                                 pageLabel2.text = [NSString stringWithFormat:@"/%ld",(unsigned long)_imgViews.count];
                                 [pageLabel1 setFont:[UIFont systemFontOfSize:20]];
                                 [pageLabel2 setFont:[UIFont systemFontOfSize:14]];
                                 pageLabel1.textColor =
                                 pageLabel2.textColor = [UIColor whiteColor];
                                 [_scrollView addSubview:pageLabel1];
                                 [_scrollView addSubview:pageLabel2];
                             }
                             
                             [_scrollView addSubview:tmp];
                             [_scrollView sendSubviewToBack:tmp];
                         }
                     }
     ];
}

- (void)prepareToDismiss {
    UIImageView *currentView = [self currentView];
    
    if([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView];
    }
    
    for(UIImageView *view in _imgViews) {
        if(view != currentView) {
            XHViewState *state = [XHViewState viewStateForView:view];
            view.transform = CGAffineTransformIdentity;
            view.frame = state.frame;
            view.transform = state.transform;
            [state.superview addSubview:view];
        }
    }
}

- (void)dismissWithAnimate {
    UIView *currentView = [self currentView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 0;
                         window.rootViewController.view.transform =  CGAffineTransformIdentity;
                         
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.frame = [window convertRect:state.frame fromView:state.superview];
                         currentView.transform = state.transform;
                     }
                     completion:^(BOOL finished) {
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.transform = CGAffineTransformIdentity;
                         currentView.frame = state.frame;
                         currentView.transform = state.transform;
                         [state.superview addSubview:currentView];
                         
                         for(UIView *view in _imgViews){
                             XHViewState *_state = [XHViewState viewStateForView:view];
                             view.userInteractionEnabled = _state.userInteratctionEnabled;
                         }
                         
                         [self removeFromSuperview];
                     }
     ];
}

#pragma mark- Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer*)sender
{
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

- (void)didPan:(UIPanGestureRecognizer*)sender
{
    static UIImageView *currentView = nil;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        currentView = [self currentView];
        
        UIView *targetView = currentView.superview;
        while(![targetView isKindOfClass:[XHZoomingImageView class]]){
            targetView = targetView.superview;
        }
        
        if(((XHZoomingImageView *)targetView).isViewing){
            currentView = nil;
        }
        else{
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            currentView.frame = [window convertRect:currentView.frame fromView:currentView.superview];
            [window addSubview:currentView];
            
            [self prepareToDismiss];
        }
    }
    
    if(currentView){
        if(sender.state == UIGestureRecognizerStateEnded){
            if(_scrollView.alpha>0.5){
                [self showWithSelectedView:currentView];
            }
            else{
                [self dismissWithAnimate];
            }
            currentView = nil;
        }
        else{
            CGPoint p = [sender translationInView:self];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, p.y);
            transform = CGAffineTransformScale(transform, 1 - fabs(p.y)/1000, 1 - fabs(p.y)/1000);
            currentView.transform = transform;
            
            CGFloat r = 1-fabs(p.y)/200;
            _scrollView.alpha = MAX(0, MIN(1, r));
        }
    }
}


#pragma mark - scrollViewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (10<y && y<50) {
        for(UIView * view in scrollView.superview.subviews){
            if ([view isKindOfClass:[XHZoomingImageView class]]) {
                if (scrollView.tag == view.tag ) {
                    view.alpha = 10/y;
                }
            }
        }
    }else if(y<10){
        for(UIView * view in scrollView.superview.subviews){
            if ([view isKindOfClass:[XHZoomingImageView class]]) {
                if (view.alpha !=1 && scrollView.tag == view.tag) {
                    view.alpha = 1;
                }
            }
        }
    }
}

@end
