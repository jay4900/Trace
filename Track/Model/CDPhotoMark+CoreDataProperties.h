//
//  CDPhotoMark+CoreDataProperties.h
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPhotoMark.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPhotoMark (CoreDataProperties)

@property (nonatomic) double altitude;
@property (nullable, nonatomic, retain) NSString *des;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) CDStyle *style;

@end

NS_ASSUME_NONNULL_END
