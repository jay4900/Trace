//
//  EditTrackViewController.m
//  Track
//
//  Created by Wuffy on 11/18/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "EditTrackViewController.h"

@interface EditTrackViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) UIBarButtonItem *doneItem;
@end

@implementation EditTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewNodes];
}

- (void)initViewNodes
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.isAddNewTrack) {
        self.trackType = kTrackType_Walk;
        self.title = @"New Track";
    }else{
        self.trackType = GLOBAL.currentTrack.trackType;
        self.title = @"Edit Track";
    }
    
    self.doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                  target:self
                                                                  action:@selector(doneBtnItemPressed)];
    self.navigationItem.rightBarButtonItem = self.doneItem;
    
    self.dataArr = @[@"Walk", @"Run", @"Hike", @"Cycle", @"Drive", @"Other"];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:self.trackType inSection:1];
    
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0, CGRectGetWidth(frame), CGRectGetHeight(frame)- 64.0 - 44.0) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

- (void)doneBtnItemPressed
{
    if ([GLOBAL checkTrackNameIsValid:self.nameTextField.text] == NO) {
        MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:nil
                                                            message:@"Name can't contains special characters, and length should be less than 20."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if (self.isAddNewTrack) {
            //如果已经新建了一个轨迹，但是没有记录任何坐标点则直接删除
            if (GLOBAL.currentTrack && GLOBAL.currentTrack.paths.count == 0) {
                [COREDATA deleteTrack:GLOBAL.currentTrack];
                GLOBAL.currentTrack = nil;
            }
            
            GLOBAL.currentTrack = [COREDATA addNewTrack];
        }
        GLOBAL.currentTrack.name = self.nameTextField.text;
        GLOBAL.currentTrack.trackType = self.trackType;
        
        if (self.finishedEditHandler) self.finishedEditHandler();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"];
            self.nameTextField = [[UITextField alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 16, 2)];
            self.nameTextField.borderStyle = UITextBorderStyleNone;
            self.nameTextField.placeholder = @"Track Name";
            self.nameTextField.tag = 101;
            self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.nameTextField.returnKeyType = UIReturnKeyDone;
            [self.nameTextField addTarget:self action:@selector(textFieldDidClickedReturnKey:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.contentView addSubview:self.nameTextField];
            
            if (self.isAddNewTrack) self.nameTextField.text = @"New Track";
            else self.nameTextField.text = GLOBAL.currentTrack.name;
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSInteger rowIndex = indexPath.row;
        cell.textLabel.text = self.dataArr[rowIndex];
        if (indexPath.row == self.selectedIndexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row != self.selectedIndexPath.row) {
        if (self.selectedIndexPath) {
            UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
            lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndexPath = indexPath;
        self.trackType = indexPath.row;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidClickedReturnKey:(UITextField *)textField
{
    
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
