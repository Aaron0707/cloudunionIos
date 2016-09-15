//
//  LocationManager.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "LocationManager.h"
#import "BMapKit.h"
#import "GTMBase64.h"

static LocationManager * sharedLocationManager = nil;

@interface LocationManager () <CLLocationManagerDelegate, BMKGeoCodeSearchDelegate> 
@property (nonatomic, strong) BMKGeoCodeSearch        * geoCodesearch;
@end

@implementation LocationManager
@synthesize locationManager, coordinate, located, geocodeGot, locationText, alwaysUpdateLocation;

+ (LocationManager*)sharedManager {
    if (sharedLocationManager == nil) {
        sharedLocationManager = [[LocationManager alloc] init];
    }
    return sharedLocationManager;
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10.0f;
        located = NO;
        _locationCity = forLocationNone;
    }
    return self;
}

- (void)dealloc {
    [locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.locationText = nil;
    Release(_geoCodesearch);
}

#pragma mark - Setters
- (void)setLocationText:(NSString *)text {
    locationText = text;
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:self];
}

#pragma mark - Public
- (void)startUpdatingLocation {
    if ((_locType != forLocationlocating) && [CLLocationManager locationServicesEnabled]) {
        if (_locType == forLocationError) {
            return;
        }
        self.locType = forLocationlocating;
        NSLog(@"启动gps定位");
        [locationManager startUpdatingLocation];
    } else {
        alwaysUpdateLocation = NO;
        if (coordinate.latitude == 0 && coordinate.longitude == 0) {
            // error
        }
    }
}
- (void)stopUpdatingLocation {
    alwaysUpdateLocation = NO;
    [locationManager stopUpdatingLocation];
    _geoCodesearch = nil;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self locationManagerUpdateLocation:newLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    [self locationManagerUpdateLocation:newLocation];
}
- (void)locationManagerUpdateLocation:(CLLocation*)newLocation {
    NSDate * newLocDate = newLocation.timestamp;
    NSTimeInterval interval = [newLocDate timeIntervalSinceNow];
    if (abs(interval) < 5) {
        CLLocationCoordinate2D coord = newLocation.coordinate;
        if (coord.latitude == 0 && coord.longitude == 0) {
            goto out;
        }
        //should get location string
        located = YES;
        [self setLocation:coord.latitude
                      lng:coord.longitude];
        _locType = forLocationSuccess;
        if (alwaysUpdateLocation) {
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:self];
            return;
        }
        out:
        [locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {//error
    //    SetDefaultLocation;
    _locType = forLocationError;
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationErrorNotification object:self];
    
}

#pragma mark - Private
+ (CLLocationCoordinate2D)getBaiduFromGPS:(CLLocationCoordinate2D )locationCoord {
    NSDictionary * baidudict = BMKConvertBaiduCoorFrom(CLLocationCoordinate2DMake(locationCoord.latitude, locationCoord.longitude), BMK_COORDTYPE_GPS);
    NSString * xbase64 =[baidudict objectForKey:@"x"];
    NSString * ybase64 = [baidudict objectForKey:@"y"];
    NSData * xdata = [GTMBase64 decodeString:xbase64];
    NSData * ydata = [GTMBase64 decodeString:ybase64];
    NSString * xstr = [[NSString alloc] initWithData:xdata encoding:NSUTF8StringEncoding];
    NSString * ystr = [[NSString alloc] initWithData:ydata encoding:NSUTF8StringEncoding];
    CLLocationCoordinate2D result;
    result.latitude = [ystr floatValue];
    result.longitude = [xstr floatValue];
    return result;
}

- (void)setLocation:(double)lat lng:(double)lng{
    NSLog(@"定位坐标［%f：%f］", lat, lng);
    self.coordinate = [LocationManager getBaiduFromGPS:CLLocationCoordinate2DMake(lat, lng)];
    [self getLocationString];
}
/**
 地理编码
 */
- (void)getLocationString {
    //发起地理编码
    if (!_geoCodesearch) {
        self.geoCodesearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodesearch.delegate = self;
    }
    BMKReverseGeoCodeOption *co = [[BMKReverseGeoCodeOption alloc] init];
    co.reverseGeoPoint = coordinate;
    [_geoCodesearch reverseGeoCode:co];
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    geocodeGot = YES;
    _geoCodesearch.delegate = nil;
    Release(_geoCodesearch);
    if (error > 0) {
        locationText = @"未知位置";
        NSLog(@"地理定位解码: 未知位置");
    } else {
        locationText = result.address;
        _locationCity = result.addressDetail.city;
        
        NSLog(@"地理定位解码: %@", locationText);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateNotification object:nil];
}

@end
