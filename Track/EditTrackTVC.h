//
//  EditTrackTVC.h
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTrackTVC : UITableViewController
@property (strong, nonatomic) dispatch_block_t finishedEditHandler;
@property (strong, nonatomic) dispatch_block_t deleteTrackHandler;
@property BOOL isAddNewTrack;
@property TrackType trackType;
@end
