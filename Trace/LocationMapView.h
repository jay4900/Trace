//
//  LocationMapView.h
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationMapView : UIView <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property BOOL haveScaled;      //标记地图是否经过缩放
@property (strong, nonatomic) NSMutableArray *customPolylinesArr;

@property (strong, nonatomic) NSMutableArray *lineCoordsArr;

- (void)addLineToCoord:(CLLocationCoordinate2D)coord isCentered:(BOOL)isCentered;
- (void)addLinesWithCoordsArr:(NSArray *)coordsArr;
- (void)clearAllLines;
@end
