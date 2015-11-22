//
//  Constants.h
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define GLOBAL        [MyGlobal shared]
#define COREDATA      [CoreDataManager shared]

#define GREENCOLOR  [UIColor colorWithRed:35.0/255.0 green:255.0/255.0 blue:131.0/255.0 alpha:1.0]
#define LINECOLOR   [UIColor colorWithRed:0xff/255.0 green:0x68/255.0 blue:0x68/255.0 alpha:1.0]

#define SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]
#define SCREEN_BOUNDS   [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH    CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT   CGRectGetHeight([[UIScreen mainScreen] bounds])

//文件夹名称
#define FOLDER_CACHES   @"Caches"

//BLOCKS
typedef void(^SelectIndexHandler)(NSInteger index);
typedef void(^SingleObjectHandler)(id obj);

//通知名称
#define NOTIFY_addLineToMap         @"addLineToMap"
#define NOTIFY_ShowTrackToMap       @"ShowTrackToMap"

//CoreData Entity
#define Entity_Trace                @"CDTrackList"
#define Entity_Path                 @"CDPath"
#define Entity_Coord                @"CDCoordinate"
#define Entity_PointMark            @"CDPointMark"
#define Entity_PhotoMark            @"CDPhotoMark"
#define Entity_Style                @"CDStyle"
#define Entity_LocalStorage         @"CDLocalStorage"

//定义TrackType
typedef NS_ENUM(NSInteger, TrackType) {
    kTrackType_Walk = 0,
    kTrackType_Run,
    kTrackType_Hike,
    kTrackType_Cycle,
    kTrackType_Drive,
    kTrackType_Other
};

#endif /* Constants_h */
