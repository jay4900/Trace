//
//  EditTrackTVC.m
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//

#import "EditTrackTVC.h"
#import "InputNameCell.h"
#import "CommonCell.h"
#import "OneBtnCell.h"

@interface EditTrackTVC ()
@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) UIBarButtonItem *doneItem;
@end

@implementation EditTrackTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initViewNodes];
}

- (void)initViewNodes
{
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

- (void)deleteTrackBtnPressed:(id)sender
{
    MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:nil
                                                        message:@"Are you sure to delete the track?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    alertView.handler = ^(NSInteger index) {
        if (index == 1) {
            NSLog(@"delete track");
            [COREDATA deleteTrack:GLOBAL.currentTrack];
            GLOBAL.currentTrack = nil;
            if (self.deleteTrackHandler) self.deleteTrackHandler();
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isAddNewTrack) {
        return 2;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataArr.count;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) {
        title = @"Track Name";
    }else if (section == 1){
        title = @"Track Type";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        InputNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell" forIndexPath:indexPath];
        cell.textField.placeholder = @"Track Name";
        if (self.isAddNewTrack) cell.textField.text = @"New Track";
        else cell.textField.text = GLOBAL.currentTrack.name;
        
        self.nameTextField = cell.textField;
        [self.nameTextField addTarget:self action:@selector(textFieldDidClickedReturnKey:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        return cell;
    }else if (indexPath.section == 1) {
        CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell" forIndexPath:indexPath];
        NSInteger rowIndex = indexPath.row;
        cell.leftLabel.text = self.dataArr[rowIndex];
        if (indexPath.row == self.selectedIndexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }else{
        OneBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BtnCell" forIndexPath:indexPath];
        [cell.btn setTitle:@"Delete" forState:UIControlStateNormal];
        [cell.btn setBackgroundColor:[UIColor redColor]];
        [cell.btn addTarget:self action:@selector(deleteTrackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate
- (void)textFieldDidClickedReturnKey:(UITextField *)textField
{
    
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
