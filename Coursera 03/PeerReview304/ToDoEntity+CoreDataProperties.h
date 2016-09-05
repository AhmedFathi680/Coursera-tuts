//
//  ToDoEntity+CoreDataProperties.h
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/13/16.
//  Copyright © 2016 company.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *toDoDueDate;
@property (nullable, nonatomic, retain) NSString *toDoNotes;
@property (nullable, nonatomic, retain) NSNumber *toDoPriority;
@property (nullable, nonatomic, retain) NSString *toDoTitle;

@end

NS_ASSUME_NONNULL_END
