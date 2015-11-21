//
//  ToolsViewController.m
//  track
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "ToolsViewController.h"
#import "ToolCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "EditTrackViewController.h"
#import "MyAlertView.h"

@interface ToolsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UITextView *logTextView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIBarButtonItem *addItem;
@property (strong, nonatomic) UIBarButtonItem *editItem;
@property (strong, nonatomic) UIButton *startBtn;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) NSString *traceFileName;

@property (strong, nonatomic) CDTrackList *track;
@property BOOL isReadyToTrace;

@end

@implementation ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
    [self startLocation];
}

- (void)testMyAlertView
{
    MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:@"title"
                                                        message:@"message"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK1", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alertView.handler = ^(NSInteger index) {
        NSLog(@"index:%d", (int)index);
    };

    [alertView show];
}

- (void)initViewNodes
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"Tools";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnItemPressed)];
    self.navigationItem.leftBarButtonItem = self.addItem;
    
    self.editItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(editBtnItemPressed)];
    self.navigationItem.rightBarButtonItem = self.editItem;
    self.editItem.enabled = NO;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    CGFloat cell_width = CGRectGetWidth(frame)*0.5;
    CGFloat cell_height = 70.0;
    
    CGRect frame_collectionView = CGRectMake(0, 64.0, CGRectGetWidth(frame), cell_height * 4);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(cell_width, cell_height);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame_collectionView
                                             collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ToolCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    CGFloat btn_width = CGRectGetWidth(frame) - 40.0;
    CGFloat btn_height = 40.0;
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake(20.0, CGRectGetHeight(frame) - 44 - (10+btn_height)*2, btn_width, btn_height);
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startBtn setBackgroundColor:[UIColor greenColor]];
    [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    self.startBtn.clipsToBounds = YES;
    self.startBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.startBtn.layer.borderWidth = 1.6;
    self.startBtn.layer.cornerRadius = 10.0;
    [self.startBtn addTarget:self action:@selector(startBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startBtn];
    self.startBtn.hidden = YES;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneBtn.frame = CGRectMake(20.0, CGRectGetHeight(frame) - 44 - (10+btn_height), btn_width, btn_height);
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setBackgroundColor:[UIColor blueColor]];
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    self.doneBtn.clipsToBounds = YES;
    self.doneBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.doneBtn.layer.borderWidth = 1.6;
    self.doneBtn.layer.cornerRadius = 10.0;
    [self.doneBtn addTarget:self action:@selector(doneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneBtn];
    self.doneBtn.hidden = YES;
    
    
//    self.logTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(frame_collectionView) + 10, CGRectGetWidth(frame) - 20, 80)];
//    [self.view addSubview:self.logTextView];
//    [self pushStringToTextView:@"hello"];
    
    self.dataArr = @[@{@"title":@"Distance",        @"unit":@"km",      @"key":@"distance"},
                     @{@"title":@"Duration",        @"unit":@"minute",  @"key":@"duration"},
                     @{@"title":@"Elevation",       @"unit":@"m",       @"key":@"elevation"},
                     @{@"title":@"Speed",           @"unit":@"km/h",    @"key":@"speed"},
                     @{@"title":@"HorizontalAccuracy",          @"unit":@"m",      @"key":@"ascent"},
                     @{@"title":@"VerticalAccuracy",         @"unit":@"m",      @"key":@"descent"},
                     @{@"title":@"Latitude",        @"unit":@"",        @"key":@"latitude"},
                     @{@"title":@"Longitude",       @"unit":@"",        @"key":@"longitude"}];
    GLOBAL.isTracing = NO;
}

- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.activityType = CLActivityTypeOther;
            self.locationManager.distanceFilter = 10.0f;
            [self.locationManager startUpdatingLocation];
            
            self.locationManager.headingFilter = 90;
            [self.locationManager startUpdatingHeading];
            NSLog(@"开始定位");
        }else{
//            [self.locationManager stopUpdatingLocation];
            [self.locationManager startUpdatingLocation];
        }
    }else{
        NSLog(@"位置服务不可用");
    }
}

- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - 按钮方法
- (void)addBtnItemPressed
{
    if (self.isReadyToTrace == NO) {
        [self showEditTrackView:YES];
    }else{
        MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:nil
                                                            message:@"You are recording a track. Are you sure to create a new track?"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok", nil];
        alertView.handler = ^(NSInteger index) {
            if (index == 1) {
                [self showEditTrackView:YES];
            }
        };
        [alertView show];
        
    }
}

- (void)editBtnItemPressed
{
    [self showEditTrackView:NO];
}

- (void)startBtnPressed
{
    BOOL isTracing = GLOBAL.isTracing;
    if (isTracing == NO) {
        GLOBAL.isTracing = YES;
        [self.startBtn setBackgroundColor:[UIColor redColor]];
        [self.startBtn setTitle:@"Pause" forState:UIControlStateNormal];
        
        CDPath *path = (CDPath *)[COREDATA addEntityWithName:Entity_Path];
        [GLOBAL.currentTrack addPathsObject:path];
        [self startLocation];
    }else{
        GLOBAL.isTracing = NO;
        [self.startBtn setBackgroundColor:[UIColor greenColor]];
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)doneBtnPressed
{
    
}

- (void)saveLocationsData
{
    [COREDATA saveContext];
    self.track = nil;
    [self.locationManager startUpdatingHeading];
    
    self.editItem.enabled = NO;
    
    GLOBAL.isTracing = NO;
}

#pragma mark - 其他方法
- (void)showEditTrackView:(BOOL)isAddNewTrack
{
    EditTrackViewController *editTrackView = [[EditTrackViewController alloc] init];
    editTrackView.isAddNewTrack = isAddNewTrack;
    __weak ToolsViewController *this = self;
    editTrackView.finishedEditHandler = ^() {
        this.navigationItem.title = GLOBAL.currentTrack.name;
        this.editItem.enabled = YES;
        this.startBtn.hidden = NO;
        this.isReadyToTrace = YES;
        [self updateLocationManager];
    };
    
    [self.navigationController pushViewController:editTrackView animated:YES];
}

- (void)updateLocationManager
{
    //不同的TrackType对应不同的设置
    switch (GLOBAL.currentTrack.trackType) {
        case kTrackType_Drive:
        {
            self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
            self.locationManager.distanceFilter = 20.0;
        }
            break;
        case kTrackType_Walk:
        case kTrackType_Run:
        case kTrackType_Cycle:
        {
            self.locationManager.activityType = CLActivityTypeFitness;
            self.locationManager.distanceFilter = 10.0;
        }
            break;
            
        default:
        {
            self.locationManager.activityType = CLActivityTypeOther;
            self.locationManager.distanceFilter = 10.0;
        }
            break;
    }
}

- (void)updateCollectionViewWithLocation:(CLLocation *)location
{
    if (GLOBAL.traceInfo == nil) GLOBAL.traceInfo = [[TraceInfo alloc] init];
    GLOBAL.traceInfo.latitude = location.coordinate.latitude;
    GLOBAL.traceInfo.longitude = location.coordinate.longitude;
    GLOBAL.traceInfo.elevation = location.altitude;
    GLOBAL.traceInfo.ascent = location.horizontalAccuracy;
    GLOBAL.traceInfo.descent = location.verticalAccuracy;
    if (location.speed >= 0) GLOBAL.traceInfo.speed = location.speed * 3.6;
    else GLOBAL.traceInfo.speed = 0.0;
    
    [self.collectionView reloadData];
}
- (void)pushStringToTextView:(NSString *)str
{
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", self.logTextView.text, str];
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dataDict = self.dataArr[indexPath.row];
    NSString *title = dataDict[@"title"];
    NSString *unit = dataDict[@"unit"];
    NSString *key = dataDict[@"key"];
    cell.titleLabel.text = title;
    cell.unitLabel.text = unit;
    
    if (GLOBAL.traceInfo) {
        CGFloat resultNum = [[GLOBAL.traceInfo valueForKeyPath:key] doubleValue];
        if ([@"latitude" isEqualToString:key] || [@"longitude" isEqualToString:key]) {
            cell.resultLabel.text = [NSString stringWithFormat:@"%.6f", resultNum];
        }else{
            cell.resultLabel.text = [NSString stringWithFormat:@"%.2f", resultNum];
        }
        
    }else{
        cell.resultLabel.text = @"0.00";
    }
    
    return cell;
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
    NSLog(@"location:%f, %f, %f, %f", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, location.verticalAccuracy);
    
    if (GLOBAL.isTracing) {
        CDCoordinate *coord = (CDCoordinate *)[COREDATA addEntityWithName:Entity_Coord];
        coord.latitude = location.coordinate.latitude;
        coord.longitude = location.coordinate.longitude;
        coord.altitude = location.altitude;
        coord.timestamp = [location.timestamp timeIntervalSince1970];
        [COREDATA insertCoordinate:coord intoTrack:GLOBAL.currentTrack];
    }else{
        [manager stopUpdatingLocation];
    }
    
    [self updateCollectionViewWithLocation:location];
    
    if (GLOBAL.isTracing) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_addLineToMap object:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (GLOBAL.isTracing == NO) {
        CLLocation *location = manager.location;
        NSLog(@"location:%f, %f, %f, %f", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, location.verticalAccuracy);
        
        [self updateCollectionViewWithLocation:location];
    }
}

@end
