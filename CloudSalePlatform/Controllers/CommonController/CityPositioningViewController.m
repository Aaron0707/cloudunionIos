//
//  CityPositioningViewController.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-22.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "CityPositioningViewController.h"
#import "Globals.h"
#import "BaseTableViewCell.h"
#import "LocationManager.h"
#import "KAlertView.h"

@interface CityPositioningViewController () {
    CLLocationCoordinate2D  myLocation;
    BOOL                    located;
    NSString                * myCity;
    NSString                * myCode;
}

@end

@implementation CityPositioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"城市选择";
    myCity = @"定位中";
    myCode = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCode"];
    [self setEdgesNone];
    [self.searchBar setSearchBarBackgroundColor:RGBCOLOR(202, 199, 205)];
    [self.view addSubview:self.searchBar];
    self.searchBar.placeholder = @"搜索城市";
    self.searchBar.top += 64;
    tableView.top += 44;
    tableView.height -= 44;
    [self.mySearchDisplayController.searchBar setNeedsDisplay];
    
    [self setLeftBarButtonImage:LOADIMAGECACHES(@"back_bakc") selector:@selector(signOut)];
    NSFileManager * fm = [NSFileManager defaultManager];

    if (![fm fileExistsAtPath:areapath]) {
        [super startRequest];;
        [client findCityIfNeedKey:nil];
    } else {
        NSMutableArray * array = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:areapath]];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:myCity?myCity:@"定位中" forKey:@"name"];
        [dic setObject:myCode?myCode:@"0" forKey:@"code"];
        [array insertObject:@[dic] atIndex:0];
        [contentArr addObjectsFromArray:array];
        [tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateNotification:) name:LocationUpdateNotification object:nil];
    [[LocationManager sharedManager] startUpdatingLocation];
}

- (void)signOut {
    myCity = [[[BSEngine currentEngine] user] readConfigWithKey:@"myCity"];
    if (!myCity) {
//        [KAlertView showType:KAlertTypeError text:@"请选择你的城市哦" for:0.8 animated:YES];
//        return;
//        [self dismissViewControllerAnimated:YES completion:^{
        
            [self.tabBarController setSelectedIndex:0];
//        }];
         [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangeNotification object:self];
//        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)requestDidFinish:(BSClient*)sender obj:(NSDictionary*)obj {
    if ([super requestDidFinish:sender obj:obj]) {
        NSArray * list = [obj getArrayForKey:@"list"];
        NSMutableArray * array = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            NSString * name = [obj getStringValueForKey:@"name" defaultValue:@""];
            NSString * spell = [obj getStringValueForKey:@"spell" defaultValue:@""];
            if ([name isEqualToString:@"县"]) {
                name = [obj getStringValueForKey:@"provinceName" defaultValue:@""];
            }
            spell = [spell substringToIndex:1];
            NSString * code = [obj getStringValueForKey:@"code" defaultValue:@""];
            [dic setObject:name forKey:@"name"];
            [dic setObject:spell forKey:@"spell"];
            [dic setObject:code forKey:@"code"];
            [array addObject:dic];
        }];
        
        array = [Globals sortdata:array];
        [array writeToFile:areapath atomically:YES];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:myCity?myCity:@"定位中" forKey:@"name"];
        [dic setObject:myCode?myCode:@"0" forKey:@"code"];
        [array insertObject:@[dic] atIndex:0];
        [contentArr addObjectsFromArray:array];
        [tableView reloadData];

    }
    
    return YES;
}

#pragma mark - LocationManagerNSNotification
- (void)locationUpdateNotification:(NSNotification*)sender {
    myCity = @"定位中";
    self.loading = NO;
    NSString * str = [[LocationManager sharedManager] locationCity];
    [contentArr enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL *stop) {
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString * name = [obj objectForKey:@"name"];
            if ([name isEqualToString: str]) {
                myCode = [obj objectForKey:@"code"];
                myCity = name;
                *stop = YES;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
       
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
    if (sender != tableView) {
        return 1;
    }
    return contentArr.count;
}

- (CGFloat)tableView:(UITableView *)sender heightForHeaderInSection:(NSInteger)section {
    if (sender == tableView && [[contentArr objectAtIndex:section] count] > 0) {
        return 22;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)sender viewForHeaderInSection:(NSInteger)section {
    if (sender != tableView) {
        return nil;
    }
    if ([[contentArr objectAtIndex:section] count] > 0) {
        UIImageView *bkImageView = [[UIImageView alloc] init];
        bkImageView.backgroundColor = RGBCOLOR(247, 247, 247);
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 2, 28, 14)];
        tLabel.textColor=[UIColor blackColor];
        tLabel.backgroundColor = [UIColor clearColor];
        
        tLabel.font = [UIFont boldSystemFontOfSize:14];
        NSString * title = nil;
        if (section == 0) {
            title = @"定位";
        } else {
            title = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section-1];
        }
        tLabel.text = title;
        [bkImageView addSubview:tLabel];
        return bkImageView;
        
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (tableView == sender) {
        rows = [[contentArr objectAtIndex:section] count];
    } else {
        rows = filterArr.count;
    }
    return rows;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    return arr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section {
    if (contentArr.count > 0 && sender == tableView) {
        if (section == 0) {
            return @"定位";
        }
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    } else {
        return nil;
    }
}

- (UITableViewCell*)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"BaseTableViewCell";
    BaseTableViewCell* cell = [sender dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.imageView.hidden = YES;
    } else if (sender != tableView && !cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.imageView.hidden = YES;
    }
    
    cell.detailTextLabel.text = @"";
    NSDictionary * city = nil;
    if (sender == tableView) {
        city = [[contentArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        city = [filterArr objectAtIndex:indexPath.row];
    }
    if (sender == tableView && indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = @"定位";
        cell.textLabel.text = myCity;
    } else {
        cell.textLabel.text = [city getNameValue];
    }
    cell.topLineView.hidden = (indexPath.row == 0);
    [cell update:^(NSString *name) {
        cell.topLineView.left = 20;
        cell.textLabel.left = 34;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.width = 30;
        cell.detailTextLabel.origin = CGPointMake(cell.width - 60, cell.textLabel.top);
        cell.topLineView.frame = CGRectMake(10, 0, cell.width - 20, 0.5);
        cell.bottomLineView.frame = CGRectMake(10, cell.height - 0.5, cell.width - 20, 0.5);
    }];
    return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [sender deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * city = nil;
    if (tableView == sender) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            if ([myCity isEqualToString:@"定位中"]||[myCity isEqualToString:@"无法获取您的位置"] || [myCity isEqualToString:@""]) {
                return;
            }
        }else{
            city = [[contentArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            myCity = [city getNameValue];
            myCode = [city getCodeValue];
        }//1865295 4802
    } else {
        city = [filterArr objectAtIndex:indexPath.row];
        myCity = [city getNameValue];
        myCode = [city getCodeValue];
    }
    
    [[[BSEngine currentEngine] user] saveConfigWhithKey:@"myCity" value:myCity];
    [[[BSEngine currentEngine] user] saveConfigWhithKey:@"myCode" value:myCode];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:LocationChangeNotification object:self];
    [self dismissModalController:YES];
    
}


#pragma mark - Filter
- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {
    [contentArr enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        [arr enumerateObjectsUsingBlock:^(NSDictionary * city, NSUInteger idx, BOOL *stop) {
            if ([city.getNameValue rangeOfString:searchText].location <= city.getNameValue.length) {
                [filterArr addObject:city];
            }
        }];
    }];
    
}

@end
