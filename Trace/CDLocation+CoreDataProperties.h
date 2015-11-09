//
//  CDLocation+CoreDataProperties.h
//  Trace
//
//  Created by Wuffy on 11/9/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *altitude;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) CDTraceList *traceList;

@end

NS_ASSUME_NONNULL_END
