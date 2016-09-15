//
//  BusinessShop.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-21.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "BusinessShop.h"
#import "Globals.h"
#import "BSEngine.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@implementation BusinessShop

- (void)updateWithJsonDic:(NSDictionary *)dic {
    [super updateWithJsonDic:dic];
    CLLocationCoordinate2D mylocation = [[LocationManager sharedManager] coordinate];
    [self getDistance:mylocation.latitude lng:mylocation.longitude];
}

- (void)getDistance:(double)lat lng:(double)lng {
    double dis = [Globals distanceBetweenOrderBy:lat lat2:self.latitude.doubleValue lng1:lng lng2:self.longitude.doubleValue];
    if (dis > 1000000) {
        self.distance = [NSString stringWithFormat:@">1000km"];
    } else if (dis > 1000) {
        dis = dis/1000;
        self.distance = [NSString stringWithFormat:@"%.2fkm", dis];
    } else {
        self.distance = [NSString stringWithFormat:@"%.2fm", dis];
    }
}
-(NSString *)orgName{
    if (_orgName.hasValue) {
        return _orgName;
    }
        return _name;
    
}

-(NSString *)categoryName{
    if (_categoryName.hasValue) {
        return _categoryName;
    }
        return _businessCategoryName;
}

@end
