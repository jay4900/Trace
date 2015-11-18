//
//  TraceFileListView.h
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraceFileListView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SingleObjectHandler fileNameHandler;       //回传文件名

@end
