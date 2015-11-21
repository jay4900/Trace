//
//  CDCoordinate+CoreDataProperties.h
//  Track
//
//  Created by Wuffy on 11/19/15.
//  Copyright © 2015 Wuffy. All rights reserved.
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
@property (nullable, nonatomic, retain) CDPath *path;

@end

NS_ASSUME_NONNULL_END
