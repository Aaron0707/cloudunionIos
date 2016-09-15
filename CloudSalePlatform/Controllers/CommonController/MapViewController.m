
//  MapViewController.m
//  CarPool
//
//  Created by kiwaro on 14-1-26.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "MapViewController.h"
#import "BaseTableViewCell.h"
#import "UIImage+FlatUI.h"
#import "LocationManager.h"
#import "RouteSearchViewController.h"

@interface MapViewController ()<BMKLocationServiceDelegate> {
    BMKMapView              * _mapView;
    BMKAnnotationView       * newAnnotation;
    UIView * bkgview0;

}
@property (nonatomic, strong) BMKPointAnnotation * annotation;
@property (nonatomic, strong) NSString                  * city;

@end

@implementation MapViewController
@synthesize annotation;
@synthesize location;

- (void)dealloc {
    self.city = nil;
    self.annotation = nil;
    Release(_mapView);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setEdgesNone];
    
    self.annotation = [[BMKPointAnnotation alloc] init];
    self.navigationItem.title = @"地址详情";
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [self.view insertSubview:_mapView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    BMKCoordinateRegion region;
    region.center = location;
    region.span = BMKCoordinateSpanMake(0.007, 0.007);
    [_mapView setRegion:region animated:YES];
    
    annotation.title = _locString;
    annotation.coordinate = location;
    [_mapView addAnnotation:annotation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppear) {
        bkgview0 = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height, self.view.width, 0)];
        bkgview0.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bkgview0];
        
        CGFloat height = 15; // 上边距;
        UIFont * font = [UIFont systemFontOfSize:13];
        CGSize size = [_shopName sizeWithFont:font maxWidth:self.view.width - 20 maxNumberLines:0];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, height, size.width, size.height)];
        height += size.height;
        lab.font = font;
        lab.text = _shopName;
        lab.textColor = [UIColor blackColor];
        [bkgview0 addSubview:lab];
        height += 8;
        
        font = [UIFont systemFontOfSize:12];
        size = [_locString sizeWithFont:font maxWidth:self.view.width - 20 maxNumberLines:0];
        lab = [[UILabel alloc] initWithFrame:CGRectMake(10, height, size.width, size.height)];
        lab.font = font;
        height += size.height;
        lab.text = _locString;
        lab.textColor = [UIColor lightGrayColor];
        [bkgview0 addSubview:lab];
        height += 12;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = RGBCOLOR(247, 247, 247);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(237, 237, 237) cornerRadius:0] forState:UIControlStateHighlighted];
        [btn setTitle:@"导航到该商家" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:RGBCOLOR(91, 91, 91) forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, height, self.view.width - 20, 34);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = RGBCOLOR(227, 227, 227).CGColor;
        [bkgview0 addSubview:btn];
        height += 50;
        bkgview0.height = height;
        [UIView animateWithDuration:0.25 animations:^{
            bkgview0.top = self.view.height - height;
        }];
    }
}

- (void)click {
    RouteSearchViewController * con = [[RouteSearchViewController alloc] init];
    con.endpt = location;
    [self pushViewController:con];
}

/**
 *点中底图标注后会回调此接口
 *@param mapview 地图View
 *@param mapPoi 标注点信息
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
    DLog(@"%@",mapPoi.text);
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"paopaoclick");
}

// 根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
		return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
		return polylineView;
    }
	
	if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =2.0;
		return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
		return groundView;
    }
	return nil;
}

@end
