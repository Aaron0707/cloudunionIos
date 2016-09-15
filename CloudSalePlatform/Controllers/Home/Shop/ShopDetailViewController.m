//
//  ShopDetailViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetail.h"
#import "Globals.h"
#import "BaseTableViewCell.h"
#import "BusinessShop.h"
#import "BusinessShopViewCell.h"
#import "UIImage+FlatUI.h"
#import "UIButton+Bootstrap.h"
#import "UIButton+NSIndexPath.h"
#import "BannerView.h"
#import "BuyWareViewController.h"
#import "CommentsViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MapViewController.h"
#import "CameraActionSheet.h"
#import "KAlertView.h"

#import "ActivityListViewController.h"
#import "WareListViewController.h"
//#import "EmpListViewController.h"
#import "OnlineAppointmentViewController.h"
#import "AppointmentListViewController.h"
#import "BasicNavigationController.h"
#import "ApplyViewController.h"
#import "ChatListViewController.h"
#import "ContactListViewController.h"
#import "CricleListViewController.h"
#import "CreateCommentViewController.h"
#import "TextInput.h"
#import "UIImageView+WebCache.h"

#import "WareDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "EmployeeDetailViewController.h"
#import "ContactDetailViewController.h"



@interface ShopDetailViewController () <BannerViewDelegate, CameraActionSheetDelegate,UMSocialUIDelegate,CreateCommentDeletage>{
    BannerView  * adView;
    BSClient * favClient;
    UIButton * favButton;
    UIView * tableHeaderView;
    UIView *categoryView;
    
    KTextView *inputText;
    UIView *inputView;
    
    CGFloat btnCurrentTop;
    UILabel *signatureLabel;
    
    UIButton * sendBtn;
    
    UIButton * callBtn;
    UIButton * actBtn;
    UIButton * wareBtn;
    UIButton * empBtn;
    UIButton * ylBtn;
}
@property (nonatomic, strong) ShopDetail * shopDetail;
@end

@implementation ShopDetailViewController

- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"店铺详情";
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 163)];
    view.userInteractionEnabled = YES;
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 350)];
    [tableHeaderView setBackgroundColor:[UIColor whiteColor]];
    adView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 163)];
    [adView setPageControlHiden:NO];
    adView.delegate = self;
    [view addSubview:adView];
    [tableHeaderView addSubview:view];
    
    [tableHeaderView addSubview:self.commentOrCategory];
    
    
    callBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 180, 78, 58)];
    [callBtn setImage:[UIImage imageNamed:@"shop_detile_phone"] forState:UIControlStateNormal];
    [callBtn setTitle:@"电话预约" forState:UIControlStateNormal];
    [callBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [callBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 24, 0, 24)];
    [callBtn setTitleEdgeInsets:UIEdgeInsetsMake(90, -30, 70, 0)];
    [callBtn.titleLabel setContentMode:UIViewContentModeCenter];
    [callBtn addTarget:self action:@selector(locCall) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:callBtn];
    
    actBtn = [[UIButton alloc]initWithFrame:CGRectMake(121, 180, 78, 58)];
    [actBtn setImage:[UIImage imageNamed:@"shop_detile_act"] forState:UIControlStateNormal];
    [actBtn setTitle:@"超值呈现" forState:UIControlStateNormal];
    [actBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [actBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [actBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 24, 0, 24)];
    [actBtn setTitleEdgeInsets:UIEdgeInsetsMake(90, -30, 70, 0)];
    [actBtn.titleLabel setContentMode:UIViewContentModeCenter];
    [actBtn addTarget:self action:@selector(clickHomeActBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:actBtn];
    
    wareBtn = [[UIButton alloc]initWithFrame:CGRectMake(232, 180, 78, 58)];
    [wareBtn setImage:[UIImage imageNamed:@"shop_detile_ware"] forState:UIControlStateNormal];
    [wareBtn setTitle:@"商品选购" forState:UIControlStateNormal];
    [wareBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [wareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wareBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 24, 0, 24)];
    [wareBtn setTitleEdgeInsets:UIEdgeInsetsMake(90, -30, 70, 0)];
    [wareBtn.titleLabel setContentMode:UIViewContentModeCenter];
    [wareBtn addTarget:self action:@selector(clickHomeCargoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:wareBtn];
    
    empBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 248, 78, 58)];
    [empBtn setImage:[UIImage imageNamed:@"shop_detile_emp"] forState:UIControlStateNormal];
    [empBtn setTitle:@"服务员工" forState:UIControlStateNormal];
    [empBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [empBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [empBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 24, 0, 24)];
    [empBtn setTitleEdgeInsets:UIEdgeInsetsMake(90, -30, 70, 0)];
    [empBtn.titleLabel setContentMode:UIViewContentModeCenter];
    [empBtn addTarget:self action:@selector(clickHomeEmpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:empBtn];
    
    ylBtn = [[UIButton alloc]initWithFrame:CGRectMake(121, 248, 78, 58)];
    [ylBtn setImage:[UIImage imageNamed:@"shop_detile_yl"] forState:UIControlStateNormal];
    [ylBtn setTitle:@"云联畅想" forState:UIControlStateNormal];
    [ylBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [ylBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ylBtn setImageEdgeInsets:UIEdgeInsetsMake(-35, 24, 0, 24)];
    [ylBtn setTitleEdgeInsets:UIEdgeInsetsMake(90, -30, 70, 0)];
    [ylBtn.titleLabel setContentMode:UIViewContentModeCenter];
    [ylBtn addTarget:self action:@selector(clickYunlianBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:ylBtn];
    
    signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, tableHeaderView.width-20, 40)];
    signatureLabel.numberOfLines = 0;
    [signatureLabel setFont:[UIFont systemFontOfSize:14]];
    [signatureLabel setTextColor:MygrayColor];
    [tableHeaderView addSubview:signatureLabel];
    
    tableView.tableHeaderView = tableHeaderView;
    
    UIBarButtonItem * itemRight0 = nil;
    UIBarButtonItem * itemRight1 = nil;
    UIButton * btn0 = [self buttonWithTitle:nil image:LOADIMAGE(@"btn_share") selector:@selector(btnSharePressed)];
    btn0.frame=CGRectMake(0, 0, 50, 20);
    
    // 分享按钮
    itemRight0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
    
    favButton = [self buttonWithTitle:nil image:LOADIMAGECACHES(@"btn_fav_d") selector:@selector(btnFavPressed)];
    favButton.frame=CGRectMake(0, 0, 20, 20);
    [favButton setImage:LOADIMAGECACHES(@"btn_fav") forState:UIControlStateSelected];
    
    // 收藏按钮
    itemRight1 = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    itemRight1.width = 40;
    
    // 分享暂时没有完成，隐藏
    //    NSArray *buttonArray = [[NSArray alloc] initWithObjects:itemRight1,itemRight0, nil];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:itemRight1, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    favButton.selected = [_businessShop.isFavorited isEqualToString:@"1"];
    
    //增加监听，当键盘出现或改变时收出消息
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear) {
        if (!_shopDetail) {
            if ([super startRequest]) {
                [client findShopDetailWithID:_businessShop.id page:currentPage];
            }
        }else{
            signatureLabel.text = [self.shopDetail.summary getStringValueForKey:@"signature" defaultValue:@"欢迎您访问本店!"];
        }
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        self.shopDetail = [ShopDetail objWithJsonDic:obj];
        signatureLabel.text = [self.shopDetail.summary getStringValueForKey:@"signature" defaultValue:@"欢迎您访问本店!"];
        [adView reloadData];
        [self setStar:ceil([self.shopDetail.summary getStringValueForKey:@"score" defaultValue:@"0"].doubleValue)  numberShow:[self.shopDetail.summary getIntValueForKey:@"commentTimes" defaultValue:0] targetView:categoryView origin:CGPointMake(10, 29)];
        [self prepareLoadMoreWithPage:currentPage maxID:0];
        
        [self createMyBadge:empBtn Value:_shopDetail.employeeBadge Left:NO];
        [self createMyBadge:wareBtn Value:_shopDetail.wareBadge Left:NO];
        [self createMyBadge:actBtn Value:_shopDetail.promotionBadge Left:NO];
    }
    return YES;
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    if (isloadByslime) {
        [self setLoading:YES content:@"正在重新获取评论列表"];
    } else {
        [self setLoading:YES content:@"正在加载评论商家"];
    }
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestCommentDidFinish:obj:)];
    [client findCommentWithId:_businessShop.id targetId:nil targetType:NoneCommentType page:page];
}

- (void)requestCommentDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        if (list.count!=0) {
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Comment *comment = [Comment objWithJsonDic:obj];
                NSMutableArray * array = [NSMutableArray array];
                [self addSubsConmentPart:comment intoArr:array];
                comment.subs = array;
                [contentArr addObject:comment];
            }];
            [tableView reloadData];
        }
    }
}

-(void)addSubsConmentPart:(Comment *)comment intoArr:(NSMutableArray *)arry{
    NSArray *subComments = comment.subs;
    if (subComments.count!=0) {
        for (Comment *sub in subComments) {
            [arry addObject:sub];
            if (sub.subs && sub.subs.count!=0) {
                [self addSubsConmentPart:sub intoArr:arry];
            }
        }
    }
}

- (UIView *)commentOrCategory{
    categoryView  = [[UIView alloc]initWithFrame:CGRectMake(0, 118, tableView.width, 45)];
    [categoryView setBackgroundColor:[UIColor clearColor]];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor blackColor] cornerRadius:0]];
    backgroundImage.size = categoryView.size;
    [backgroundImage setAlpha:0.5];
    [categoryView addSubview:backgroundImage];
    
    UILabel * categoryDetailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 200, 20)];
    categoryDetailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    categoryDetailTextLabel.textColor = [UIColor whiteColor];
    categoryDetailTextLabel.backgroundColor = [UIColor clearColor];
    categoryDetailTextLabel.tag = 1;
    categoryDetailTextLabel.numberOfLines = 0;
    categoryDetailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _businessShop.districtName.hasValue?_businessShop.districtName:@"", _businessShop.categoryName];
    [categoryView addSubview:categoryDetailTextLabel];
   
    UIButton * commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(tableView.width-70, 10, 60, 25)];
    [commentBtn setBackgroundColor:[UIColor whiteColor]];
    [commentBtn setTitle:@"点评一下" forState:UIControlStateNormal];
    [commentBtn setTitleColor:MyPinkColor forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    commentBtn.alpha = 0.8;
    [commentBtn addTarget:self action:@selector(createShopComment) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:commentBtn];
    
    return categoryView;
}

-(void)setStar:(int)score numberShow:(int)numb targetView:(UIView *)targetView origin:(CGPoint)origin{
    int red = score;
    int gray = 5-red;
    for (int i=0; i<red; i++) {
        UIView *view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar"]]];
        view.top = origin.y;
        view.size = CGSizeMake(9, 9);
        view.left = origin.x + i*10;
        [targetView addSubview:view];
    }
    for (int i=0; i<gray; i++) {
        UIView *view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar2"]]];
        view.top = origin.y;
        view.size = CGSizeMake(9, 9);
        view.left = origin.x  + (i+red)*10;
        [targetView addSubview:view];
    }
    
    UILabel *totalLabel = [UILabel new];
    totalLabel.font = [UIFont systemFontOfSize:11];
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.backgroundColor = [UIColor clearColor];
    [targetView addSubview:totalLabel];
    totalLabel.clipsToBounds = NO;
    totalLabel.text = [NSString stringWithFormat:@"%i人评论",numb];
    totalLabel.size = CGSizeMake(100, 20);
    totalLabel.top = origin.y-6;
    totalLabel.left = origin.x + 6*10;
}

- (void)btnSharePressed {
    
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.cloudvast.com/m/m.jsp?phone=%@&type=IOS&deveiceId=%@",[[[BSEngine currentEngine] user] phone],[Globals getMyUUID]];
    //    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址，需要#import "UMSocialWechatHandler.h"
    [UMSocialWechatHandler setWXAppId:@"wx0d064c4cb90ecef8" appSecret:@"50bbaae1d49e923aec82c501804ed2e7"  url:shareUrl];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:shareUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMShareKey
                                      shareText:UMShareMessage
                                     shareImage:[UIImage imageNamed:@"about"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite]
                                       delegate:self];
}

- (void)btnFavPressed {
    if (favClient) {
        return;
    }
    [self setLoading:YES content:@"正在收藏商家"];
    favClient = [[BSClient alloc] initWithDelegate:self action:@selector(requestfavDidFinish:obj:)];
    [favClient favorite:_businessShop.orgId isFav:!_businessShop.isFavorited.boolValue];
    
}

- (BOOL)requestfavDidFinish:(BSClient*)sender obj:(NSDictionary *)obj {
    self.loading = NO;
    favClient = nil;
    if (sender.hasError) {
        [sender showAlert];
        return NO;
    }
    NSString * str = nil;
    
    _businessShop.isFavorited = [_businessShop.isFavorited isEqualToString:@"0"]?@"1":@"0";
    if ([_businessShop.isFavorited isEqualToString:@"0"]) {
        str = @"取消收藏成功";
    } else {
        str = @"收藏成功";
    }
    [KAlertView showType:KAlertTypeCheck text:str for:0.8 animated:YES];
    favButton.selected = [_businessShop.isFavorited isEqualToString:@"1"];
    return YES;
}

#pragma -mark delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return contentArr.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)sender heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    return 10;
}


- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else {
        if (indexPath.row==0) {
            return 40;
        }
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        int numb = 60;
        if (![comment.targetType isEqualToString:CommentTypeString(SHOP)]) {
            numb +=30;
        }
        if (comment.content.length>0) {
            CGSize size = [comment.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,200) lineBreakMode:NSLineBreakByWordWrapping];
            numb +=size.height;
        }
        if (comment.subs.count>0) {
            for (int i = 0; i<comment.subs.count; i++) {
                CGSize size =  [((Comment *)[comment.subs objectAtIndex:i]).content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,MAXFLOAT)];
                numb += size.height+10;
            }
            numb +=10;
        }
        return numb;
    }
}

- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
    CGFloat height = 22;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    height += size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIButton * locMap = VIEWWITHTAG(cell.contentView, 171);   // 位置
    UILabel * totalCommentCountLabel = VIEWWITHTAG(cell.contentView, 172);
    UILabel * commentContentLabel = VIEWWITHTAG(cell.contentView, 173);
    UILabel * createTimeLabel = VIEWWITHTAG(cell.contentView, 174);
    UIButton *commentBtn = VIEWWITHTAG(cell.contentView, 175);
    
    UIView * commentView = VIEWWITHTAG(cell.contentView, 176);
    [commentView removeFromSuperview];
    __block UIImageView *bcgImgView = VIEWWITHTAG(cell.contentView, 177);
    [bcgImgView removeFromSuperview];
    UILabel *commentTargetNameLabel = VIEWWITHTAG(cell.contentView, 178);
     UIButton *commentTargetNameBtn = VIEWWITHTAG(cell.contentView, 179);
    
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        locMap = [UIButton buttonWithType:UIButtonTypeCustom];
        locMap.titleLabel.font = [UIFont systemFontOfSize:14];
        locMap.titleLabel.textAlignment = NSTextAlignmentLeft;
        locMap.frame = CGRectMake(0, 0, tableView.width, 50);
        locMap.backgroundColor = [UIColor clearColor];
        locMap.tag = 0;
        [locMap setTitleColor:RGBCOLOR(79, 79, 79) forState:UIControlStateNormal];
        [locMap setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(248, 248, 248, 0.7) cornerRadius:0] forState:UIControlStateHighlighted];
        [locMap addTarget:self action:@selector(locShopAddress:) forControlEvents:UIControlEventTouchUpInside];
        locMap.tag = 171;
        [cell.contentView addSubview:locMap];
        
        locMap.hidden = YES;
        
        totalCommentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-110, -5, 90, 50)];
        totalCommentCountLabel.textAlignment = NSTextAlignmentRight;
        totalCommentCountLabel.textColor = MyPinkColor;
        totalCommentCountLabel.font = [UIFont systemFontOfSize:14];
        totalCommentCountLabel.tag = 172;
        [cell.contentView addSubview:totalCommentCountLabel];
        commentContentLabel = [[UILabel alloc] init];
        commentContentLabel.textColor = RGBCOLOR(79, 79, 79);
        commentContentLabel.font = [UIFont systemFontOfSize:12];
        commentContentLabel.tag = 173;
        commentContentLabel.numberOfLines = 0;
        [cell.contentView addSubview:commentContentLabel];
        
        commentTargetNameLabel =[[UILabel alloc] init];
        commentTargetNameLabel.size = CGSizeMake(cell.width-100, 20);
        commentTargetNameLabel.textColor = MygreenColor;
        commentTargetNameLabel.font = [UIFont systemFontOfSize:14];
        commentTargetNameLabel.tag = 178;
        commentTargetNameLabel.numberOfLines = 0;
        [cell.contentView addSubview:commentTargetNameLabel];
        commentTargetNameBtn = [[UIButton alloc] init];
        [commentTargetNameBtn addTarget:self action:@selector(commentTargetNameClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:commentTargetNameBtn];
        
        createTimeLabel = [[UILabel alloc] init];
        createTimeLabel.width = 70;
        createTimeLabel.height = 20;
        createTimeLabel.left = cell.width-80;
        createTimeLabel.top = 10;
        createTimeLabel.tag = 174;
        createTimeLabel.font = [UIFont systemFontOfSize:11];
        createTimeLabel.textColor = [UIColor grayColor];
        createTimeLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:createTimeLabel];
        
        commentBtn = [[UIButton alloc] init];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"evalue.png"] forState:UIControlStateNormal];
        [commentBtn addTarget:self action:@selector(presentMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        commentBtn.tag = 175;
        [cell.contentView addSubview:commentBtn];
        
    }
    commentBtn.indexPath = indexPath;
    if (indexPath.section==1 && indexPath.row!=0) {
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        if ([comment.subs isKindOfClass:[NSArray class]]&&comment.subs.count>0) {
            commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
            commentView.layer.masksToBounds = YES;
            commentView.layer.cornerRadius = 4.0;
            commentView.tag = 176;
            [cell.contentView addSubview:commentView];
            
            UIImage *bcgImg = [UIImage imageNamed:@"comment-bcg"];
            bcgImg = [bcgImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 5, 30) resizingMode:UIImageResizingModeTile];
            bcgImgView = [[UIImageView alloc]initWithImage:bcgImg];
        }
    }
    
    cell.textLabel.text         =
    totalCommentCountLabel.text =
    commentContentLabel.text =
    createTimeLabel.text =
    cell.detailTextLabel.text   = @"";
    cell.imageView.hidden = NO;
    [cell removeArrowRight];
    [cell update:^(NSString *name) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 ) {
                cell.imageView.image = LOADIMAGECACHES(@"address");
                cell.detailTextLabel.text = _businessShop.address;
                cell.detailTextLabel.left = 40;
                cell.detailTextLabel.top = -1;
                cell.detailTextLabel.width = cell.width - 50;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                locMap.hidden = NO;
            }
            cell.textLabel.left = 40;
            cell.imageView.frame = CGRectMake(15, (cell.height - 21)/2, 15, 21);
            [cell addArrowRight];
            
        } else if(indexPath.section ==1){
            if (indexPath.row ==0) {
                cell.imageView.hidden = YES;
                cell.textLabel.text = @"评论";
                cell.textLabel.frame = CGRectMake(10, 10, 40, 20);
                totalCommentCountLabel.text = [NSString stringWithFormat:@"%i人评论",[self.shopDetail.summary getIntValueForKey:@"commentTimes" defaultValue:0]];
            }else{
                Comment *currentComment = [contentArr objectAtIndex:indexPath.row-1];
                cell.imageView.frame = CGRectMake(10, 10, 34, 34);
                cell.textLabel.text =currentComment.creatorName;
                cell.textLabel.frame = CGRectMake(64, 10, cell.width-100,20);
                CGSize size = [self sizeTofText:currentComment.content fontSize:12];
                commentContentLabel.text = currentComment.content;
                commentContentLabel.frame = CGRectMake(64, 35, size.width, size.height);
                
                createTimeLabel.text = [Globals timeStringWith:currentComment.createTime.doubleValue/1000];
                
                if (![currentComment.targetType isEqualToString:CommentTypeString(SHOP)]) {
                    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:currentComment.targetName];
                    NSRange contentRange = {0,[content length]};
                    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                    commentTargetNameLabel.attributedText = content;
                    commentTargetNameLabel.left = commentContentLabel.left;
                    commentTargetNameLabel.top = commentContentLabel.bottom+5;
                    commentTargetNameLabel.hidden = NO;
                    commentTargetNameBtn.hidden = NO;
                    commentTargetNameBtn.frame = commentTargetNameLabel.frame;
                    commentTargetNameBtn.indexPath = indexPath;
                    commentBtn.frame = CGRectMake(cell.width-40, commentTargetNameLabel.bottom-15, 40, 40);
                }else{
                    commentTargetNameLabel.hidden = YES;
                    commentBtn.frame = CGRectMake(cell.width-40, commentContentLabel.bottom-15, 40, 40);
                    commentTargetNameBtn.hidden = YES;
                }
                
                if ([currentComment.subs isKindOfClass:[NSArray class]]&&currentComment.subs.count>0) {
                    NSArray * comments = [currentComment.subs copy];
                    BOOL hasContent = NO;
                    NSMutableArray *commentContentArr = [NSMutableArray array];
                    for (int i=0; i<comments.count; i++) {
                        Comment *comment = [comments objectAtIndex:i];
                        if (comment.content.length!=0) {
                            if (!hasContent) {
                                hasContent = YES;
                            }
                            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,20)];
                            name.font = [UIFont systemFontOfSize:13];
                            name.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
                            NSMutableString *myText = [comment.creatorName mutableCopy];
                            if ([comment isBossReply]) {
                                myText = [NSMutableString stringWithFormat:@"店长"];
                                name.textColor = MyPinkColor;
                            }
                            CGSize mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT,name.size.height)];
                            [name setFrame:CGRectMake(0, 0, mYsize.width, 20)];
                            name.text = myText;
                            
                            UILabel *spit=nil;UILabel *targetName = nil;
                            if (comment.referCreatorName.length>0 && ![currentComment.ID isEqualToString:comment.referId]) {
                                spit = [[UILabel alloc] initWithFrame:CGRectMake(name.right+1, 0, 25, 20)];
                                spit.font = [UIFont systemFontOfSize:12];
                                spit.text  = @"回复";
                                
                                targetName =[[UILabel alloc] initWithFrame:CGRectMake(spit.right+1, 0, 50, 20)];
                                targetName.font = [UIFont systemFontOfSize:13];
                                targetName.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
                                myText = [comment.referCreatorName mutableCopy];
                                mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT,targetName.size.height)];
                                [targetName setFrame:CGRectMake(spit.right+1, 0, mYsize.width, 20)];
                                targetName.text = myText;
                            }
                            UILabel *commentContent =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 0)];
                            commentContent.font = [UIFont systemFontOfSize:13];
                            commentContent.numberOfLines =0;
                            commentContent.lineBreakMode = NSLineBreakByWordWrapping;
                            NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                            style.firstLineHeadIndent = (name.width+(spit?spit.width:0)+(targetName?targetName.width:0)+6);//首行缩进
                            style.alignment = NSTextAlignmentLeft;
                            style.lineBreakMode =NSLineBreakByWordWrapping;
                            //            style.lineSpacing = 5;
                            
                            myText = [NSMutableString stringWithFormat:@"："];
                            [myText appendString:comment.content];
                            mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(commentContent.size.width,MAXFLOAT)];
                            
                            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:myText attributes:@{ NSParagraphStyleAttributeName : style}];
                            commentContent.attributedText = attrText;
                            //            if (i!=0) {
                            double totalHeight = 5.0f;
                            for (UILabel *temp in commentContentArr) {
                                totalHeight +=temp.frame.size.height;
                            }
                            [commentContent setFrame:CGRectMake(0, totalHeight, 200, mYsize.height+5)];
                            [commentContentArr addObject:commentContent];
                            UIView *nameDitel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 22)];
                            [nameDitel addSubview:name];
                            [nameDitel addSubview:spit];
                            [nameDitel addSubview:targetName];
                            [commentContent addSubview:nameDitel];
                            [commentView addSubview:commentContent];
                            commentView.size = CGSizeMake(220,commentContent.frame.size.height+commentView.frame.size.height+1);
                            UIButton *clickComment = [[UIButton alloc]init];
                            clickComment.indexPath = indexPath;
                            [clickComment setBackgroundColor:[UIColor clearColor]];
                            clickComment.frame = commentContent.frame;
                            [commentView addSubview:clickComment];
                            clickComment.tag = i;
                            [clickComment addTarget:self action:@selector(clickLabelComment:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            hasContent = NO;
                        }
                        
                    }
                    
                    commentView.left = 74;
                    commentView.top = commentBtn.bottom-10;
                    
                    CGRect rc = commentView.frame;
                    bcgImgView.tag = 177;
                    [bcgImgView setFrame:CGRectMake(rc.origin.x-10, rc.origin.y-5, rc.size.width+10, rc.size.height+15)];
                    [cell.contentView addSubview:bcgImgView];
                    [cell.contentView sendSubviewToBack:bcgImgView];
                    if (!hasContent) {
                        [commentView removeFromSuperview];
                        [bcgImgView removeFromSuperview];
                    }
                }
            }
        }
    }];
    cell.selected = NO;
    cell.superTableView = sender;
    cell.indexPath = indexPath;
    return cell;
}


-(void)tableView:(UITableView *)sender willDisplayCell:(BaseTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section!=0 && indexPath.row!=0) {
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:comment.creatorAvatar]];
    }else if(indexPath.section==0){
        cell.imageView.image = [UIImage imageNamed:@"address"];
        cell.imageView.hidden = NO;
    }else{
        cell.imageView.hidden = YES;
    }
}

- (void)tableView:(id)sender didTapHeaderAtIndexPath:(NSIndexPath*)indexPath{
     Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
    ContactDetailViewController *con = [[ContactDetailViewController alloc] init];
    con.phone = comment.creatorId;
    [self pushViewController:con];
}

#pragma mark - BannerViewDelegate

- (NSInteger)numberOfPagesInBannerView:(BannerView*)sender {
    return _shopDetail.galleries.count;
}

- (BannerCell*)bannerView:(BannerView*)sender cellForPage:(NSInteger)page {
    BannerCell* cell = [sender cellForPage:page];
    if (cell == nil) {
        cell = [[BannerCell alloc] initWithPage:page];
    }
    return cell;
}

- (void)bannerView:(BannerView*)sender willDisplayCell:(BannerCell*)cell forPage:(NSInteger)page {
    id url = [_shopDetail.galleries objectAtIndex:page];
    NSString *urlStr = url;
    if ([url isKindOfClass:[NSDictionary class]]) {
        NSDictionary * urld =url;
        urlStr = [urld objectForKey:@"imgPath"];
    }
    cell.image = [Globals getImageGray];
    [Globals imageDownload:^(UIImage *img) {
        cell.image = img;
    } url:urlStr];
}

- (void)imageProgressCompleted:(UIImage*)img indexPath:(NSIndexPath*)indexPath tag:(int)tag url:(NSString *)url {
    BannerCell *cell = [adView cellForPage:tag];
    cell.image = img;
}

- (void)bannerView:(BannerView*)sender tappedOnPage:(NSInteger)page {
    
}
#pragma mark - buy button
-(CGSize)sizeTofText:(NSString*)text fontSize:(int)fontSize{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    return size;
}

- (void)createShopComment{
    CreateCommentViewController * con = [[CreateCommentViewController alloc]init];
    con.commentType = SHOP;
    con.targetId = _businessShop.id;
    con.deletage = self;
    [self pushViewController:con];
}

-(void)createCommentSuccess:(NSDictionary *)obj{
    
    Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
    [contentArr insertObject:comment atIndex:0];
    [tableView reloadData];
}

- (void)locCall{
    NSArray * arr = [_shopDetail.phone componentsSeparatedByString:@" "];
    CameraActionSheet *actionSheet = [[CameraActionSheet alloc] initWithActionTitle:[NSString stringWithFormat:@"联系商家"] TextViews:nil CancelTitle:@"取消" withDelegate:self otherButtonTitles:arr];
    [actionSheet show];
}
-(void)clickHomeActBtn:(id)sender{
    _shopDetail.promotionBadge = @"0";
    [self createMyBadge:actBtn Value:_shopDetail.promotionBadge Left:NO];
    ActivityListViewController *con = [[ActivityListViewController alloc]init];
    con.shopId = _businessShop.id;
    [self.navigationController pushViewController:con animated:YES];
}
-(void)clickHomeCargoBtn:(id)sender{
    _shopDetail.wareBadge = @"0";
    [self createMyBadge:wareBtn Value:_shopDetail.wareBadge Left:NO];
    WareListViewController *con = [[WareListViewController alloc] init];
    con.shopId =_businessShop.id;
    [self.navigationController pushViewController:con animated:YES];
}
-(void)clickHomeEmpBtn:(id)sender{
    _shopDetail.employeeBadge = @"0";
    [self createMyBadge:empBtn Value:_shopDetail.employeeBadge Left:NO];
//    NSMutableArray *rootControllers = [[self.tabBarController viewControllers] mutableCopy];
//    EmpListViewController *con = [[EmpListViewController alloc] init];
//    AppointmentListViewController *con1 = [[AppointmentListViewController alloc] init];
//    con1.sourceRootControllers =
//    con.sourceRootControllers = rootControllers;
//    con.shopId =_businessShop.id;
//    
//    con1.sourceSelectIndex =
//    con.sourceSelectIndex = self.tabBarController.selectedIndex;
//    
//    BasicNavigationController *nav1 =[self CreateBaseNav:con barItemSelectedImage:LOADIMAGE(@"tabbar_icon0_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon0") TextColorForSelected:MyPinkColor barTitle:@"预约"];
//    BasicNavigationController *nav2 =[self CreateBaseNav:con1 barItemSelectedImage:LOADIMAGE(@"tabbar_icon3_d") withFinishedUnselectedImage:LOADIMAGE(@"tabbar_icon3") TextColorForSelected:kBlueColor barTitle:@"我的"];
//    [self.tabBarController setSelectedIndex:0];
//    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:nav1,nav2, nil] animated:YES];
    OnlineAppointmentViewController *con = [[OnlineAppointmentViewController alloc] init];
    con.shopId =_businessShop.id;
    [self pushViewController:con];
}
-(void)clickYunlianBtn:(id)sender{
    NSInteger numb = [[[ApplyViewController shareController] dataSource] count];
    NSMutableArray *rootControllers = [[self.tabBarController viewControllers] mutableCopy];
    ChatListViewController *con = [[ChatListViewController alloc] init];
    ContactListViewController *con1 = [[ContactListViewController alloc] init];
    CricleListViewController *con2 = [[CricleListViewController alloc] init];
    con1.sourceRootControllers =
    con2.sourceRootControllers =
    con.sourceRootControllers = rootControllers;
    
    con2.sourceSelectIndex =
    con1.sourceSelectIndex =
    con.sourceSelectIndex = self.tabBarController.selectedIndex;
    
    BasicNavigationController *nav1 =[self CreateBaseNav:con barItemSelectedImage:LOADIMAGE(@"huihua") withFinishedUnselectedImage:LOADIMAGE(@"huihua") TextColorForSelected:MyPinkColor barTitle:@"会话"];
    BasicNavigationController *nav2 =[self CreateBaseNav:con1 barItemSelectedImage:LOADIMAGE(@"user") withFinishedUnselectedImage:LOADIMAGE(@"user") TextColorForSelected:RGBCOLOR(127, 49, 151) barTitle:@"联系人"];
    if (numb!=0) {
        [nav2.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%li",(long)numb]];
    }
    BasicNavigationController *nav3 =[self CreateBaseNav:con2 barItemSelectedImage:LOADIMAGE(@"yunlianquan") withFinishedUnselectedImage:LOADIMAGE(@"yunlianquan") TextColorForSelected:MygreenColor barTitle:@"云联圈"];
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3, nil] animated:YES];
}

- (void)locShopAddress:(UIButton*)sender {
    MapViewController * con = [[MapViewController alloc] init];
    CLLocationCoordinate2D loc;
    loc.latitude = _businessShop.latitude.doubleValue;
    loc.longitude = _businessShop.longitude.doubleValue;
    con.location = loc;
    con.shopName = _businessShop.orgName;
    con.locString = _businessShop.address;
    [self pushViewController:con];
}

#pragma mark -Create BaseNav

-(BasicNavigationController *)CreateBaseNav:(BaseViewController *)con barItemSelectedImage:(UIImage *)image1 withFinishedUnselectedImage:(UIImage *)image2 TextColorForSelected:(UIColor *)color barTitle:(NSString *)name{
    BasicNavigationController* navCon = [[BasicNavigationController alloc] initWithRootViewController:con];
    UITabBarItem * barItem = nil;
    UIFont* font = [UIFont systemFontOfSize:12];
    if (Sys_Version < 7) {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:image2 tag:0];
        [barItem setFinishedSelectedImage:image1 withFinishedUnselectedImage:image2];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:BkgFontColor, UITextAttributeTextColor,
                                         font,UITextAttributeFont,
                                         nil] forState:UIControlStateNormal];
    } else {
        barItem = [[UITabBarItem alloc] initWithTitle:name image:image2 selectedImage:image1];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         color, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateSelected];
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         BkgFontColor, NSForegroundColorAttributeName,
                                         font,NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
        
    }
    navCon.tabBarItem = barItem;
    
    return navCon;
}


- (void)lookMore:(UIButton*)sender {
    CommentsViewController * con = [[CommentsViewController alloc] init];
    con.shopId = _businessShop.orgId;
    [self pushViewController:con];
}

- (void)cameraActionSheet:(CameraActionSheet *)sender didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSArray * arr = [_shopDetail.phone componentsSeparatedByString:@" "];
    if (buttonIndex == arr.count) {
        return;
    } else {
        [Globals callAction:arr[buttonIndex] parentView:self.view];
    }
}


-(void)presentMoreBtn:(UIButton *) btn{
    [self initInputTextWithSendBtnTag:-1];
    inputText.tag = btn.indexPath.row;
    Comment *comment = [contentArr objectAtIndex:btn.indexPath.row-1];
    [inputText setPlaceholder:[NSString stringWithFormat:@"回复%@",comment.creatorName]];
    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
    [inputText becomeFirstResponder];
    
}
- (void)clickLabelComment:(UIButton *)btn{
    Comment *comment = [contentArr objectAtIndex:btn.indexPath.row-1];
    Comment *sub = [comment.subs objectAtIndex:btn.tag];
    [self initInputTextWithSendBtnTag:btn.tag];
    inputText.tag = btn.indexPath.row;
    [inputText setPlaceholder:[NSString stringWithFormat:@"回复%@",sub.creatorName]];
    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
    [inputText becomeFirstResponder];
    
}

- (void)initInputTextWithSendBtnTag:(NSInteger)tag{
    if(!inputText){
        inputText = [[KTextView alloc] init];
        inputText.layer.masksToBounds = YES;
        inputText.layer.cornerRadius = 3.0;
        inputText.returnKeyType = UIReturnKeyDefault;//键盘按钮名称
        inputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        [inputText setFrame:CGRectMake(20,10, rect.size.width-150, 30)];
        inputText.layer.borderColor = RGBACOLOR(210, 213, 218,1).CGColor;
        inputText.layer.borderWidth = 1;
        inputText.layer.cornerRadius = 4;
        inputView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 50)];
        //        inputView.backgroundColor = RGBACOLOR(210, 213, 218,1);
        inputView.layer.borderWidth =1;
        inputView.layer.borderColor =RGBACOLOR(210, 213, 218,1).CGColor;
        inputView.backgroundColor = [UIColor whiteColor];
        [inputView addSubview:inputText];
        
        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-60, 10, 50, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn pinkStyle];
        [inputView addSubview:cancelBtn];
        
        sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-120, 10, 50, 30)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn commonStyle];
        [inputView addSubview:sendBtn];
        
        [self.view addSubview:inputView];
    }
    sendBtn.tag = tag;
    inputText.text = @"";
}

- (void)tapped:(UITapGestureRecognizer *)tap{
    [inputText resignFirstResponder];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    //    CGPoint point =tableView.contentOffset;
    //    CGFloat myY = btnCurrentTop-keyboardRect.origin.y-150;
    //    if (myY >0) {
    //        point.y = myY;
    //        [tableView setContentOffset:point animated:YES];
    //    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = inputView.frame;
        rect.origin.y = keyboardRect.origin.y-110;
        inputView.frame = rect;
    }];
    [self.view bringSubviewToFront:inputView];
    
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = inputView.frame;
        rect.origin.y = keyboardRect.origin.y;
        inputView.frame = rect;
    }];
}

-(void)addComment:(UIButton *)btn{
    NSString *content = inputText.text;
    if (!content.hasValue) {
        return;
    }
    if (btn.tag>-1) {
        Comment *comment = [contentArr objectAtIndex:inputText.tag-1];
        Comment *sub = [comment.subs objectAtIndex:btn.tag];
        client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCreateSubCommentDidFinish:obj:)];
        [client createComment:content score:nil referId:sub.ID targetId:nil targetType:NoneCommentType];
    }else{
        Comment *targetComment = [contentArr objectAtIndex:inputText.tag-1];
        client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCreateSubCommentDidFinish:obj:)];
        [client createComment:content score:nil referId:targetComment.ID targetId:nil targetType:NoneCommentType];
    }
}

- (void)requestCreateSubCommentDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [inputText resignFirstResponder];
        Comment *targetComment = [contentArr objectAtIndex:inputText.tag-1];
        NSMutableArray *subComments = [targetComment.subs mutableCopy];
        Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
        [subComments addObject:comment];
        
        targetComment.subs = subComments;
        [tableView reloadData];
    }
}


- (void)commentTargetNameClick:(UIButton *)sender{
    Comment *comment  = [contentArr objectAtIndex:sender.indexPath.row-1];
    if ([comment.targetType isEqualToString:CommentTypeString(WARE)]) {
        WareDetailViewController *con = [[WareDetailViewController alloc] init];
        con.wareId = comment.targetId;
        [self pushViewController:con];
    }else if([comment.targetType isEqualToString:CommentTypeString(ACTIVITY)]){
        ActivityDetailViewController *con = [[ActivityDetailViewController alloc] init];
        con.activityId = comment.targetId;
         [self pushViewController:con];
    }else if([comment.targetType isEqualToString:CommentTypeString(EMPLOYEE)]){
        EmployeeDetailViewController *con = [[EmployeeDetailViewController alloc]init];
        con.employeeId = comment.targetId;
        [self pushViewController:con];
    }
}
@end