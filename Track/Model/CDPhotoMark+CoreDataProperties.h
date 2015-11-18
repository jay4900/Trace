//
//  CDPhotoMark+CoreDataProperties.h
//  Track
//
//  Created by Wuffy on 11/18/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDPhotoMark.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDPhotoMark (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
