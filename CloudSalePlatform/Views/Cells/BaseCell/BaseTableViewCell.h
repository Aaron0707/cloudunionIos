//
//  BaseTableViewCell.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^layoutCellView)(NSString*name);
@protocol BaseHeadCellDelegate <NSObject>
- (void)tableView:(id)sender didTapHeaderAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString      * className;
@property (nonatomic, copy)   UITableView   * superTableView;
@property (nonatomic, strong) NSIndexPath   * indexPath;
@property (nonatomic, assign) NSInteger     cornerRadius;
@property (nonatomic, copy)   layoutCellView layoutBlock;
@property (nonatomic, assign) BOOL          bottomLine;
@property (nonatomic, assign) BOOL          topLine;
@property (nonatomic, strong) CALayer       * arrowlayer;
@property (nonatomic, strong) UIImageView   * bottomLineView;
@property (nonatomic, strong) UIImageView   * topLineView;

- (void)addArrowRight;
- (void)removeArrowRight;
- (void)initialiseCell;
- (void)update:(layoutCellView)block;
- (void)setHeadImage:(UIImage*)image;

@end
