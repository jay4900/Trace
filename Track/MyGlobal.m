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
    resultStr = [NSString stringWithFormat:@"trace_%@", dateStr];
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

- (CGFloat)distanceFromCoord:(CDCoordinate *)coord1 toCoord:(CDCoordinate *)coord2
{
    CLLocation *location1 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(coord1.latitude, coord1.longitude) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    CLLocation *location2 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(coord2.latitude, coord2.longitude) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    return [self distanceFromLocation:location1 toLocation:location2];
}

- (BOOL)checkTrackNameIsValid:(NSString *)name
{
    BOOL result = NO;
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5\\- ]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:name]){
        NSLog(@"昵称只能由中文、字母或数字组成");
        result = NO;
    }else{
        result = YES;
    }
    
    return result;
}

@end
