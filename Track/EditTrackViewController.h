//
//  EditTrackViewController.h
//  Track
//
//  Created by Wuffy on 11/18/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTrackViewController : UIViewController
@property (strong, nonatomic) dispatch_block_t finishedEditHandler;
@property BOOL isAddNewTrack;
@property TrackType trackType;
@end
