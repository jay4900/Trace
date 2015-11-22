//
//  CDCoordinate+CoreDataProperties.h
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCoordinate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCoordinate (CoreDataProperties)

@property (nonatomic) double altitude;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSTimeInterval timestamp;

@end

NS_ASSUME_NONNULL_END
