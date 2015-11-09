//
//  MainTabBarController.m
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "MainTabBarController.h"
#import "ToolsViewController.h"
#import "MapViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
}

- (void)initViewNodes
{
    ToolsViewController *toolsView = [[ToolsViewController alloc] init];
    MapViewController *mapView = [[MapViewController alloc] init];
    HistoryViewController *historyView = [[HistoryViewController alloc] init];
    SettingViewController *settingView = [[SettingViewController alloc] init];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:toolsView];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:mapView];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:historyView];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:settingView];
    
    nav1.navigationBar.barStyle = UIBarStyleBlack;
    nav2.navigationBar.barStyle = UIBarStyleBlack;
    nav3.navigationBar.barStyle = UIBarStyleBlack;
    nav4.navigationBar.barStyle = UIBarStyleBlack;
    
    nav1.title = @"Tools";
    nav2.title = @"Map";
    nav3.title = @"History";
    nav4.title = @"Setting";
    
    self.viewControllers = @[nav1,
                             nav2,
                             nav3,
                             nav4];
    
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.tintColor = [UIColor redColor];
}

@end
