//
//  ToDoTableViewCell.m
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ToDoTableViewCell.h"

@implementation ToDoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setInternalFields:(ToDoEntity *)incomingToDoEntity {
    self.nameLabel.text = incomingToDoEntity.toDoTitle;

    switch ([incomingToDoEntity.toDoPriority integerValue]) {
        case 0:
            self.priorityLabel.text = @"Low";
            break;
        case 1:
            self.priorityLabel.text = @"Medium";
            break;
        case 2:
            self.priorityLabel.text = @"High";
    }
    
    // prepare Date Formatter with styles for data & time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // use the chosen style for data & time to put date in string
    self.dateLabel.text = [dateFormatter stringFromDate:incomingToDoEntity.toDoDueDate];
    
    self.localToDoEntity = incomingToDoEntity;
}

@end
