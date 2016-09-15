//
//  CloudSalePlatform
//
//  Created by cloud on 14-7-21.
//  Copyright (c) 2014年 YunHaoRuanJian. All rights reserved.
//
#import "EmployeeDetailViewController.h"



#import "Employee.h"
#import "UIImageView+WebCache.h"
#import "WebViewByStringViewController.h"
#import "WorksOfEmployeeViewCell.h"
#import "WorksOfEmployeeDetailViewController.h"
#import "Works.h"
@interface EmployeeDetailViewController (){
    UILabel * employeeLabel;
    UILabel * employeePhoneLabel;
    UILabel * employeeProduceCountLabel;
    UIImageView * employeeAvatarView;
    

    UILabel * professionalLevelLabel;
    UILabel * conversationLevelLabel;
    UILabel * comFromCustomerLabel;
}
@property (nonatomic,strong) Employee *employee;
@end


@implementation EmployeeDetailViewController

- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"员工详情";
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 115)];
    [tableHeaderView setBackgroundColor:RGBACOLOR(175, 175, 175,0.2)];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 105)];
    [view setBackgroundColor:[UIColor whiteColor]];
    employeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 10, 80,20)];
    employeePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 30, tableView.width/3,20)];
    employeeLabel.font = [UIFont systemFontOfSize:15];
    employeeLabel.textColor = MyPinkColor;
    employeePhoneLabel.font = [UIFont systemFontOfSize:12];
    employeePhoneLabel.textColor = MygrayColor;
    
    employeeProduceCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, tableView.width/3, 20)];
    employeeProduceCountLabel.textColor = MygrayColor;
    employeeProduceCountLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:employeeProduceCountLabel];
    
    UIImageView * imageLabel1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"works"]];
    UIImageView * imageLabel2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
    imageLabel1.frame = CGRectMake(64, 30, 20, 20);
    imageLabel2.frame = CGRectMake(140, 30, 20, 20);
    
    [view addSubview:imageLabel2];
    [view addSubview:imageLabel1];
    
    [view addSubview:employeePhoneLabel];
    [view addSubview:employeeLabel];
    [tableHeaderView addSubview:view];
    
    employeeAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [employeeAvatarView sd_setImageWithURL:[NSURL URLWithString:_employee.avatar]];
    [view addSubview:employeeAvatarView];
    
    tableView.tableHeaderView = tableHeaderView;
    CGRect tempFrame = tableHeaderView.frame;
    UIButton * clickBtn = [[UIButton alloc] initWithFrame:tempFrame];
    [tableView.tableHeaderView addSubview:clickBtn];
    [clickBtn addTarget:self action:@selector(clickEmployee:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, tableView.width, 1)];
    [line setBackgroundColor:MygrayColor];
    line.alpha = 0.3;
    [view addSubview:line];
    
    professionalLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 75, (tableView.width-4)/3, 20)];
    conversationLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width-4)/3+2, 75, (tableView.width-4)/3, 20)];
    comFromCustomerLabel = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width-4)/3*2+3, 75, (tableView.width-4)/3, 20)];
    professionalLevelLabel.textAlignment =
    conversationLevelLabel.textAlignment =
    comFromCustomerLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:professionalLevelLabel];
    [view addSubview:conversationLevelLabel];
    [view addSubview:comFromCustomerLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((tableView.width-4)/3+1, 75, 0.5, 20)];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake((tableView.width-4)/3*2+2, 75, 0.5, 20)];
    [line2 setBackgroundColor:MygrayColor];
    [line3 setBackgroundColor:MygrayColor];
    [view addSubview:line2];
    [view addSubview:line3];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear) {
        if (_employee ) {
//            [self prepareLoadMoreWithPage:currentPage maxID:0];
            [self reloadProduce];
        }else if (_employeeId.hasValue){
            client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestEmployeeDidFinish:obj:)];
            [client findEmployeeById:_employeeId];
        }
    }
}

- (void)requestEmployeeDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj objectForKey:@"list"];
        if (list.count>0) {
            _employee = [Employee objWithJsonDic:list[0]];
            
            employeeLabel.text = _employee.name;
            employeePhoneLabel.text = _employee.phone;
            employeeProduceCountLabel.text = [NSString stringWithFormat:@"作品0个"];
            [employeeAvatarView sd_setImageWithURL:[NSURL URLWithString:_employee.avatar]];
            
//            [self setStar:4];
            
            NSString * text1 = [NSString stringWithFormat:@"专业：0.0"];
            NSString * text2 = [NSString stringWithFormat:@"沟通：0.0"];
            NSString * text3 = [NSString stringWithFormat:@"顾客评价：0.0"];
            
            NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:text1];
            NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:text2];
            NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc]initWithString:text3];
            
            [attr1 addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica" size:14] range:NSMakeRange(0, text1.length)];
            [attr1 addAttribute:NSForegroundColorAttributeName value:kBlueColor range:NSMakeRange(3, text1.length-3)];
            
            [attr2 addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica" size:14] range:NSMakeRange(0, text2.length)];
            [attr2 addAttribute:NSForegroundColorAttributeName value:MygreenColor range:NSMakeRange(3, text2.length-3)];
            
            [attr3 addAttribute:NSFontAttributeName value:[UIFont  fontWithName:@"Helvetica" size:14] range:NSMakeRange(0, text3.length)];
            [attr3 addAttribute:NSForegroundColorAttributeName value:MyPinkColor range:NSMakeRange(5, text3.length-5)];
            
            professionalLevelLabel.attributedText = attr1;
            conversationLevelLabel.attributedText = attr2;
            comFromCustomerLabel.attributedText = attr3;
            
            [self reloadProduce];
        }
    }
}

-(void)requestWorksDidFinish:(id)sender obj:(NSDictionary *)obj{
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableArray * temp  = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Works * it = [Works objWithJsonDic:obj];
            [temp addObject:it];
        }];
        [self addIntoContentArr:temp];
    }
}
#pragma -mark delegate

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {

        return contentArr.count;

}

- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 180;
}


- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"WorksOfEmployeeViewCell";
    if (!fileNib) {
        fileNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
        [sender registerNib:fileNib forCellReuseIdentifier:CellIdentifier];
    }
    WorksOfEmployeeViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray * it = contentArr[indexPath.row];
    cell.superTableView = tableView;
    cell.indexPath = indexPath;
    [cell setItem:it];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return;
    }
    
    NSArray * array = contentArr[indexPath.row];
    NSDictionary *dic = array[indexPath.section-1];
    NSString *workId = [dic getStringValueForKey:@"id" defaultValue:@""];
    if ([workId hasValue]) {
        WorksOfEmployeeDetailViewController * con = [[WorksOfEmployeeDetailViewController alloc]initWithWorkId:workId];
        [self pushViewController:con];
    }
}


#pragma mark -Util and Action
-(void)clickEmployee:(UIButton *)sender{
    if (!_employee) {
        return;
    }
    WebViewByStringViewController * con = [[WebViewByStringViewController alloc] init];
    con.viewString = _employee.display;
    con.viewTitle = _employee.name;
    [self pushViewController:con];
}

-(void)reloadProduce{
    [contentArr removeAllObjects];
    client = [[BSClient alloc]initWithDelegate:self action:@selector(requestWorksDidFinish:obj:)];
    [client findEmpWorks:[BSEngine currentEngine].user.currentShopId empId:_employee.ID p:1];
//    for (int i=0; i<3; i++) {
//        NSMutableArray * array = [NSMutableArray array];
//        for (int j = 0; j<2; j++) {
//            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//            [dic setObject:@"http://img.cloudvast.com/cos/avatar/employee/5d2cac12-c71f-4ae2-9aba-3c58330736e6/a9fcf29b-a5fa-4c4c-a396-a085d0b76dd9.JPG" forKey:@"imagePath"];
//            [dic setObject:@"喵喵" forKey:@"name"];
//            [dic setObject:@"abcde" forKey:@"id"];
//            [array addObject:dic];
//        }
//        [contentArr addObject:array];
//    }
//    [tableView reloadData];
}

-(void)addIntoContentArr:(NSArray *)array{
    if (array.count==0) {
        return;
    }
    CGFloat totalRow =array.count==1?1:array.count/2;
    for (int i = 0; i<totalRow; i++) {
        NSMutableArray * temp = [NSMutableArray array];
        for (int j = 0; j<2; j++) {
            if (array.count <=(i*2+j)) {
                break;
            }
            Works * works = array[i*2+j];
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:works.picture forKey:@"imagePath"];
            [dic setObject:works.name forKey:@"name"];
            [dic setObject:works.ID forKey:@"id"];
            [temp addObject:dic];
        }
        [contentArr addObject:temp];
    }
    
    [tableView reloadData];
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
//    if (isloadByslime) {
//        [self setLoading:YES content:@"正在重新获取评论列表"];
//    } else {
//        [self setLoading:YES content:@"正在加载评论"];
//    }
//    client = nil;
//    if ([super startRequest]) {
//       [client findCommentWithId:nil targetId:_employee.ID targetType:EMPLOYEE page:page];
//    }
}


//-(void)setStar:(int)score{
//    int red = score;
//    int gray = 5-red;
//    for (double i=0; i<red; i++) {
//        UIView *view = [tableView.tableHeaderView viewWithTag:i+200];
//        if (!view) {
//            view = [[UIView alloc] init];
//            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar"]]];
//            view.top = 15;
//            view.size = CGSizeMake(9, 9);
//            view.left = employeeLabel.right + i*10;
//            view.tag = i+200;
//            [tableView.tableHeaderView addSubview:view];
//        }
//    }
//    for (double i=0; i<gray; i++) {
//        UIView *view = [tableView.tableHeaderView viewWithTag:i+210];
//        if (!view) {
//            view = [[UIView alloc] init];
//            [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shopStar2"]]];
//            view.top = 15;
//            view.size = CGSizeMake(9, 9);
//            view.left = employeeLabel.right + (i+red)*10;
//            view.tag = i+210;
//            [tableView.tableHeaderView addSubview:view];
//        }
//    }
//}

@end
















//#import "Globals.h"
//#import "BaseTableViewCell.h"
//#import "UIImage+FlatUI.h"
//#import "UIButton+Bootstrap.h"
//#import "UIButton+NSIndexPath.h"
//
//#import "CommentsViewController.h"
//#import "ContactDetailViewController.h"
//#import "KWAlertView.h"
//#import "TextInput.h"
//#import "UIImageView+WebCache.h"
//#import "Comment.h"
//#import "Employee.h"
//
//#import "WebViewByStringViewController.h"
//
//
//@interface EmployeeDetailViewController ()<UITextViewDelegate>{
//
//    KTextView *inputText;
//
//    UITextView *appointInputText;
//    UIView *inputView;
//    UITapGestureRecognizer *tap;
//
//    CGFloat btnCurrentTop;
//
//        UIButton *sendBtn;
//
//    UILabel * employeeLabel;
//    UILabel * employeePhoneLabel;
//    UIImageView * employeeAvatarView;
//}
//
//@property (nonatomic,strong) Employee *employee;
//
//@end
//
//@implementation EmployeeDetailViewController
//
//- (void)dealloc {
//
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.navigationItem.title = @"员工详情";
//
//    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 65)];
//   [tableHeaderView setBackgroundColor:RGBACOLOR(175, 175, 175,0.2)];
//
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 55)];
//    [view setBackgroundColor:[UIColor whiteColor]];
//   employeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 10, tableView.width-100,20)];
//    employeePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 30, tableView.width-100,20)];
//    employeeLabel.text = _employee.name;
//    employeePhoneLabel.text = _employee.phone;
//    employeeLabel.font = [UIFont systemFontOfSize:15];
//    employeePhoneLabel.font = [UIFont systemFontOfSize:12];
//    employeePhoneLabel.textColor = MygrayColor;
//    [view addSubview:employeePhoneLabel];
//    [view addSubview:employeeLabel];
//    [tableHeaderView addSubview:view];
//
//    UIButton * appointBtn = [[UIButton alloc]initWithFrame:CGRectMake(tableView.width-50,0,50, 50)];
//    [appointBtn setBackgroundImage:[UIImage imageNamed:@"appointment_btn"] forState:UIControlStateNormal];
//    [appointBtn addTarget:self action:@selector(appointmentAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
//    [tableHeaderView addSubview:appointBtn];
//
//    employeeAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 34, 34)];
//    [employeeAvatarView sd_setImageWithURL:[NSURL URLWithString:_employee.avatar]];
//    [view addSubview:employeeAvatarView];
//
//    tableView.tableHeaderView = tableHeaderView;
//
//    CGRect tempFrame = tableHeaderView.frame;
//    tempFrame.size.width -=50;
//    UIButton * clickBtn = [[UIButton alloc] initWithFrame:tempFrame];
//    [tableView.tableHeaderView addSubview:clickBtn];
//
//    [clickBtn addTarget:self action:@selector(clickEmployee:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self setRightBarButtonImage:[UIImage imageNamed:@"comment_all_btn"] highlightedImage:nil selector:@selector(commentEmployeeBtn)];
//
//    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (isFirstAppear && [super startRequest]) {
//        if (_employee) {
//             [self prepareLoadMoreWithPage:currentPage maxID:0];
//        }else if (_employeeId.hasValue){
//            client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestEmployeeDidFinish:obj:)];
//            [client findEmployeeById:_employeeId];
//        }
//    }
//}
//
//- (void)requestEmployeeDidFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray * list = [obj objectForKey:@"list"];
//        if (list.count>0) {
//            _employee = [Employee objWithJsonDic:list[0]];
//
//            employeeLabel.text = _employee.name;
//            employeePhoneLabel.text = _employee.phone;
//            [employeeAvatarView sd_setImageWithURL:[NSURL URLWithString:_employee.avatar]];
//            [self prepareLoadMoreWithPage:currentPage maxID:0];
//        }
//    }
//}
//
//- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
//    if (isloadByslime) {
//        [self setLoading:YES content:@"正在重新获取评论列表"];
//    } else {
//        [self setLoading:YES content:@"正在加载评论"];
//    }
//    client = nil;
//    if ([super startRequest]) {
//       [client findCommentWithId:nil targetId:_employee.ID targetType:EMPLOYEE page:page];
//    }
//}
//- (BOOL)requestDidFinish:(id)sender obj:(NSDictionary *)obj {
//    if ([super requestDidFinish:sender obj:obj]) {
//        NSArray * list = [obj objectForKey:@"list"];
//        if (list.count!=0) {
//            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                Comment *comment = [Comment objWithJsonDic:obj];
//                NSMutableArray * array = [NSMutableArray array];
//                [self addSubsConmentPart:comment intoArr:array];
//                comment.subs = array;
//                [contentArr addObject:comment];
//            }];
//            [tableView reloadData];
//        }
//    }
//    return YES;
//}
//
//-(void)addSubsConmentPart:(Comment *)comment intoArr:(NSMutableArray *)arry{
//    NSArray *subComments = comment.subs;
//    if (subComments.count!=0) {
//        for (Comment *sub in subComments) {
//            [arry addObject:sub];
//            if (sub.subs && sub.subs.count!=0) {
//                [self addSubsConmentPart:sub intoArr:arry];
//            }
//        }
//    }
//}
//
//- (void)requestCommentDidFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        [inputText resignFirstResponder];
//
//        Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
//        [contentArr addObject:comment];
//        [contentArr insertObject:comment atIndex:0];
//        [tableView reloadData];
//        [self showText:@"评论成功"];
//    }
//}
//
//
//#pragma -mark delegate
//
//- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
//
//        return contentArr.count+1;
//
//}
//
//- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//        if (indexPath.row==0) {
//            return 40;
//        }
//        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
//        int numb = 60;
//        if (comment.content.length>0) {
//            CGSize size = [comment.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,200) lineBreakMode:NSLineBreakByWordWrapping];
//            numb +=size.height;
//        }
//        if (comment.subs.count>0) {
//            for (int i = 0; i<comment.subs.count; i++) {
//                CGSize size =  [((Comment *)[comment.subs objectAtIndex:i]).content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200,MAXFLOAT)];
//                numb += size.height+10;
//            }
//            numb +=10;
//        }
//    return numb;
//}
//
//- (CGFloat)heightofText:(NSString*)text fontSize:(int)fontSize{
//    CGFloat height = 22;
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
//    height += size.height;
//    return height;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * CellIdentifier = @"BaseTableViewCell";
//    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    UILabel * totalCommentCountLabel = VIEWWITHTAG(cell.contentView, 172);
//    UILabel * commentContentLabel = VIEWWITHTAG(cell.contentView, 173);
//    UILabel * createTimeLabel = VIEWWITHTAG(cell.contentView, 174);
//    UIButton *commentBtn = VIEWWITHTAG(cell.contentView, 175);
//
//    UIView * commentView = VIEWWITHTAG(cell.contentView, 176);
//    [commentView removeFromSuperview];
//    __block UIImageView *bcgImgView = VIEWWITHTAG(cell.contentView, 177);
//    [bcgImgView removeFromSuperview];
//
//    if (!cell) {
//        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//
//        totalCommentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width-110, -5, 90, 50)];
//        totalCommentCountLabel.textAlignment = NSTextAlignmentRight;
//        totalCommentCountLabel.textColor = MyPinkColor;
//        totalCommentCountLabel.font = [UIFont systemFontOfSize:14];
//        totalCommentCountLabel.tag = 172;
//        [cell.contentView addSubview:totalCommentCountLabel];
//        commentContentLabel = [[UILabel alloc] init];
//        commentContentLabel.textColor = RGBCOLOR(79, 79, 79);
//        commentContentLabel.font = [UIFont systemFontOfSize:12];
//        commentContentLabel.tag = 173;
//        commentContentLabel.numberOfLines = 0;
//        [cell.contentView addSubview:commentContentLabel];
//        createTimeLabel = [[UILabel alloc] init];
//        createTimeLabel.width = 70;
//        createTimeLabel.height = 20;
//        createTimeLabel.left = cell.width-80;
//        createTimeLabel.top = 10;
//        createTimeLabel.tag = 174;
//        createTimeLabel.font = [UIFont systemFontOfSize:11];
//        createTimeLabel.textColor = [UIColor grayColor];
//        createTimeLabel.textAlignment = NSTextAlignmentRight;
//        [cell.contentView addSubview:createTimeLabel];
//
//        commentBtn = [[UIButton alloc] init];
//        [commentBtn setBackgroundImage:[UIImage imageNamed:@"evalue.png"] forState:UIControlStateNormal];
//        [commentBtn addTarget:self action:@selector(presentMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//        commentBtn.tag = 175;
//        [cell.contentView addSubview:commentBtn];
//
//    }
//    commentBtn.indexPath = indexPath;
//
//    if (indexPath.row!=0) {
//        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
//        if ([comment.subs isKindOfClass:[NSArray class]]&&comment.subs.count>0) {
//            commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
//            commentView.layer.masksToBounds = YES;
//            commentView.layer.cornerRadius = 4.0;
//            commentView.tag = 176;
//            [cell.contentView addSubview:commentView];
//
//            UIImage *bcgImg = [UIImage imageNamed:@"comment-bcg"];
//            bcgImg = [bcgImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 5, 30) resizingMode:UIImageResizingModeTile];
//            bcgImgView = [[UIImageView alloc]initWithImage:bcgImg];
//        }
//    }
//
//    cell.textLabel.text         =
//    totalCommentCountLabel.text =
//    commentContentLabel.text =
//    createTimeLabel.text =
//    cell.detailTextLabel.text   = @"";
//    cell.imageView.hidden = NO;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell removeArrowRight];
//    [cell update:^(NSString *name) {
//            if (indexPath.row ==0) {
//                cell.imageView.hidden = YES;
//                cell.textLabel.text = @"评论";
//                cell.textLabel.frame = CGRectMake(10, 10, 40, 20);
//                totalCommentCountLabel.text = [NSString stringWithFormat:@"%lu人评论",(unsigned long)contentArr.count];
//            }else{
//                Comment *currentComment = [contentArr objectAtIndex:indexPath.row-1];
//                cell.imageView.frame = CGRectMake(10, 10, 34, 34);
//                cell.textLabel.text =currentComment.creatorName;
//                cell.textLabel.frame = CGRectMake(64, 10, cell.width-100,20);
//                CGSize size = [self sizeTofText:currentComment.content fontSize:12];
//                commentContentLabel.text = currentComment.content;
//                commentContentLabel.frame = CGRectMake(64, 35, size.width, size.height);
//
//                createTimeLabel.text = [Globals timeStringWith:currentComment.createTime.doubleValue/1000];
//                commentBtn.frame = CGRectMake(cell.width-40, commentContentLabel.bottom-10, 40, 40);
//                if ([currentComment.subs isKindOfClass:[NSArray class]]&&currentComment.subs.count>0) {
//                    NSArray * comments = [currentComment.subs copy];
//                    BOOL hasContent = NO;
//                    NSMutableArray *commentContentArr = [NSMutableArray array];
//                    for (int i=0; i<comments.count; i++) {
//                        Comment *comment = [comments objectAtIndex:i];
//                        if (comment.content.length!=0) {
//                            if (!hasContent) {
//                                hasContent = YES;
//                            }
//                            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0,20)];
//                            name.font = [UIFont systemFontOfSize:13];
//                            name.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
//                            NSMutableString *myText = [comment.creatorName mutableCopy];
//                            if ([comment isBossReply]) {
//                                myText = [NSMutableString stringWithFormat:@"店长"];
//                                name.textColor = MyPinkColor;
//                            }
//                            CGSize mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT,name.size.height)];
//                            [name setFrame:CGRectMake(0, 0, mYsize.width, 20)];
//                            name.text = myText;
//
//                            UILabel *spit=nil;UILabel *targetName = nil;
//                            if (comment.referCreatorName.length>0 && ![currentComment.ID isEqualToString:comment.referId]) {
//                                spit = [[UILabel alloc] initWithFrame:CGRectMake(name.right+1, 0, 25, 20)];
//                                spit.font = [UIFont systemFontOfSize:12];
//                                spit.text  = @"回复";
//
//                                targetName =[[UILabel alloc] initWithFrame:CGRectMake(spit.right+1, 0, 50, 20)];
//                                targetName.font = [UIFont systemFontOfSize:13];
//                                targetName.textColor = [UIColor colorWithRed:95/255.0 green:158/255.0 blue:160/255.0 alpha:1];
//                                myText = [comment.referCreatorName mutableCopy];
//                                mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(MAXFLOAT,targetName.size.height)];
//                                [targetName setFrame:CGRectMake(spit.right+1, 0, mYsize.width, 20)];
//                                targetName.text = myText;
//                            }
//                            UILabel *commentContent =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 0)];
//                            commentContent.font = [UIFont systemFontOfSize:13];
//                            commentContent.numberOfLines =0;
//                            commentContent.lineBreakMode = NSLineBreakByWordWrapping;
//                            NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//                            style.firstLineHeadIndent = (name.width+(spit?spit.width:0)+(targetName?targetName.width:0)+6);//首行缩进
//                            style.alignment = NSTextAlignmentLeft;
//                            style.lineBreakMode =NSLineBreakByWordWrapping;
//                            //            style.lineSpacing = 5;
//
//                            myText = [NSMutableString stringWithFormat:@"："];
//                            [myText appendString:comment.content];
//                            mYsize = [myText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(commentContent.size.width,MAXFLOAT)];
//
//                            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:myText attributes:@{ NSParagraphStyleAttributeName : style}];
//                            commentContent.attributedText = attrText;
//                            //            if (i!=0) {
//                            double totalHeight = 5.0f;
//                            for (UILabel *temp in commentContentArr) {
//                                totalHeight +=temp.frame.size.height;
//                            }
//                            [commentContent setFrame:CGRectMake(0, totalHeight, 200, mYsize.height+5)];
//                            [commentContentArr addObject:commentContent];
//                            UIView *nameDitel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 22)];
//                            [nameDitel addSubview:name];
//                            [nameDitel addSubview:spit];
//                            [nameDitel addSubview:targetName];
//                            [commentContent addSubview:nameDitel];
//                            [commentView addSubview:commentContent];
//                            commentView.size = CGSizeMake(220,commentContent.frame.size.height+commentView.frame.size.height+1);
//                            UIButton *clickComment = [[UIButton alloc]init];
//                            [clickComment setBackgroundColor:[UIColor clearColor]];
//                            clickComment.frame = commentContent.frame;
//                            [commentView addSubview:clickComment];
//                            clickComment.tag = i;
//                            clickComment.indexPath = indexPath;
//                            [clickComment addTarget:self action:@selector(clickLabelComment:) forControlEvents:UIControlEventTouchUpInside];
//                        }else{
//                            hasContent = NO;
//                        }
//
//                    }
//
//                    commentView.left = 74;
//                    commentView.top = commentBtn.bottom-10;
//
//                    CGRect rc = commentView.frame;
//                    bcgImgView.tag = 177;
//                    [bcgImgView setFrame:CGRectMake(rc.origin.x-10, rc.origin.y-5, rc.size.width+10, rc.size.height+15)];
//                    [cell.contentView addSubview:bcgImgView];
//                    [cell.contentView sendSubviewToBack:bcgImgView];
//                    if (!hasContent) {
//                        [commentView removeFromSuperview];
//                        [bcgImgView removeFromSuperview];
//                    }
//                }
//        }
//    }];
//    cell.indexPath = indexPath;
//    cell.superTableView = sender;
//    return cell;
//}
//
//
//-(NSString *)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row!=0) {
//        Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
//        return comment.creatorAvatar;
//    }
//    return nil;
//}
//
//- (void)tableView:(id)sender didTapHeaderAtIndexPath:(NSIndexPath*)indexPath{
//    Comment *comment = [contentArr objectAtIndex:indexPath.row-1];
//    ContactDetailViewController *con = [[ContactDetailViewController alloc] init];
//    con.phone = comment.creatorId;
//    [self pushViewController:con];
//}
//
//#pragma mark - buy button
//-(CGSize)sizeTofText:(NSString*)text fontSize:(int)fontSize{
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:(self.view.width - 35) maxNumberLines:0];
//    return size;
//}
//
//
//
//-(void)commentEmployeeBtn{
//    [self initInputTextWithSendBtnTag:-1];
//    inputText.tag = -1;
//    [inputText setPlaceholder:@"说点什么吧！"];
//    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
//    [inputText becomeFirstResponder];
//
//}
//
//-(void)presentMoreBtn:(UIButton *) btn{
//    [self initInputTextWithSendBtnTag:-1];
//    inputText.tag = btn.indexPath.row;
//    Comment *comment = [contentArr objectAtIndex:btn.indexPath.row-1];
//    [inputText setPlaceholder:[NSString stringWithFormat:@"回复%@",comment.creatorName]];
//    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
//    [inputText becomeFirstResponder];
//
//}
//- (void)clickLabelComment:(UIButton *)btn{
//    Comment *comment = [contentArr objectAtIndex:btn.indexPath.row-1];
//    Comment *sub = [comment.subs objectAtIndex:btn.tag];
//    [self initInputTextWithSendBtnTag:btn.tag];
//    inputText.tag = btn.indexPath.row;
//    [inputText setPlaceholder:[NSString stringWithFormat:@"回复%@",sub.creatorName]];
//    [inputText setplaceholderTextAlignment:NSTextAlignmentLeft];
//    [inputText becomeFirstResponder];
//
//}
//
//
//- (void)initInputTextWithSendBtnTag:(NSInteger)tag{
//    if(!inputText){
//        inputText = [[KTextView alloc] init];
//        inputText.layer.masksToBounds = YES;
//        inputText.layer.cornerRadius = 3.0;
//        inputText.returnKeyType = UIReturnKeyDefault;//键盘按钮名称
//        inputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
//
//        CGRect rect = [[UIScreen mainScreen] bounds];
//        [inputText setFrame:CGRectMake(20,10, rect.size.width-150, 30)];
//        inputText.layer.borderColor = RGBACOLOR(210, 213, 218,1).CGColor;
//        inputText.layer.borderWidth = 1;
//        inputText.layer.cornerRadius = 4;
//        inputView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 50)];
//        //        inputView.backgroundColor = RGBACOLOR(210, 213, 218,1);
//        inputView.layer.borderWidth =1;
//        inputView.layer.borderColor =RGBACOLOR(210, 213, 218,1).CGColor;
//        inputView.backgroundColor = [UIColor whiteColor];
//        [inputView addSubview:inputText];
//
//        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-60, 10, 50, 30)];
//        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
//        [cancelBtn pinkStyle];
//        [inputView addSubview:cancelBtn];
//
//        sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(rect.size.width-120, 10, 50, 30)];
//        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//        [sendBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
//        [sendBtn commonStyle];
//        [inputView addSubview:sendBtn];
//
//        [self.view addSubview:inputView];
//    }
//    sendBtn.tag = tag;
//    inputText.text = @"";
//}
//
//- (void)tapped:(UITapGestureRecognizer *)tap{
//    [inputText resignFirstResponder];
//}
////当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)aNotification{
//    //获取键盘的高度
//    if (inputText.isFirstResponder) {
//        NSDictionary *userInfo = [aNotification userInfo];
//        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];
//
//
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = inputView.frame;
//            rect.origin.y = keyboardRect.origin.y-110;
//            inputView.frame = rect;
//        }];
//        [self.view bringSubviewToFront:inputView];
//    }
//}
////当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification
//{
//     if (inputText.isFirstResponder) {
//        NSDictionary *userInfo = [aNotification userInfo];
//        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];
//
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = inputView.frame;
//            rect.origin.y = keyboardRect.origin.y;
//            inputView.frame = rect;
//        }];
//     }
//}
//
//-(void)addComment:(UIButton *)btn{
//    NSString *content = inputText.text;
//    if (!content.hasValue) {
//        return;
//    }
//    if(inputText.tag==-1){
//        client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCommentDidFinish:obj:)];
//        [client createComment:content score:nil referId:nil targetId:_employee.ID targetType:EMPLOYEE];
//    }else{
//        if (btn.tag>-1) {
//            Comment *comment = [contentArr objectAtIndex:inputText.tag-1];
//            Comment *sub = [comment.subs objectAtIndex:btn.tag];
//            client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCreateSubCommentDidFinish:obj:)];
//            [client createComment:content score:nil referId:sub.ID targetId:nil targetType:NoneCommentType];
//        }else{
//            Comment *targetComment = [contentArr objectAtIndex:inputText.tag-1];
//            client  = [[BSClient alloc]initWithDelegate:self action:@selector(requestCreateSubCommentDidFinish:obj:)];
//            [client createComment:content score:nil referId:targetComment.ID targetId:nil targetType:NoneCommentType];
//        }
//    }
//}
//
//- (void)requestCreateSubCommentDidFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        [inputText resignFirstResponder];
//        Comment *targetComment = [contentArr objectAtIndex:inputText.tag-1];
//        NSMutableArray *subComments = [targetComment.subs mutableCopy];
//        Comment *comment = [Comment objWithJsonDic:[obj getDictionaryForKey:@"comment"]];
//        [subComments addObject:comment];
//
//        targetComment.subs = subComments;
//        [tableView reloadData];
//        [self showText:@"回复成功"];
//    }
//}
//
//#pragma mark -KWAlertDelegate
//-(void)kwAlertView:(KWAlertView *)sender didDismissWithButtonIndex:(NSInteger)index{
//    if (index==1) {
//        client = [[BSClient alloc]initWithDelegate:self action:@selector(doAppointmentFinish:obj:)];
//        [client addAppointmentByEmpId:_employee.ID remark:appointInputText.text];
//    }
//}
//-(void)doAppointmentFinish:(id)sender obj:(NSDictionary *)obj{
//    if ([super requestDidFinish:sender obj:obj]) {
//        [self showText:@"预约成功"];
//    }
//}
//#pragma mark - buy button
//- (void)appointmentAtIndexPath:(UIButton*)sender {
//    //打开键盘添加预约备注
//    appointInputText = [self createInputText:_employee.name];
//}
//
//-(UITextView *)createInputText:(NSString *)labelText{
//    if(!appointInputText){
//        appointInputText = [[UITextView alloc] init];
//        appointInputText.layer.masksToBounds = YES;
//        appointInputText.layer.cornerRadius = 3.0;
//        appointInputText.returnKeyType = UIReturnKeySend;//键盘按钮名称
//        appointInputText.enablesReturnKeyAutomatically = YES;//发送按钮有内容才激活
//        appointInputText.delegate = self;
//    }
//    NSString *message = [NSString stringWithFormat:@"预约 %@",labelText];
//    KWAlertView * alert = [[KWAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" textViews:[NSArray arrayWithObjects:appointInputText, nil] otherButtonTitles:@"取消", nil];
//    [alert show];
//
//    [appointInputText becomeFirstResponder];
//    return appointInputText;
//}
//
//-(void)clickEmployee:(UIButton *)sender{
//    if (!_employee) {
//        return;
//    }
//    WebViewByStringViewController * con = [[WebViewByStringViewController alloc] init];
//    con.viewString = _employee.display;
//    con.viewTitle = _employee.name;
//    [self pushViewController:con];
//}
//@end