//
//  MapViewController.h
//  CarPool
//
//  Created by kiwaro on 14-1-29.
//  Copyright (c) 2014年 NigasMone. All rights reserved.
//

#import "BaseViewController.h"
#import "BMapKit.h"
#import "Declare.h"

@interface MapViewController : BaseViewController <BMKMapViewDelegate, BMKPoiSearchDelegate> {
    
}

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString * locString;
@property (nonatomic, strong) NSString * shopName;

@end
