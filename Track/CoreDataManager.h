//
//  CoreDataManager.h
//  Trace
//
//  Created by Wuffy on 11/9/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDTrackList.h"
#import "CDPath.h"
#import "CDCoordinate.h"
#import "CDPointMark.h"
#import "CDPhotoMark.h"
#import "CDStyle.h"
#import "CDLocalStorage.h"

@interface CoreDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)shared;

- (NSManagedObject *)addEntityWithName:(NSString *)name;

- (NSMutableArray *)fetchTrackList;
- (CDTrackList *)addNewTrack;
- (void)deleteTrack:(CDTrackList *)track;
- (void)insertCoordinate:(CDCoordinate *)coord intoTrack:(CDTrackList *)track;

//本地Key/Value存储
- (NSString *)getLocalValueForKey:(NSString *)key;
- (NSString *)getLocalValueForKey:(NSString *)key withDefaultValue:(NSString *)defaultVal;
- (void)setLocalValue:(NSString *)value forKey:(NSString *)key;
- (void)removeLocalValueForKey:(NSString *)key;
- (void)removeAllLocalKeyValues;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
