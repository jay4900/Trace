//
//  MyGlobal.m
//  Trace
//
//  Created by Wuffy on 11/7/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "MyGlobal.h"

@implementation MyGlobal
+ (MyGlobal *)shared
{
    static MyGlobal *obj = nil;
    if (obj == nil) {
        obj = [[self alloc] init];
    }
    return obj;
}

- (NSString *)getFolder:(NSString *)folderName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), folderName];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fm fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

- (NSString *)getNewTraceFileName
{
    NSString *resultStr = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:date];
    resultStr = [NSString stringWithFormat:@"trace_%@.plist", dateStr];
    return resultStr;
}

- (CGFloat)distanceFromLocation:(CLLocation *)location1 toLocation:(CLLocation *)location2
{
    CGFloat distance = 0;
    CGFloat lateralDistance = [location1 distanceFromLocation:location2];
    CGFloat height = fabs(location1.altitude - location2.altitude);
    distance = sqrt(lateralDistance * lateralDistance + height * height);
    
    return distance;
}

@end
