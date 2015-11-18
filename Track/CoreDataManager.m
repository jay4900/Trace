//
//  CoreDataManager.m
//  Trace
//
//  Created by Wuffy on 11/9/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataManager *)shared
{
    static CoreDataManager *obj = nil;
    if (obj == nil) {
        obj = [[CoreDataManager alloc] init];
    }
    return obj;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.iwit2014.Trace" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Track" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Track.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *optionsDict = [NSDictionary dictionaryWithObjectsAndKeys:@(YES), NSMigratePersistentStoresAutomaticallyOption,
                                                                           @(YES), NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDict error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Fetch And Delete
- (NSManagedObject *)addEntityWithName:(NSString *)name
{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSArray *)fetchObjectsFromEntity:(NSString *)entity withKey:(NSString *)key equalsToValue:(NSString *)value
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    NSPredicate *predicate = nil;
    if (key && value) {
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    predicate = nil;
    fetchRequest = nil;
    return results;
}

#pragma mark - TrackList
- (NSMutableArray *)fetchTrackList
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:Entity_Trace];
    NSSortDescriptor *dateSortDes = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateSortDes]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (CDTrackList *track in results) {
        [resultArr addObject:track];
    }
    
    results = nil;
    
    return resultArr;
}

- (CDTrackList *)addNewTrace
{
    CDTrackList *track = (CDTrackList *)[self addEntityWithName:Entity_Trace];
    track.createTime = [[NSDate date] timeIntervalSince1970];
    return track;
}

- (void)deleteTrace:(CDTrackList *)track
{
    for (CDPath *path in track.paths) {
        for (CDCoordinate *coord in path.coords) {
            [self.managedObjectContext deleteObject:coord];
        }
        [self.managedObjectContext deleteObject:path];
    }
    
    for (CDPointMark *point in track.points) {
        [self.managedObjectContext deleteObject:point];
    }
    
    for (CDPhotoMark *photo in track.photos) {
        [self.managedObjectContext deleteObject:photo];
    }
    
    [self.managedObjectContext deleteObject:track];
}

#pragma mark - 本地Key/Value存储
- (NSString *)getLocalValueForKey:(NSString *)key withDefaultValue:(NSString *)defaultVal
{
    NSString *resultValue = @"";
    if (key == nil) {
        return resultValue;
    }
    
    CDLocalStorage *localStorage = nil;
    NSArray *results = [self fetchObjectsFromEntity:Entity_LocalStorage withKey:@"localKey" equalsToValue:key];
    if (results.count) {
        localStorage = [results firstObject];
        resultValue = localStorage.localValue;
    }else{
        if (defaultVal) {
            resultValue = defaultVal;
            localStorage = (id)[self addEntityWithName:Entity_LocalStorage];
            localStorage.localKey = key;
            localStorage.localValue = defaultVal;
        }
    }
    localStorage = nil;
    return resultValue;
}

- (NSString *)getLocalValueForKey:(NSString *)key
{
    return [self getLocalValueForKey:key withDefaultValue:nil];
}

- (void)setLocalValue:(NSString *)value forKey:(NSString *)key
{
    CDLocalStorage *localStorage = nil;
    NSArray *results = [self fetchObjectsFromEntity:Entity_LocalStorage withKey:@"localKey" equalsToValue:key];
    if (results.count) {
        localStorage = [results firstObject];
        localStorage.localValue = value;
    }else{
        localStorage = (id)[self addEntityWithName:Entity_LocalStorage];
        localStorage.localKey = key;
        localStorage.localValue = value;
    }
    localStorage = nil;
    results = nil;
}

- (void)removeLocalValueForKey:(NSString *)key
{
    CDLocalStorage *localStorage = nil;
    NSArray *results = [self fetchObjectsFromEntity:Entity_LocalStorage withKey:@"localKey" equalsToValue:key];
    if (results.count) {
        localStorage = [results firstObject];
        [self.managedObjectContext deleteObject:localStorage];
    }
    
    localStorage = nil;
    results = nil;
}

- (void)removeAllLocalKeyValues
{
    NSArray *results = [self fetchObjectsFromEntity:Entity_LocalStorage withKey:nil equalsToValue:nil];
    for (NSManagedObject *object in results) {
        [self.managedObjectContext deleteObject:object];
    }
    results = nil;
}

@end
