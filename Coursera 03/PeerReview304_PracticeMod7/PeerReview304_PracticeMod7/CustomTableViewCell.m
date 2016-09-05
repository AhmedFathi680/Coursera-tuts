//
//  CustomTableViewCell.m
//  PeerReview304_PracticeMod7
//
//  Created by Ahmed Fathi on 7/11/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTitle: (ToDoEntity *) entity {
    self.label.text = entity.title;
}

@end
