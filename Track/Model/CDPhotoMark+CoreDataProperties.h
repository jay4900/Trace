//
//  CDPhotoMark+CoreDataProperties.h
//  Track
//
//  Created by Wuffy on 11/19/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPhotoMark.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPhotoMark (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nullable, nonatomic, retain) NSString *des;
@property (nonatomic) double altitude;
@property (nullable, nonatomic, retain) CDStyle *style;
@property (nullable, nonatomic, retain) CDTrackList *track;

@end

NS_ASSUME_NONNULL_END
