//
//  ToDoDetailViewController.m
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ToDoDetailViewController.h"

@interface ToDoDetailViewController ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) ToDoEntity *localToDoEntity;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *notesTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySC;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDP;

@end

@implementation ToDoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - Helper functions

- (void) saveLocalData {
    NSError *err;
    BOOL SaveSuccess = [self.moc save:&err];
    if (!SaveSuccess) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn't save" userInfo:@{NSUnderlyingErrorKey:err}];
    }
}



#pragma mark - View Aapear

- (void) viewWillAppear:(BOOL)animated {
    self.titleTF.text   = self.localToDoEntity.toDoTitle;
    self.notesTV.text   = self.localToDoEntity.toDoNotes;
    [self.prioritySC    setSelectedSegmentIndex:[self.localToDoEntity.toDoPriority integerValue]];
    if (self.localToDoEntity.toDoDueDate != nil) {
        [self.dueDP setDate:self.localToDoEntity.toDoDueDate];
    }
    
    // observe changes on the textView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];

    NSString *title = [self.titleTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *notes = [self.notesTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([title isEqualToString:@""] && [notes isEqualToString:@""]) {
        [self.moc deleteObject:self.localToDoEntity];
        return;
    }
    if ([title isEqualToString:@""]) title = @"No title";
    
    self.localToDoEntity.toDoTitle = title;
    self.localToDoEntity.toDoNotes = notes;
    self.localToDoEntity.toDoPriority = [NSNumber numberWithInteger:self.prioritySC.selectedSegmentIndex];
    self.localToDoEntity.toDoDueDate = self.dueDP.date;
    
    [self saveLocalData];

}




#pragma mark - Actions


- (IBAction)trashTapped:(id)sender {
    [self.moc deleteObject:self.localToDoEntity];
    [self saveLocalData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)titleTextFieldEdittingDidEnd:(id)sender {
    NSString *title = [self.titleTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([title isEqualToString:@""]) title = @"No title";
    self.localToDoEntity.toDoTitle = title;
    [self saveLocalData];
}

- (void)textViewDidEndEditing:(NSNotification *) notification {
    if ([notification object] == self) {
        NSString *notes = [self.notesTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.localToDoEntity.toDoNotes = notes;
        [self saveLocalData];
    }
}

- (IBAction)priorityValueChanged:(id)sender {
    self.localToDoEntity.toDoPriority = [NSNumber numberWithInteger:self.prioritySC.selectedSegmentIndex];
    [self saveLocalData];
}

- (IBAction)datePickerEditingDidEnd:(id)sender {
    self.localToDoEntity.toDoDueDate = self.dueDP.date;
    [self saveLocalData];
}





#pragma mark - Protocols

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC {
    // store the moc locally
    self.moc = incomingMOC;
}

- (void) receiveToDoEntity:(ToDoEntity *)incomingToDoEntity {
    self.localToDoEntity = incomingToDoEntity;
}

@end
