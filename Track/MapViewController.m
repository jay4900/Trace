//
//  MapViewController.m
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "MapViewController.h"
#import "LocationMapView.h"
#import "DXPopover.h"
#import "TraceFileListView.h"

@interface MapViewController ()
@property (strong, nonatomic) UIBarButtonItem *listItem;
@property (strong, nonatomic) LocationMapView *mapView;
@property (strong, nonatomic) NSArray *coordsArr;
@property NSInteger currentPlayIndex;

@property BOOL isViewShowing;

@property (strong, nonatomic) NSTimer *tracePlayTimer;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isViewShowing = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.isViewShowing = NO;
}

- (void)initViewNodes
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Map";
    
    UIBarButtonItem *allItem = [[UIBarButtonItem alloc] initWithTitle:@"All"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(allBtnPressed)];
    self.navigationItem.leftBarButtonItem = allItem;
    
    self.listItem = [[UIBarButtonItem alloc] initWithTitle:@"List"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(listBtnPressed)];
    self.navigationItem.rightBarButtonItem = self.listItem;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect frame_map = CGRectMake(0, 64, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 44);
    self.mapView = [[LocationMapView alloc] initWithFrame:frame_map];
    [self.view addSubview:self.mapView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyAddLineToMap:)
                                                 name:NOTIFY_addLineToMap
                                               object:nil];
}

#pragma mark - 按钮方法
- (void)allBtnPressed
{
    if ([self.tracePlayTimer isValid]) {
        [self.tracePlayTimer invalidate];
    }
    
    if (self.coordsArr.count) {
        [self.mapView clearAllLines];
        [self.mapView addLinesWithCoordsArr:self.coordsArr];
    }
}

- (void)listBtnPressed
{
    TraceFileListView *listView = [[TraceFileListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) * 0.8, 220)];
    
    DXPopover *popover = [DXPopover popover];
    [popover showAtPoint:CGPointMake(CGRectGetWidth(self.view.frame) - 20, 64.0) popoverPostion:DXPopoverPositionDown withContentView:listView inView:self.navigationController.view];
    
    listView.fileNameHandler = ^(NSString *fileName) {
//        CDTraceList *trace = [COREDATA fetchTraceWithName:fileName];
//        GLOBAL.currentTrace = trace;
//        [self playTrace];
        [popover dismiss];
    };
}

#pragma makr - 其他方法
- (void)notifyAddLineToMap:(NSNotification *)notify
{
    CLLocation *location = notify.object;
    BOOL isCentered = self.isViewShowing;
    [self.mapView addLineToCoord:location.coordinate isCentered:isCentered];
}

- (void)playTrace
{
    if ([self.tracePlayTimer isValid]) {
        [self.tracePlayTimer invalidate];
    }
    
    if (self.coordsArr.count) {
        self.currentPlayIndex = 0;
        [self.mapView clearAllLines];
        self.tracePlayTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                               target:self
                                                             selector:@selector(drawLineToMap)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)drawLineToMap
{
    NSValue *coordValue = self.coordsArr[self.currentPlayIndex];
    [self.mapView addLineToCoord:coordValue.MKCoordinateValue isCentered:YES];
    
//    if (self.currentPlayIndex > 0) {
//        NSValue *lastCoordValue = self.coordsArr[self.currentPlayIndex-1];
//        CLLocationCoordinate2D lastCoord = [lastCoordValue MKCoordinateValue];
//        CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:lastCoord.latitude longitude:lastCoord.longitude];
//        
//        CLLocationCoordinate2D currentCoord = [coordValue MKCoordinateValue];
//        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentCoord.latitude longitude:currentCoord.longitude];
//        CGFloat distance = [currentLocation distanceFromLocation:lastLocation];
//        NSLog(@"distance:%.2f", distance);
//    }
    
    if (++self.currentPlayIndex == self.coordsArr.count) {
        [self.tracePlayTimer invalidate];
    }
}

@end
