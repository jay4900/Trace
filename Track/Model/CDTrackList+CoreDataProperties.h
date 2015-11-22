//
//  CDTrackList+CoreDataProperties.h
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDTrackList.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDTrackList (CoreDataProperties)

@property (nonatomic) double ascent;
@property (nonatomic) double averageSpeed;
@property (nonatomic) NSTimeInterval createTime;
@property (nullable, nonatomic, retain) NSString *des;
@property (nonatomic) double descent;
@property (nonatomic) int64_t distance;
@property (nonatomic) double duration;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) BOOL haveSaved;
@property (nonatomic) double maxSpeed;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int16_t trackType;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPath *> *paths;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPhotoMark *> *photos;
@property (nullable, nonatomic, retain) NSOrderedSet<CDPointMark *> *points;

@end

@interface CDTrackList (CoreDataGeneratedAccessors)

- (void)insertObject:(CDPath *)value inPathsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPathsAtIndex:(NSUInteger)idx;
- (void)insertPaths:(NSArray<CDPath *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePathsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPathsAtIndex:(NSUInteger)idx withObject:(CDPath *)value;
- (void)replacePathsAtIndexes:(NSIndexSet *)indexes withPaths:(NSArray<CDPath *> *)values;
- (void)addPathsObject:(CDPath *)value;
- (void)removePathsObject:(CDPath *)value;
- (void)addPaths:(NSOrderedSet<CDPath *> *)values;
- (void)removePaths:(NSOrderedSet<CDPath *> *)values;

- (void)insertObject:(CDPhotoMark *)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray<CDPhotoMark *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(CDPhotoMark *)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray<CDPhotoMark *> *)values;
- (void)addPhotosObject:(CDPhotoMark *)value;
- (void)removePhotosObject:(CDPhotoMark *)value;
- (void)addPhotos:(NSOrderedSet<CDPhotoMark *> *)values;
- (void)removePhotos:(NSOrderedSet<CDPhotoMark *> *)values;

- (void)insertObject:(CDPointMark *)value inPointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPointsAtIndex:(NSUInteger)idx;
- (void)insertPoints:(NSArray<CDPointMark *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPointsAtIndex:(NSUInteger)idx withObject:(CDPointMark *)value;
- (void)replacePointsAtIndexes:(NSIndexSet *)indexes withPoints:(NSArray<CDPointMark *> *)values;
- (void)addPointsObject:(CDPointMark *)value;
- (void)removePointsObject:(CDPointMark *)value;
- (void)addPoints:(NSOrderedSet<CDPointMark *> *)values;
- (void)removePoints:(NSOrderedSet<CDPointMark *> *)values;

@end

NS_ASSUME_NONNULL_END
