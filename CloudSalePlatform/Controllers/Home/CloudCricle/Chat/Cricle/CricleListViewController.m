//
//  CricleListViewController.m
//  CloudSalePlatform
//
//  Created by cloud on 14/10/28.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CricleListViewController.h"
#import "EaseMobBaseTableViewCell.h"
#import "NSDate+Category.h"
#import "SRRefreshView.h"
#import "Globals.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "CricleComment.h"
#import "KWPopoverView.h"
#import "XHImageViewer.h"
#import "FriendBlog.h"
#import "CricleTableViewCell.h"
#import "AddBlogViewController.h"
#import "TextInput.h"
#import <CommonCrypto/CommonDigest.h>
@interface CricleListViewController ()<XHImageViewerDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate,  SRRefreshDelegate,UITextViewDelegate>{
    
    UIView *inputView;//预约输入
    KTextView *inputText;
    
    UIButton *addButton;
    
    
    //云联圈
    UIView * commentBtns;
    
    NSInteger selectBtnIndex;
    
    UITapGestureRecognizer *imageDoubleClick;
    
    NSMutableArray *imageViews;
    
    KWPopoverView *kwpop;
    
    BOOL isCommentToComment;
    
    UITapGestureRecognizer *tap;
}

@property (strong, nonatomic) SRRefreshView *slimeView;

@end

@implementation CricleListViewController


-(id)init{
    self = [super init];
    if (self) {
        imageViews = [NSMutableArray array];
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad {
    super.willShowBackButton =YES;
    [super viewDidLoad];
    //绘制界面
    self.navigationItem.title = @"云联圈";
    
    [tableView addSubview:self.slimeView];
    
    [self.slimeView setLoadingWithExpansion];
    [addButton addTarget:self action:@selector(addBlogAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    //===========================================云联圈
    
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
    

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.tintColor =MygreenColor;
    if(contentArr.count==0){
    [self reloadBlogDataSource];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBuddyRequest:) name:@"ReceiveBuddyRequest" object:nil];
}

- (void)didReceiveBuddyRequest:(NSNotification *)notification{
    [[[self.tabBarController.tabBar items] objectAtIndex:2] setBadgeValue:@"2"];
}

#pragma mark -requestFinish
-(BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray *list = [obj getArrayForKey:@"list"];
        
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop){
            FriendBlog * fb = [FriendBlog objWithJsonDic:obj];
            fb.comments = [self addSubsConment:fb.comments];
            [contentArr addObject:fb];
        }];
        [tableView reloadData];
    }
    return YES;
}


-(void)requestAddBlocCommentFinish:(id)sender obj:(NSDictionary*)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        [tableView reloadData];
    }
}


#pragma mark -tableView DataSource and delegate
-(NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSInteger numb = 0;
        FriendBlog * fb = [contentArr objectAtIndex:indexPath.row];
        if (fb.content.length>0) {
            CGSize size = [fb.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,200) lineBreakMode:NSLineBreakByWordWrapping];
            numb +=size.height;
        }
        
        if (fb.imgs.count==1) {
            numb +=95;
        }else if(fb.imgs.count>1){
            numb += (fb.imgs.count%3==0?(fb.imgs.count/3)*70:((fb.imgs.count)/3 +1)*70)-5;
        }
        
        if (fb.comments.count>0) {
            for (int i = 0; i<fb.comments.count; i++) {
                CGSize size =  [((CricleComment *)[fb.comments objectAtIndex:i]).content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,MAXFLOAT)];
                numb += size.height+5;
            }
        }
        
        numb +=115;
        return numb;
}

-(UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cloudCricleListCell:sender cellForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)sender heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)sender editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}


#pragma mark 创建云联圈列表的cell
-(UITableViewCell *)cloudCricleListCell:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"CricleTableViewCell";
    CricleTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CricleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }else{
        for (UIView *subView in cell.contentView.subviews)
        {
            if ([subView isMemberOfClass:[UILabel class]]) {
                [(UILabel *)subView setText:@""];
            }else if([subView isMemberOfClass:[UIView class]]){
                [subView removeFromSuperview];
            }else if([subView isMemberOfClass:[UIButton class]]){
                [subView removeFromSuperview] ;
            }else if([subView isMemberOfClass:[UIImageView class]]){
                [subView removeFromSuperview];
            }
            
        }
    }
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 3.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.tag = indexPath.row;
    
    FriendBlog * fb = [contentArr objectAtIndex:indexPath.row];
    cell.textLabel.text = fb.creatorName;
    cell.textLabel.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:16];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fb.avatar] placeholderImage:[Globals getImageUserHeadDefault]];
    
    
    //内容处理
    UILabel *content = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 0,0)];
    CGSize size = [fb.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,200) lineBreakMode:NSLineBreakByWordWrapping];
    [content setFrame:CGRectMake(54, cell.imageView.frame.origin.y+35, size.width, size.height)];
    content.text = fb.content;
    [content setNumberOfLines:0];
    [content setFont:[UIFont systemFontOfSize:12]];
    [content setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.contentView addSubview:content];
    
    //图片处理
    NSArray *imageUrls = fb.imgs;
    UIView *allImage = nil;
    if (imageUrls.count>0) {
        if (imageUrls.count==1) {
            allImage = [[UIView alloc] initWithFrame:CGRectMake(content.left, content.bottom+10, 100,100)];
        }else{
            allImage = [[UIView alloc] initWithFrame:CGRectMake(content.left, content.bottom+10, 210,imageUrls.count%3==0?(imageUrls.count/3)*70:((imageUrls.count)/3 +1)*70)];
        }
        [imageUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat x = 0;
            CGFloat y = 0;
            
            CGFloat temp1 = (idx+1)%2;
            CGFloat temp2 = (idx+1)%3;
            if (idx!=0) {
                if (temp2==0) {
                    x += 140;
                }else if (temp1==0) {
                    x +=70;
                }
                y = (idx/3)*70;
            }
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageUrls.count==1?100:68, imageUrls.count==1?100:68)];
            [image sd_setImageWithURL:obj placeholderImage:[Globals getImageUserHeadDefault]];
            [allImage addSubview:image];
        }];
        imageDoubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PictureClick:)];
        imageDoubleClick.numberOfTapsRequired = 1;
        [allImage addGestureRecognizer:imageDoubleClick];
    }
    
    //时间label
    UILabel *createTimeLabel = nil;
    if (allImage) {
        [cell.contentView addSubview:allImage];
        createTimeLabel =[[UILabel alloc] initWithFrame: CGRectMake(content.left,allImage.bottom+10, 100,20)];
    }else{
        createTimeLabel =[[UILabel alloc] initWithFrame: CGRectMake(content.left,content.bottom+30, 100,20)];
    }
    createTimeLabel.text = [Globals timeStringWith:fb.createTime.doubleValue/1000];
    createTimeLabel.font = [UIFont systemFontOfSize:11];
    createTimeLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:createTimeLabel];
    
    //创建评论按钮
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(cell.width-40, allImage?allImage.bottom:content.bottom+10, 40, 40)];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"evalue"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(presentMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    commentBtn.tag = indexPath.row;
    //aa
    
    [cell.contentView addSubview:commentBtn];
    
    //加载微博的评论
    NSArray * comments = [fb.comments copy];
    if (comments.count == 0) {
        return cell;
    }
    UIView * commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    commentView.layer.masksToBounds = YES;
    commentView.layer.cornerRadius = 4.0;
    [cell.contentView addSubview:commentView];
    BOOL hasContent = NO;
    NSMutableArray *commentContentArr = [NSMutableArray array];
    for (int i=0; i<comments.count; i++) {
        CricleComment *comment = [comments objectAtIndex:i];
        if (comment.content.length!=0) {
            if (!hasContent) {
                hasContent = YES;
            }
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,20)];
            name.font = [UIFont systemFontOfSize:13];
            name.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
            NSMutableString *myText = [comment.creatorName mutableCopy];
            CGSize mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT,name.size.height)];
            [name setFrame:CGRectMake(0, 0, mYsize.width, 20)];
            name.text = myText;
            
            UILabel *spit=nil;UILabel *targetName = nil;
            if (comment.referCreatorName.length>0) {
                spit = [[UILabel alloc] initWithFrame:CGRectMake(name.right+1, 0, 25, 20)];
                spit.font = [UIFont systemFontOfSize:12];
                spit.text  = @"回复";
                
                targetName =[[UILabel alloc] initWithFrame:CGRectMake(spit.right+1, 0, 50, 20)];
                targetName.font = [UIFont systemFontOfSize:12];
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
            [commentView setFrame:CGRectMake(content.left+10, commentBtn.bottom, 220,commentContent.frame.size.height+commentView.frame.size.height)];
            UIButton *clickComment = [[UIButton alloc]init];
            [clickComment setBackgroundColor:[UIColor clearColor]];
            clickComment.frame = commentContent.frame;
            [commentView addSubview:clickComment];
            clickComment.tag = i;
            [clickComment addTarget:self action:@selector(clickLabelComment:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            hasContent = NO;
        }
        
    }
    if (!hasContent) {
        [commentView removeFromSuperview];
        return cell;
    }
    UIImage *bcgImg = [UIImage imageNamed:@"comment-bcg.png"];
    bcgImg = [bcgImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 5, 30) resizingMode:UIImageResizingModeTile];
    UIImageView *temp = [[UIImageView alloc]initWithImage:bcgImg];
    CGRect rc = commentView.frame;
    [temp setFrame:CGRectMake(rc.origin.x-10, rc.origin.y-5, rc.size.width+10, rc.size.height+15)];
    [cell.contentView addSubview:temp];
    [cell.contentView sendSubviewToBack:temp];
    cell.topLine = NO;
    return cell;
}

-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
    FriendBlog * fb = [contentArr objectAtIndex:indexPath.row];
    return fb.avatar;
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadBlogDataSource];
    [_slimeView endRefresh];
}
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}



#pragma mark - My util
- (SRRefreshView *)slimeView {
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

#pragma mark 云联圈工具
-(void)PictureClick:(UITapGestureRecognizer *)sender{
    
    UIView * views = sender.view;
    
    [imageViews removeAllObjects];
    for (id view in views.subviews) {
        UIImageView *imageView = (UIImageView *)view;
        [imageViews addObject:imageView];
    }
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:imageViews selectedView:[imageViews objectAtIndex:0] viewTitles:nil];
}
-(void)presentMoreBtn:(UIButton *) btn{
    selectBtnIndex = btn.tag;
//    CGRect rect = [btn convertRect:[tableView rectForSection:0] toView:[tableView superview]];
//    commentBtns = [[UIView alloc] initWithFrame:CGRectMake(btn.left-100, rect.origin.y+67, 100, 30)];
//    commentBtns.backgroundColor = [UIColor grayColor];
//    commentBtns.layer.masksToBounds = YES;
//    commentBtns.layer.cornerRadius = 3.0;
//    
//    UIButton * btn1 = [[UIButton alloc] init];
//    btn1.tag = btn.tag;
//    btn1.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    btn1.titleLabel.textColor = [UIColor whiteColor];
//    [btn1 setTitle:@"赞" forState:UIControlStateNormal];
//    [btn1 setFrame:CGRectMake(0, 0, commentBtns.width/2-1, commentBtns.height-1)];
//    [btn1 addTarget:self action:@selector(praiseTheMessage:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(commentBtns.width/2, 2, 0.5, commentBtns.height-4)];
//    [lineView setBackgroundColor:[UIColor whiteColor]];
    
//    UIButton * btn2 = [[UIButton alloc] init];
//    btn2.tag = btn.tag;
//    [btn2 setTitle:@"评论" forState:UIControlStateNormal];
//    btn2.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    [btn2 setFrame:CGRectMake(commentBtns.width/2+1, 0, commentBtns.width/2-1, commentBtns.height-1)];
//    btn2.titleLabel.textColor = [UIColor whiteColor];
//    [btn2 addTarget:self action:@selector(commentOfComment:) forControlEvents:UIControlEventTouchUpInside];
    
//    [commentBtns addSubview:btn1];
//    [commentBtns addSubview:btn2];
//    [commentBtns addSubview:lineView];
//    
//    kwpop = [[KWPopoverView alloc]init];
//    [kwpop showPopoverAtPoint:CGPointMake(btn.left, btn.top+10) inView:btn.superview withContentView:commentBtns];
    
    [self commentOfComment:btn];
}
-(void)praiseTheMessage:(UIButton *) btn{
    NSLog(@"赞,%zi",selectBtnIndex);
}

-(void)commentOfComment:(UIButton *) btn{
//    [kwpop dismiss];
    isCommentToComment = NO;
    [self createInputText];
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

-(void)clickLabelComment:(UIButton *)sender{
    
    selectBtnIndex = [[sender superview]superview].tag;
    
    isCommentToComment = YES;
     [self createInputText];
    inputText.tag = sender.tag;
}


-(void)createInputText{
    if(!inputText){
        inputText = [[KTextView alloc] init];
        inputText.layer.masksToBounds = YES;
        inputText.layer.cornerRadius = 3.0;
        inputText.returnKeyType = UIReturnKeyDefault;//键盘按钮名称
        inputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
        inputText.delegate = self;
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        [inputText setFrame:CGRectMake(20,10, rect.size.width-100, 30)];
        inputText.layer.borderColor = RGBACOLOR(210, 213, 218,1).CGColor;
        inputText.layer.borderWidth = 1;
        inputText.layer.cornerRadius = 4;
        inputView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 50)];
//        inputView.backgroundColor = RGBACOLOR(210, 213, 218,1);
        inputView.layer.borderWidth =1;
        inputView.layer.borderColor =RGBACOLOR(210, 213, 218,1).CGColor;
        inputView.backgroundColor = [UIColor whiteColor];
        [inputView addSubview:inputText];
        
        UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-60, 10, 50, 30)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn commonStyle];
        [inputView addSubview:sendBtn];
        [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
        [self.view addSubview:inputView];
    }
    inputText.text=@"";
    if (isCommentToComment) {
       FriendBlog *blog = [contentArr objectAtIndex:selectBtnIndex];
        CricleComment *targetComment = [blog.comments objectAtIndex:inputText.tag];
        [inputText setPlaceholder:[NSString stringWithFormat:@"回复%@",targetComment.creatorName]];
    }else{
        [inputText setPlaceholder:@"说点什么吧..."];
    }
    [inputText becomeFirstResponder];
}

-(void)addComment{
    NSString *sendText = inputText.text;
    CricleComment *comment = nil; FriendBlog *blog=nil;
    if (isCommentToComment) {
        blog = [contentArr objectAtIndex:selectBtnIndex];
        CricleComment *targetComment = [blog.comments objectAtIndex:inputText.tag];
        comment = [[CricleComment alloc]init];
        comment.blogId = blog.ID;
        comment.referId = targetComment.ID;
        comment.content = sendText;
        comment.referCreatorId = targetComment.creatorId;
        comment.referCreatorName = targetComment.creatorName;
    }else{
        blog = [contentArr objectAtIndex:selectBtnIndex];
        comment = [[CricleComment alloc]init];
        comment.blogId = blog.ID;
        comment.content = sendText;
    }
    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestAddBlocCommentFinish:obj:)];
    [client addBlogComment:comment];
    NSMutableArray *comments = [blog.comments mutableCopy];
    User *user = [[BSEngine currentEngine] user];
    comment.creatorName = user.ownerName;
    comment.creatorId = user.ID;
    [comments addObject:comment];
    blog.comments = [comments copy];
    [inputText resignFirstResponder];
//    [inputView removeFromSuperview];

}


-(void)addBlogAction{
    AddBlogViewController *con = [[AddBlogViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}


-(NSArray *)addSubsConment:(NSArray *)comments{
    
    NSMutableArray * array = [NSMutableArray array];
    for (CricleComment *comment in comments) {
        [self addSubsConmentPart:comment intoArr:array];
    }
    return array;
}
-(NSArray *)addSubsConmentPart:(CricleComment *)comment intoArr:(NSMutableArray *)arry{
    [arry addObject:comment];
    NSArray *subComments = comment.subs;
    if (subComments.count!=0) {
        for (CricleComment *sub in subComments) {
            [arry addObject:sub];
            if (sub.subs && sub.subs.count!=0) {
                [self addSubsConmentPart:sub intoArr:arry];
            }
        }
    }
    return arry;
}

#pragma mark - dataSource

-(void)reloadBlogDataSource{
    [contentArr removeAllObjects];
    [self setLoading:YES content:@"正在加载"];
    if ([super startRequest]) {
        [client findFriendBlog:1 pageSize:20];
    }
}

-(void)popViewController{
    [self.tabBarController setSelectedIndex:_sourceSelectIndex];
    [self.tabBarController setViewControllers:self.sourceRootControllers animated:YES];
}
@end
