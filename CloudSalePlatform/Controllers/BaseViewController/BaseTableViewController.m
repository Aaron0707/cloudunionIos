//  BaseTableViewController.m
//  CarPool
//
//  Created by kiwi on 14-6-23.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"
#import "Globals.h"
#import "SRRefreshView.h"
#import "UIImage+Resize.h"
#import "BaseTableView.h"
#import "WebViewController.h"

@implementation SearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
}

@end

@interface BaseTableViewController ()<ImageProgressQueueDelegate, SRRefreshDelegate, UISearchDisplayDelegate> {
    UIImageView * wordView;
    UILabel     * titleLabel;
}
@end

@implementation BaseTableViewController
@synthesize tableViewCellHeight, tag;
@dynamic dataArray, currectTableView;
@synthesize mySearchDisplayController, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        contentArr = [[NSMutableArray alloc] init];
        baseImageQueue = [[ImageProgressQueue alloc] initWithDelegate:self];
        baseImageCaches = [[ImageCaches alloc] initWithMaxCount:150];
        baseOperationQueue = [[NSOperationQueue alloc] init];
        baseOperationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc {
    tableView.dataSource = nil;
    tableView.delegate = nil;
    if ([tableView isKindOfClass:[BaseTableView class]]) {
        tableView.baseDataSource = nil;
    }
    Release(tableView);
    Release(mySearchDisplayController);
    Release(searchBar);
    Release(contentArr);
    Release(filterArr);
    
    fileNib = nil;
    fileNibFilter = nil;
    
    
    Release(baseImageCaches);
    
    [baseImageQueue cancelOperations];
    Release(baseImageQueue);
    
    [baseOperationQueue cancelAllOperations];
    Release(baseOperationQueue);
    
    Release(wordView);
    Release(titleLabel);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!tableView) {
        tableView = [[BaseTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        tableView.top = 0;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
    }
    [self setupTableView];
    [self configureTableViewSection];
    currentPage = 1;
    self.view.backgroundColor =
    tableView.backgroundColor = RGBCOLOR(240, 239, 237);
    headImageViewSize = 50;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (client == nil) {
        [refreshControl performSelector:@selector(endRefreshing) withObject:nil];
//        [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0];
    }
}

- (UISearchBar*)searchBar {
    if (!searchBar) {
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        searchBar.placeholder = @"搜索";
    }
    return searchBar;
}

- (UISearchDisplayController*)mySearchDisplayController {
    if (!mySearchDisplayController) {
        mySearchDisplayController =[[SearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        mySearchDisplayController.searchResultsDelegate = self;
        mySearchDisplayController.searchResultsDataSource = self;
        mySearchDisplayController.delegate = self;
        mySearchDisplayController.searchResultsTableView.backgroundView = nil;
        //Set the background color
        mySearchDisplayController.searchResultsTableView.backgroundColor =
        RGBCOLOR(224, 224, 221);
        mySearchDisplayController.searchResultsTableView.separatorStyle =
        UITableViewCellSeparatorStyleNone;
    }
    return mySearchDisplayController;
}

- (void)setupTableView {
    self.tableViewCellHeight = 44;
    filterArr = [[NSMutableArray alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)settableViewCellHeight:(CGFloat)hei {
    tableViewCellHeight = hei;
    tableView.tableViewCellHeight = hei;
}

- (void)configureTableViewSection {
    //改变索引选中的背景颜色
    if (Sys_Version >= 6.0) {
        //改变索引的颜色
        tableView.sectionIndexColor = RGBCOLOR(123, 122, 121);
        tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        if (Sys_Version >= 7.0) {
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.clipsToBounds = NO;
        }
    }
    int width = tableView.width/2;
    int height = tableView.height/2;
    wordView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2+50, height/2+50, 100, 100)];
    wordView.backgroundColor = [UIColor clearColor];
    wordView.image = [UIImage imageNamed:@"bg_scroll_index"];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 100)];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [wordView addSubview:titleLabel];
    [self.view addSubview:wordView];
    wordView.alpha = 0;
}

- (NSArray*)dataArray {
    return inFilter?filterArr:contentArr;
}

- (UITableView*)currectTableView {
    return inFilter?self.mySearchDisplayController.searchResultsTableView:tableView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    titleLabel.text = title;
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
        wordView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:YES];
            wordView.alpha = 0;
        }];
    }];
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //to be impletemented in sub-class
    return 1;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section
{
    //to be impletemented in sub-class
    NSInteger rowsNumber = 0;
    if (sender == tableView) {
        rowsNumber = contentArr.count;
    } else if (sender == self.searchDisplayController.searchResultsTableView) {
        rowsNumber = filterArr.count;
    }
    return rowsNumber;
}

- (BaseTableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //to be impletemented in sub-class
    static NSString * CellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell * cell = [sender dequeueReusableCellWithIdentifier:CellIdentifier];
    if (inFilter) {
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    } else {
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //to be impletemented in sub-class
    return self.tableViewCellHeight;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //to be impletemented in sub-class
    [sender deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)sender willDisplayCell:(BaseTableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //to be impletemented in sub-class
    cell.imageView.image = [Globals getImageDefault];

    NSInvocationOperation * opHeadItem = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadHeadImageWithIndexPath:) object:indexPath];
    [baseOperationQueue addOperation:opHeadItem];
}

- (void)needRadius:(NSIndexPath*)indexPath cell:(BaseTableViewCell*)cell {
    BOOL    topLeft     = NO;
    BOOL    topRight    = NO;
    BOOL    bottomLeft  = NO;
    BOOL    bottomRight = NO;
    if (indexPath.row == 0) {
        topLeft     = YES;
        topRight    = YES;
    }
    if (indexPath.row == contentArr.count - 1) {
        bottomLeft  = YES;
        bottomRight = YES;
    }
    cell.selectedBackgroundView = [cell.selectedBackgroundView roundCornersOnTopLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight radius:5];
    cell.backgroundView = [cell.backgroundView roundCornersOnTopLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight radius:5];
    cell.topLineView.frame = CGRectMake(10, 0, cell.width-20, 0.5);
    [cell bringSubviewToFront:cell.topLineView];
}

- (void)loadImageWithIndexPath:(NSIndexPath *)indexPath {
    //to be impletemented in sub-class
}

- (void)loadHeadImageWithIndexPath:(NSIndexPath *)indexPath {
    NSString * url = [self baseTableView:self.currectTableView imageURLAtIndexPath:indexPath];
    if (url) {
        UIImage * img = [baseImageCaches getImageCache:[url md5Hex]];
        if (!img) {
            ImageProgress * progress = [[ImageProgress alloc] initWithUrl:url delegate:baseImageQueue];
            progress.indexPath = indexPath;
            progress.tag = -1;
            [self performSelectorOnMainThread:@selector(startLoadingWithProgress:) withObject:progress waitUntilDone:YES];
        } else {
            dispatch_async(kQueueMain, ^{
                [self setHeadImage:img forIndex:indexPath];
            });
        }
    }
}

- (void)setHeadImage:(UIImage*)image forIndex:(NSIndexPath*)indexPath {
    BaseTableViewCell * cell = (BaseTableViewCell*)[self.currectTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = image;
}

- (void)startLoadingWithProgress:(ImageProgress*)sender {
    UIImage * ima = nil;
    if (sender.loaded) {
        ima = sender.image;
//        ima = [sender.image resizeImageGreaterThan:(sender.tag == -1)?headImageViewSize:[self baseTableView:tableView imageSizeAtIndexPath:sender.indexPath]];
        [baseImageCaches insertImageCache:ima withKey:[sender.imageURLString md5Hex]];
    } else {
        [baseImageQueue addOperation:sender];
    }
    
    if (!ima) {
        if (sender.tag == -1) {
            ima = [Globals getImageDefault];
        } else {
            ima = [Globals getImageGray];
        }
    }
    [self baseTableView:sender.tag imageUpdateAtIndexPath:sender.indexPath image:ima];
}

- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (CGFloat)baseTableView:(UITableView *)sender imageSizeAtIndexPath:(NSIndexPath*)indexPath {
    return headImageViewSize;
}

- (void)baseTableView:(int)tag imageUpdateAtIndexPath:(NSIndexPath*)indexPath image:(UIImage *)image {
    [self setHeadImage:image forIndex:indexPath];
}

#pragma mark - imageProgress

- (void)imageProgressCompleted:(UIImage*)img indexPath:(NSIndexPath*)indexPath tag:(int)_tag url:(NSString *)url {
    //to be impletemented in sub-class
//    img = [img resizeImageGreaterThan:(tag == -1)?headImageViewSize:[self baseTableView:tableView imageSizeAtIndexPath:indexPath]];
    [baseImageCaches insertImageCache:img withKey:[url md5Hex]];
    [self baseTableView:_tag imageUpdateAtIndexPath:indexPath image:img];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender == tableView && sender.contentSize.height + 30 > sender.height) {
        if (sender.contentOffset.y + 44 < (sender.contentSize.height - sender.height)) {
            
        } else if (sender.contentOffset.y + 5 >= (sender.contentSize.height - sender.height)) {
            if (contentArr.count < totalCount) {
                [self loadMoreRequest];
            }
        }
    }
    if ([refreshControl isKindOfClass:[SRRefreshView class]]) [(SRRefreshView*)refreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([refreshControl isKindOfClass:[SRRefreshView class]]) [(SRRefreshView*)refreshControl scrollViewDidEndDraging];
}

- (void)refreshDataList {
    if (client) {
        return;
    }
    hasMore = NO;
    isNeedMore = NO;
    currentPage = 1;
    baseRequestType = forBaseListRequestDataList;
    [self startRequest];
}

- (void)refreshDataListIfNeed {
    if (contentArr.count == 0) {
        [self refreshDataList];
    }
}

- (void)cancelRequestIfNeed {
    if (client) {
        [client cancel];
        client = nil;
        self.loading = NO;
    }
}

#pragma mark - Requests
- (void)prepareRequest:(int)reqID {
    //to be implemented in sub-classes
}

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary*)obj {
    if (isloadByslime) {
        [contentArr removeAllObjects];
    }
    isloadByslime = NO;
    BOOL res = [super requestDidFinish:sender obj:obj];
    tableView.userInteractionEnabled = YES;
    if (res) {
        [self updatePageInfo:obj];
    }
    return res;
}

- (void)updatePageInfo:(id)obj {
    isloadByslime = NO;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary * pageInfo = [obj getDictionaryForKey:@"pager"];
        if (pageInfo) {
            totalCount = [pageInfo getIntValueForKey:@"total" defaultValue:0];
            currentPage += 1;
            pageCount = [pageInfo getIntValueForKey:@"pageCount" defaultValue:0];
            if (currentPage < pageCount) {
                hasMore = YES;
            } else {
                hasMore = NO;
            }
        }
    }
}

#pragma mark - SlimeRefresh
- (void)enableSlimeRefresh {
    if (Sys_Version < 6) {
        SRRefreshView * refC = [[SRRefreshView alloc] init];
        refC.delegate = self;
        refC.upInset = 0;
        refC.slimeMissWhenGoingBack = YES;
        refC.slime.bodyColor = RGBCOLOR(165, 165, 165);
        refC.slime.skinColor = RGBCOLOR(195, 195, 195);
        refC.slime.lineWith = 2;
        refC.slime.shadowBlur = 2;
        refC.slime.shadowColor = RGBCOLOR(50, 50, 50);
        refC.backgroundColor = [UIColor clearColor];
        [tableView addSubview:refC];
        refreshControl = refC;
    } else {
        UIRefreshControl * refC = [[UIRefreshControl alloc] init];
        refC.tintColor = RGBCOLOR(165, 165, 165);
        [refC addTarget:self action:@selector(slimeRefreshStartRefresh:) forControlEvents:UIControlEventValueChanged];
        [tableView addSubview:refC];
        [refC endRefreshing];
        refreshControl = refC;
    }
    tableView.clipsToBounds = YES;
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView {
    //to be implemented in sub-classes
    //    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.8];
    isloadByslime = YES;
    needToLoad = NO;
    currentPage = 1;
    tableView.userInteractionEnabled = NO;
    if ([super startRequest]) {
        [self prepareLoadMoreWithPage:currentPage maxID:0];
    }
}

- (void)prepareLoadMoreWithPage:(int)page maxID:(int)mID {
    //to be implemented in sub-classes
}

#pragma filter

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    [filterArr addObjectsFromArray:[contentArr filteredArrayUsingPredicate:resultPredicate]];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    [filterArr removeAllObjects];
    inFilter = (searchString.length > 0);
    if (searchString.length == 0) {
        return YES;
    }
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    return YES;
}

- (void)findButton:(UIView*)subviews {
    for(UIButton *subView in subviews.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn cancelStyle];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.frame = CGRectMake(0, 0, subView.width, subView.height);
            [btn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [subView addSubview:btn];
            break;
        } else {
            [self findButton:subView];
        }
    }
}
//
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)sender {
    //    UISearchBar *sBar = sender.searchBar;
    //    [sBar setShowsCancelButton:YES animated:YES];
    //    if (Sys_Version >= 7) {
    //        for(UIButton *subView in sBar.subviews) {
    //            [self findButton:subView];
    //        }
    //    } else {
    //        for(UIView *subView in sBar.subviews){
    //            if([subView isKindOfClass:UIButton.class]){
    //                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //                [btn cancelStyle];
    //                btn.titleLabel.font = [UIFont systemFontOfSize:12];
    //                btn.frame = CGRectMake(0, 0, subView.width, subView.height);
    //                [btn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    //                [btn setTitle:@"取消" forState:UIControlStateNormal];
    //                [subView addSubview:btn];
    //                break;
    //            }
    //        }
    //    }
}

- (void)cancelSearch {
    [self.searchDisplayController setActive:NO animated:YES];
}

- (BOOL)requestUserByNameDidFinish:(id)sender obj:(NSDictionary *)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSDictionary *dic = [obj getDictionaryForKey:@"data"];
        if (dic.count > 0) {
//            User *user = [User objWithJsonDic:dic];
//            [user insertDB];
//            UserInfoViewController *con = [[UserInfoViewController alloc] initWithUser:user];
//            [self pushViewController:con];
        }
    }
    return YES;
}

- (void)getUserByName:(NSString *)name {
    if (client) {
    }
//    if (needToLoad) {
//        self.loading = YES;
//    }
//    client = [[BSClient alloc] initWithDelegate:self action:@selector(requestUserByNameDidFinish:obj:)];
//    [client getUserByName:name];
}

@end
