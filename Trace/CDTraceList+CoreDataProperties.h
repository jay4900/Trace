//
//  CDTraceList+CoreDataProperties.h
//  Trace
//
//  Created by Wuffy on 11/9/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDTraceList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDTraceList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSSet<CDLocation *> *locations;

@end

@interface CDTraceList (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(CDLocation *)value;
- (void)removeLocationsObject:(CDLocation *)value;
- (void)addLocations:(NSSet<CDLocation *> *)values;
- (void)removeLocations:(NSSet<CDLocation *> *)values;

@end

NS_ASSUME_NONNULL_END
