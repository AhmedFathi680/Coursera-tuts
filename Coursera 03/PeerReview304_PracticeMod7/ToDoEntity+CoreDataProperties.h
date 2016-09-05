//
//  ToDoEntity+CoreDataProperties.h
//  PeerReview304_PracticeMod7
//
//  Created by Ahmed Fathi on 7/11/16.
//  Copyright © 2016 company.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
