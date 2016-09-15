//
//  BaseTableView.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSTableViewDataSource <NSObject>
@optional
- (BOOL)tableView:(UITableView *)sender canDeleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)sender commitDeletingAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BaseTableView : UITableView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat   tableViewCellHeight;
@property (nonatomic, assign) id <BSTableViewDataSource> baseDataSource;

@end
