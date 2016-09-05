//
//  CustomTableViewCell.h
//  PeerReview304_PracticeMod7
//
//  Created by Ahmed Fathi on 7/11/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity.h"

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

- (void) setTitle:(ToDoEntity *) entity;

@end
