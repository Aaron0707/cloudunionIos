//
//  SessionNewController.m
//  CarPool
//
//  Created by Kiwaro on 14-5-18.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
#import "ImageProgressQueue.h"
#import "ImageCaches.h"

typedef enum {
    forBaseListRequestDataList,
    forBaseListRequestOther,
}BaseListRequestType;

@interface SearchDisplayController : UISearchDisplayController

@end

@interface BaseTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet BaseTableView      * tableView;
    
    NSMutableArray              * contentArr;
    NSMutableArray              * filterArr;
    
    UINib                       * fileNib;
    UINib                       * fileNibFilter;
    int                         count;
    BOOL                        hasMore;
    int                         page_count;
    BOOL                        isNeedMore;
    
    ImageCaches                 * baseImageCaches;
    ImageProgressQueue          * baseImageQueue;
    NSOperationQueue            * baseOperationQueue;
    BaseListRequestType         baseRequestType;
    
    CGFloat                     headImageViewSize;
    BOOL                        inFilter;       // 是否处于过滤模式
}

@property (nonatomic, assign) int       tag;
@property (nonatomic, assign) CGFloat   tableViewCellHeight;
@property (nonatomic, assign) NSArray   * dataArray; // 得到当前正确的数据源
@property (nonatomic, assign) BaseTableView   * currectTableView; // 得到当前正确的数据源
@property (nonatomic, strong) SearchDisplayController * mySearchDisplayController;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

- (void)enableSlimeRefresh;
- (void)slimeRefreshStartRefresh:(id)refreshView;
- (void)startLoadingWithProgress:(ImageProgress*)progress;

- (void)loadImageWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadHeadImageWithIndexPath:(NSIndexPath *)indexPath;
- (void)setHeadImage:(UIImage*)image forIndex:(NSIndexPath*)indexPath;

- (void)refreshDataList;
- (void)refreshDataListIfNeed;
- (void)cancelRequestIfNeed;
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)sender;
- (void)getUserByName:(NSString *)name;
- (void)needRadius:(NSIndexPath*)indexPath cell:(id)cell;

- (NSString*)baseTableView:(UITableView *)sender imageURLAtIndexPath:(NSIndexPath*)indexPath;
- (CGFloat)baseTableView:(UITableView *)sender imageSizeAtIndexPath:(NSIndexPath*)indexPath;
- (void)baseTableView:(int)tag imageUpdateAtIndexPath:(NSIndexPath*)indexPath image:(UIImage *)image;

@end
