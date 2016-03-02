//
//  ProfileViewCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ProfileViewCtrl.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ProfileViewCtrl () <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *_locationManager;
}

@end

@implementation ProfileViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    //定位功能
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位已开");
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //返回的是枚举类型的值。表示定位授权状态。
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 30.0f;
    
    [_locationManager startUpdatingLocation];
    //地图视图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(30, 115);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    
    [mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
    
    [self.view addSubview:mapView];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@", locations[0]);
    
    [manager stopUpdatingLocation];
}

#pragma mark - map delegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
