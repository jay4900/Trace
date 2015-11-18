//
//  LocationMapView.m
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "LocationMapView.h"
#import "ChinaMapShift.h"

@implementation LocationMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        self.mapView.delegate = self;
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.showsBuildings = YES;
        
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.mapView];
        
        self.haveScaled = NO;
        
        self.customPolylinesArr = [NSMutableArray array];
        
        self.lineCoordsArr = [NSMutableArray array];
        
        [self startLocation];
        
    }
    return self;
}

- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 10.0f;
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
                [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
//            NSLog(@"开始定位");
        }else{
            //            [self.locationManager stopUpdatingLocation];
            [self.locationManager startUpdatingLocation];
        }
    }else{
        NSLog(@"位置服务不可用");
    }
}

- (void)addLineToCoord:(CLLocationCoordinate2D)coord isCentered:(BOOL)isCentered
{
    CLLocationCoordinate2D coordForShow = coord;
    Location marCoord = transformFromWGSToGCJ(LocationMake(coord.latitude, coord.longitude));
    coordForShow = CLLocationCoordinate2DMake(marCoord.lat, marCoord.lng);
    
    NSValue *lastCoordValue = nil;
    if (self.lineCoordsArr.count) {
        lastCoordValue = self.lineCoordsArr.lastObject;
    }
    NSValue *coordValue = [NSValue valueWithMKCoordinate:coordForShow];
    [self.lineCoordsArr addObject:coordValue];
    
    //画线
    if (self.lineCoordsArr.count > 1) {
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(2 * sizeof(CLLocationCoordinate2D));
        coords[0] = lastCoordValue.MKCoordinateValue;
        coords[1] = coordValue.MKCoordinateValue;
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:2];
        [self.mapView addOverlay:polyline];
        [self.customPolylinesArr addObject:polyline];
        
        free(coords);
        coords = nil;
    }
    
    if (isCentered) {
        [self.mapView setCenterCoordinate:coordForShow animated:YES];
        
        if (self.haveScaled == NO) {
            self.haveScaled  = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordForShow, 100.0, 100.0);
            [self.mapView setRegion:region animated:NO];
        }
    }
}

- (void)addLinesWithCoordsArr:(NSArray *)coordsArr
{
    int count = (int)coordsArr.count;
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i=0; i<count; i++) {
        NSValue *coordValue = coordsArr[i];
        CLLocationCoordinate2D coordForShow = coordValue.MKCoordinateValue;
        
        Location marCoord = transformFromWGSToGCJ(LocationMake(coordValue.MKCoordinateValue.latitude, coordValue.MKCoordinateValue.longitude));
        coordForShow = CLLocationCoordinate2DMake(marCoord.lat, marCoord.lng);
        
        //将坐标放进Polyline的坐标数组中
        coords[i] = coordForShow;
        [self.lineCoordsArr addObject:coordValue];
    }
    
    //画线
    if (count > 1) {
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:count];
        [self.mapView addOverlay:polyline];
        [self.customPolylinesArr addObject:polyline];
    }
    
    free(coords);
    coords = nil;
}

- (void)clearAllLines
{
    int count = (int)self.customPolylinesArr.count;
    for (int i=0; i<count; i++) {
        MKPolyline *polyline = self.customPolylinesArr[i];
        [self.mapView removeOverlay:polyline];
    }
    [self.customPolylinesArr removeAllObjects];
    [self.lineCoordsArr removeAllObjects];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D coordForShow = location.coordinate;
    Location marsCoord = transformFromWGSToGCJ(LocationMake(location.coordinate.latitude, location.coordinate.longitude));
    coordForShow = CLLocationCoordinate2DMake(marsCoord.lat, marsCoord.lng);
    
    if (self.mapView) {
        [self.mapView setShowsUserLocation:YES];
        
        BOOL haveScaled = self.haveScaled;
        if (haveScaled == NO) {
            self.haveScaled = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordForShow, 100.0, 100.0);
            [self.mapView setRegion:region animated:NO];
        }else{
            [self.mapView setCenterCoordinate:coordForShow animated:NO];
        }
    }
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = overlay;
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        polylineRenderer.strokeColor = LINECOLOR;
        polylineRenderer.lineWidth = 4;
        return polylineRenderer;
    }else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygon *polygon = overlay;
        MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
        polygonRenderer.strokeColor = LINECOLOR;
        polygonRenderer.lineWidth = 4;
        return polygonRenderer;
    }else if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircle *circle = overlay;
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:circle];
        circleRender.lineDashPattern = @[@4];
        circleRender.strokeColor = LINECOLOR;
        circleRender.lineWidth = 2;
        return circleRender;
    }
    
    return nil;
}

@end
