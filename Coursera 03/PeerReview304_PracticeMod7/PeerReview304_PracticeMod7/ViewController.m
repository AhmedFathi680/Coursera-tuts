//
//  ViewController.m
//  PeerReview304_PracticeMod7
//
//  Created by Ahmed Fathi on 7/11/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "ToDoEntity.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // prepare request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:self.moc];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
    
    // process the request
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchController.delegate = self;
    
    NSError *err;
    BOOL isSuccessed = [self.fetchController performFetch:&err];
    if(!isSuccessed) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn't Fetch!" userInfo:nil];
    }
}


#pragma mark - Buttons Tapped

// Primary Action Triggered (textField)
- (IBAction)doneTapped:(id)sender {
    
    // Create CoreData Object contains the new data
    ToDoEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:self.moc];
    entity.title = self.textField.text;
    
    // Save the data, if not save raise exception
    NSError *err;
    BOOL isSaved = [self.moc save:&err];
    if (isSaved) {
        // successed: Clear the textField
        self.textField.text = nil;
    } else {
        // failed: throw an exception
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn't Save!" userInfo:@{NSUnderlyingErrorKey:err}];
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate Functions

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchController.sections[section].numberOfObjects;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoEntity *entity = self.fetchController.sections[indexPath.section].objects[indexPath.row];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    [cell setTitle:entity];
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate Functions

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {

    switch (type) {
        
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        // carly braces beacuse: case body is not block
        // so you can't declare variables, only use expresions
        case NSFetchedResultsChangeUpdate: {
            ToDoEntity *entity = [controller objectAtIndexPath:indexPath];
            CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setTitle:entity];
        }
            break;
        
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
