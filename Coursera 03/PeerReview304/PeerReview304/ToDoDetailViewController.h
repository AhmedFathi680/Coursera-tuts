//
//  ToDoDetailViewController.h
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHandlesMOC.h"
#import "DPHandlesToDoEntity.h"

@interface ToDoDetailViewController : UIViewController <DPHandlesMOC, DPHandlesToDoEntity>

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC;
- (void)receiveToDoEntity:(ToDoEntity *)incomingToDoEntity;

@end
