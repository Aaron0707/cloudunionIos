//
//  LocationManager.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#define LocationUpdateNotification @"LocationUpdateNotification"
#define LocationErrorNotification @"LocationErrorNotification"
#define LocationChangeNotification @"LocationChangeNotification"

#define CoordinateNotification @"CoordinateUpdateNotification"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef enum {
    forLocationNone = 0,
    forLocationError,
    forLocationlocating,
    forLocationSuccess,
    forLocationFinished,
} LocationType;

@interface LocationManager : NSObject

@property (nonatomic, assign) LocationType locType;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL located;
@property (nonatomic, assign) BOOL geocodeGot;
@property (nonatomic, strong) NSString * locationText;
@property (nonatomic, strong) NSString * locationCity;
@property (nonatomic, assign) BOOL alwaysUpdateLocation;

+ (LocationManager*)sharedManager;
+ (CLLocationCoordinate2D)getBaiduFromGPS:(CLLocationCoordinate2D )locationCoord;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
