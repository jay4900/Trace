//
//  MyGlobal.h
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGlobal : NSObject
+ (MyGlobal *)shared;

@property (strong, nonatomic) TraceInfo *traceInfo;
@property (strong, nonatomic) NSMutableArray *coordsArr;
@property BOOL isTracing;

//获取Documents下文件夹路径
- (NSString *)getFolder:(NSString *)folderName;
//生成一个以时间为后缀的文件名称
- (NSString *)getNewTraceFileName;
//计算两个定位点之间的距离
- (CGFloat)distanceFromLocation:(CLLocation *)location1 toLocation:(CLLocation *)location2;
@end
