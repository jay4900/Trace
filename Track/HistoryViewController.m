//
//  HistoryViewController.m
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
}

- (void)initViewNodes
{
    self.title = @"History";
    self.dataArr = [COREDATA fetchTrackList];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBtnItemPressed)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64.0 - 44.0)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)refreshBtnItemPressed
{
    self.dataArr = [COREDATA fetchTrackList];
    [self.tableView reloadData];
}

- (void)showTrackToMapView:(CDTrackList *)track
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ShowTrackToMap object:track];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    CDTrackList *track = self.dataArr[indexPath.row];
    cell.textLabel.text = track.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"coords:%ld distance:%.2fkm", (unsigned long)[COREDATA getCountsOfTrack:track], track.distance/1000.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDTrackList *track = self.dataArr[indexPath.row];
    self.tabBarController.selectedIndex = 1;
    [self performSelector:@selector(showTrackToMapView:) withObject:track afterDelay:0.5];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDTrackList *track = self.dataArr[indexPath.row];
        [self.dataArr removeObject:track];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [COREDATA deleteTrack:track];
    }
}

@end
