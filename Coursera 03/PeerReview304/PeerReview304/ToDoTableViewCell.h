//
//  ToDoTableViewCell.h
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity.h"

@interface ToDoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) ToDoEntity *localToDoEntity;

- (void) setInternalFields:(ToDoEntity *) incomingToDoEntity;

@end
