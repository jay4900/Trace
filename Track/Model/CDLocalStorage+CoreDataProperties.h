//
//  CDLocalStorage+CoreDataProperties.h
//  Track
//
//  Created by wufei on 15/11/22.
//  Copyright © 2015年 Wuffy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDLocalStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDLocalStorage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *localKey;
@property (nullable, nonatomic, retain) NSString *localValue;

@end

NS_ASSUME_NONNULL_END
