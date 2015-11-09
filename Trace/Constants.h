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

//文件夹名称
#define FOLDER_CACHES   @"Caches"

//BLOCKS
typedef void(^SelectIndexHandler)(NSInteger index);
typedef void(^SingleObjectHandler)(id obj);

//通知名称
#define NOTIFY_addLineToMap         @"addLineToMap"

//CoreData Entity
#define Entity_Location             @"CDLocation"
#define Entity_Trace                @"CDTraceList"

#endif /* Constants_h */
