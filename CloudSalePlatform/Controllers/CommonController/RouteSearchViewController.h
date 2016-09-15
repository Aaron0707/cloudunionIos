//
//  RouteSearchViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BaseViewController.h"

@interface RouteSearchViewController : BaseViewController<BMKMapViewDelegate, BMKRouteSearchDelegate> {
	IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
    IBOutlet UIButton * busButton;
    IBOutlet UIButton * walkButton;
    IBOutlet UIButton * carButton;
}
@property (nonatomic, strong) NSString  * startCityText;
@property (nonatomic, strong) NSString  * startAddrText;
@property (nonatomic, strong) NSString  * endCityText;
@property (nonatomic, assign) CLLocationCoordinate2D endpt;

@end
