//
//  ShopDetailViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14-7-21.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//
#import "WareDetailViewController.h"
#import "WareDetailWebViewController.h"
#import "Globals.h"
#import "BaseTableViewCell.h"
#import "UIImage+FlatUI.h"
#import "UIButton+Bootstrap.h"
#import "UIButton+NSIndexPath.h"
#import "BannerView.h"
#import "BuyWareViewController.h"
#import "CommentsViewController.h"

#import "KAlertView.h"

#import "CreateCommentViewController.h"
#import "TextInput.h"
#import "UIImageView+WebCache.h"
#import "Comment.h"
#import "ContactDetailViewController.h"
#import "WareSku.h"
#import "CartItemAndBillItem.h"


#import "CreateBillViewController.h"


@interface WareDetailViewController () <BannerViewDelegate,CreateCommentDeletage>{
    BannerView  * adView;
    
    UIView * tableHeaderView;
    
    KTextView *inputText;
    UIView *inputView;
    UITapGestureRecognizer *tap;
     UIButton *sendBtn;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *srcPriceLabel;
    
    UIView *wareSkuView;
    
    WareSku *checkedSku;
    
    UIButton * addButton;
    UIButton * buyButton;
}
@property (strong,nonatomic) Ware *ware;
@end

@implementation WareDetailViewController

- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 293)];
    view.userInteractionEnabled = YES;
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 293)];
    adView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 163)];
    [adView setPageControlHiden:NO];
    adView.delegate = self;
    [view addSubview:adView];
    [tableHeaderView addSubview:view];
    
    UIView *wareNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 164, tableView.width, 70)];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width-30, 50)];
    nameLabel.numberOfLines = 0;
    nameLabel.text = _ware.name;
    nameLabel.font = [UIFont systemFontOfSize:15];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(tableView.width - 16, 10, 6, 30);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"arrow_right" isCache:YES].CGImage;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    [[wareNameView layer] addSublayer:layer];
    [wareNameView addSubview:nameLabel];
    [wareNameView setBackgroundColor:[UIColor whiteColor]];
    UIButton * nameClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 164, tableView.width, 50)   ];
    [nameClickBtn addTarget:self action:@selector(clickNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 100, 20)];
    priceLabel.numberOfLines = 0;
    priceLabel.text = [NSString stringWithFormat:@"%@元",[_ware.price hasValue]?_ware.price:@""];
    priceLabel.textColor = MyPinkColor;
    priceLabel.font = [UIFont systemFontOfSize:18];
    [wareNameView addSubview:priceLabel];
    [tableHeaderView addSubview:wareNameView];
    [tableHeaderView addSubview:nameClickBtn];
    
    
    wareSkuView = [[UIView alloc]initWithFrame:CGRectMake(0, 235, tableView.width, 50)];
    [wareSkuView setBackgroundColor:[UIColor whiteColor]];
    [tableHeaderView addSubview:wareSkuView];
    
    UILabel * skuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 60, 20)];
    skuLabel.text = @"规格：";
    [wareSkuView addSubview:skuLabel];
    
    [self createWareSkuModel:_ware inView:wareSkuView];
    
    [tableHeaderView setBackgroundColor:RGBACOLOR(175, 175, 175,0.2)];
    tableView.tableHeaderView = tableHeaderView;
    
    [self setRightBarButtonImage:[UIImage imageNamed:@"comment_all_btn"] highlightedImage:nil selector:@selector(commentWareBtn)];
    
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
    
    tableView.height -=70;
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height -120, tableView.width, 60)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footerView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 0.5)];
    [line setBackgroundColor:MygrayColor];
    [footerView addSubview:line];
    
    addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, (tableView.width-30)*3/5, 40)];
    [addButton commonStyle];
    [addButton setTitleColor:MygrayColor forState:UIControlStateHighlighted];
    [addButton setTitle:@"添加到购物车" forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [addButton setImage:[UIImage imageNamed:@"add_shoppingCart"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addButton];
    
     buyButton = [[UIButton alloc]initWithFrame:CGRectMake((tableView.width-30)*3/5+20, 10, (tableView.width-30)*2/5, 40)];
    [buyButton pinkStyle];
    [buyButton setTitleColor:MygrayColor forState:UIControlStateHighlighted];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buyButton addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setImage:[UIImage imageNamed:@"buy_now"] forState:UIControlStateNormal];
    [footerView addSubview:buyButton];
    if (!_ware) {
        addButton.enabled =
        buyButton.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [adView reloadData];
    if (isFirstAppear && [super startRequest]) {
        if (_ware) {
            _ware.badge = @"0";
            [self prepareLoadMoreWithPage:currentPage maxID:0];
        }else if (_wareId.hasValue){
            client = [[BSClient alloc] initWithDelegate:self action:@selector(requestWareDetalDidFinish: obj:)];
            [client findWareWithId:_wareId];
        }
    }
}
- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    if (isloadByslime) {
        [self setLoading:YES content:@"正在重新获取评论列表"];
    } else {
        [self setLoading:YES content:@"正在加载评论"];
    }
    client = nil;
    if ([super startRequest]) {
        [client findCommentWithId:nil targetId:_ware.id targetType:WARE page:page];
    }
}

- (void)requestWareDetalDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        
        _ware = [Ware objWithJsonDic:obj];
        nameLabel.text = _ware.name;
        priceLabel.text =[NSString stringWithFormat:@"%@元",_ware.price];
        [adView reloadData];
        
        [self createWareSkuModel:_ware inView:wareSkuView];
        //原价还没有数据
        [self prepareLoadMoreWithPage:currentPage maxID:0];
        
        addButton.enabled =
        buyButton.enabled = YES;
    }
}

- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
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
    return YES;
}

- (void)addSubsConmentPart:(Comment *)comment intoArr:(NSMutableArray *)arry{
    NSArray *subComments = comment.subs;
    if (subComments.count!=0) {
        for (Comment *sub in subComments) {
            [arry addObject:sub];
            if (sub.subs && sub.subs.count!=0) {
                [self addSubsConmentPart:sub intoArr:arry];
            }
        }
    }
//    return arry;
}

- (void)requestCommentDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [inputText resignFirstResponder];
        
        Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
        [contentArr insertObject:comment atIndex:0];
        [tableView reloadData];
        [self showText:@"评论成功"];
    }
}

-(void)requestAddToShoppingCartDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [self showText:@"添加成功"];
    }
}

#pragma -mark delegate

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
        return contentArr.count+1;
}


- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row==0) {
            return 40;
        }
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        int numb = 60;
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

- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
    CGFloat height = 22;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    height += size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel * totalCommentCountLabel = VIEWWITHTAG(cell.contentView, 172);
    UILabel * commentContentLabel = VIEWWITHTAG(cell.contentView, 173);
    UILabel * createTimeLabel = VIEWWITHTAG(cell.contentView, 174);
    UIButton *commentBtn = VIEWWITHTAG(cell.contentView, 175);
    
    UIView * commentView = VIEWWITHTAG(cell.contentView, 176);
    [commentView removeFromSuperview];
    __block UIImageView *bcgImgView = VIEWWITHTAG(cell.contentView, 177);
    [bcgImgView removeFromSuperview];
    
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
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
    
    if (indexPath.row!=0) {
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell removeArrowRight];
    [cell update:^(NSString *name) {
            if (indexPath.row ==0) {
                cell.imageView.hidden = YES;
                cell.textLabel.text = @"评论";
                cell.textLabel.frame = CGRectMake(10, 10, 40, 20);
                totalCommentCountLabel.text = [NSString stringWithFormat:@"%lu人评论",(unsigned long)contentArr.count];
                commentBtn.hidden = YES;
            }else{
                Comment *currentComment = [contentArr objectAtIndex:indexPath.row-1];
                cell.imageView.frame = CGRectMake(10, 10, 34, 34);
                cell.textLabel.text =currentComment.creatorName;
                cell.textLabel.frame = CGRectMake(64, 10, cell.width-100,20);
                CGSize size = [self sizeTofText:currentComment.content fontSize:12];
                commentContentLabel.text = currentComment.content;
                commentContentLabel.frame = CGRectMake(64, 35, size.width, size.height);
                
                createTimeLabel.text = [Globals timeStringWith:currentComment.createTime.doubleValue/1000];
                commentBtn.frame = CGRectMake(cell.width-40, commentContentLabel.bottom-10, 40, 40);
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
                            [clickComment setBackgroundColor:[UIColor clearColor]];
                            clickComment.frame = commentContent.frame;
                            [commentView addSubview:clickComment];
                            clickComment.tag = i;
                            clickComment.indexPath = indexPath;
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
    }];
    cell.indexPath = indexPath;
    cell.superTableView = sender;
    return cell;
}

- (void)tableView:(id)sender didTapHeaderAtIndexPath:(NSIndexPath*)indexPath{
    Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
    ContactDetailViewController *con = [[ContactDetailViewController alloc] init];
    con.phone = comment.creatorId;
    [self pushViewController:con];
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
  
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        return comment.creatorAvatar;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row!=0) {
        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:comment.creatorAvatar]];
    }else{
        cell.imageView.hidden = YES;
    }
}


#pragma mark - BannerViewDelegate

- (NSInteger)numberOfPagesInBannerView:(BannerView*)sender {
    return 1;
}

- (BannerCell*)bannerView:(BannerView*)sender cellForPage:(NSInteger)page {
    BannerCell* cell = [sender cellForPage:page];
    if (cell == nil) {
        cell = [[BannerCell alloc] initWithPage:page];
    }
    return cell;
}

- (void)bannerView:(BannerView*)sender willDisplayCell:(BannerCell*)cell forPage:(NSInteger)page {
    
    NSString *urlStr = _ware.picture;
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
#pragma mark -Util
-(CGSize)sizeTofText:(NSString*)text fontSize:(int)fontSize{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
    return size;
}

- (void)createShopComment{
    CreateCommentViewController * con = [[CreateCommentViewController alloc]init];
    con.commentType = WARE;
    con.targetId = _ware.id;
    con.deletage = self;
    [self pushViewController:con];
}

-(void)createCommentSuccess:(NSDictionary *)obj{
    Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
    [contentArr insertObject:comment atIndex:0];
    [tableView reloadData];
}


- (void)lookMore:(UIButton*)sender {
    //    CommentsViewController * con = [[CommentsViewController alloc] init];
    //    con.shopId = _ware.orgId;
    //    [self pushViewController:con];
}

-(void)commentWareBtn{
    [self initInputTextWithSendBtnTag:-1];
    inputText.tag = -1;
    [inputText setPlaceholder:@"说点什么吧！"];
    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
    [inputText becomeFirstResponder];
    
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
    if(inputText.tag==-1){
        client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCommentDidFinish:obj:)];
        [client createComment:content score:nil referId:nil targetId:_ware.id targetType:WARE];
    }else{
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
        [self showText:@"回复成功"];
    }
}

-(void)clickWareSkuBtn:(UIButton *)button{
    NSInteger index = button.tag;
    if (checkedSku) {
        for (UIView *subView in [button superview].subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                ((UIButton *)subView).selected = NO;
            }
        }
    }
    
    button.selected = !button.selected;
    checkedSku = [_ware.skus objectAtIndex:index];
    priceLabel.text = [NSString stringWithFormat:@"%@元",checkedSku.price];
}

-(void)createWareSkuModel:(Ware *)ware inView:(UIView *)view{
    if (ware.skus.count==0) {
        return;
    }
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            [sub removeFromSuperview];
        }
    }
    
    float currentLeft = 60,currentTop = 0;
    
    for (int i=0; i<ware.skus.count; i++) {
        WareSku *sku  = [ware.skus objectAtIndex:i];
        UIButton * skuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        skuBtn.tag  = i;
        [skuBtn addTarget:self action:@selector(clickWareSkuBtn:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [sku.name sizeWithFont:[UIFont systemFontOfSize:14] maxWidth:100 maxNumberLines:1];
        size.width +=20;
        if (currentLeft>=(tableView.width-size.width-20)) {
            currentLeft =60;
            currentTop +=35;
            tableHeaderView.height +=35;
            wareSkuView.height+=35;
            [tableView beginUpdates];
            [tableView setTableHeaderView:tableHeaderView];
            [tableView endUpdates];
        }
        skuBtn.frame = CGRectMake(currentLeft+10, currentTop+10, size.width, 30);
        currentLeft +=(size.width+10);
        [skuBtn pinkBorderStyle];
        [skuBtn setTitle:sku.name forState:UIControlStateNormal];
        [skuBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:skuBtn];
        
        if (i==0) {
            [self clickWareSkuBtn:skuBtn];
        }
    }
}

-(void)addToShoppingCart:(UIButton *)sender{
    
    if (!checkedSku) {
        [self showText:@"请选择规格"];
    }
    [self setLoading:YES content:@"正在加入购物车"];
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestAddToShoppingCartDidFinish:obj:)];
    [client addToShoppingCartBySkuId:checkedSku.ID wareId:_ware.id num:@"1"];
}

-(void)buyNow:(UIButton *)sender{
    CreateBillViewController * con = [[CreateBillViewController alloc] init];
    
    con.ware = _ware;
    con.wareSku = checkedSku;
    [self pushViewController:con];
}


- (void)clickNameBtn:(UIButton *)btn{
    WareDetailWebViewController * con = [[WareDetailWebViewController alloc]init];
    con.ware = _ware;
    con.wareId = _ware.id;
    [self pushViewController:con];
}

@end