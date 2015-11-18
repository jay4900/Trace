//
//  NewTrackViewController.m
//  Track
//
//  Created by Wuffy on 11/18/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "NewTrackViewController.h"

@interface NewTrackViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation NewTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
}

- (void)initViewNodes
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"New Track";
    
    self.dataArr = @[@"Walk", @"Run", @"Hike", @"Cycle", @"Drive", @"Other"];
    
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, CGRectGetWidth(frame), CGRectGetHeight(frame)- 64.0 - 44.0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [tableView estimatedSectionHeaderHeight];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return [tableView estimatedSectionFooterHeight];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Track Name";
    }else{
        title = @"Track Type";
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"New Trace";
    }else{
        NSInteger rowIndex = indexPath.row;
        cell.textLabel.text = self.dataArr[rowIndex];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
