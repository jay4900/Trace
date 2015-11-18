//
//  CDPointMark+CoreDataProperties.h
//  Track
//
//  Created by Wuffy on 11/18/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPointMark.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPointMark (CoreDataProperties)

@property (nonatomic) double altitude;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *des;
@property (nullable, nonatomic, retain) CDStyle *style;

@end

NS_ASSUME_NONNULL_END
