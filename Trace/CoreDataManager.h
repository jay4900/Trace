//
//  CoreDataManager.h
//  Trace
//
//  Created by Wuffy on 11/9/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDLocation.h"
#import "CDTraceList.h"

@interface CoreDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)shared;

- (NSManagedObject *)addEntityWithName:(NSString *)name;

- (NSMutableArray *)fetchTraceList;
- (CDTraceList *)addNewTraceWithName:(NSString *)name;
- (CDTraceList *)fetchTraceWithName:(NSString *)name;
- (void)deleteTrace:(CDTraceList *)trace;
- (void)fetchLocationsCount;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
