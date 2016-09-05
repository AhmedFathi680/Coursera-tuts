//
//  AppDelegate.h
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChoreMO.h"
#import "PersonMO.h"
#import "ChoreLogMO.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (ChoreMO *) createChoreMO;
- (PersonMO *) createPersonMO;
- (ChoreLogMO *) createChoreLogMO;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

