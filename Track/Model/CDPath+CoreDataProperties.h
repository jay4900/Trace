//
//  CDPath+CoreDataProperties.h
//  Track
//
//  Created by Wuffy on 11/19/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPath.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPath (CoreDataProperties)

@property (nullable, nonatomic, retain) NSOrderedSet<CDCoordinate *> *coords;
@property (nullable, nonatomic, retain) CDStyle *lineStyle;
@property (nullable, nonatomic, retain) CDTrackList *track;

@end

@interface CDPath (CoreDataGeneratedAccessors)

- (void)insertObject:(CDCoordinate *)value inCoordsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCoordsAtIndex:(NSUInteger)idx;
- (void)insertCoords:(NSArray<CDCoordinate *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCoordsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCoordsAtIndex:(NSUInteger)idx withObject:(CDCoordinate *)value;
- (void)replaceCoordsAtIndexes:(NSIndexSet *)indexes withCoords:(NSArray<CDCoordinate *> *)values;
- (void)addCoordsObject:(CDCoordinate *)value;
- (void)removeCoordsObject:(CDCoordinate *)value;
- (void)addCoords:(NSOrderedSet<CDCoordinate *> *)values;
- (void)removeCoords:(NSOrderedSet<CDCoordinate *> *)values;

@end

NS_ASSUME_NONNULL_END
