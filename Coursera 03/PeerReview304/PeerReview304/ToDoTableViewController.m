//
//  ToDoTableViewController.m
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//


#import "CoreData/CoreData.h"

#import "ToDoTableViewController.h"
#import "ToDoTableViewCell.h"


@interface ToDoTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ToDoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNSFetchedResultsControllerDelegate];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (ToDoTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ToDoTableViewCell *cell = (ToDoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    ToDoEntity *toDo = self.fetchedResultsController.sections[indexPath.section].objects[indexPath.row];
    [cell setInternalFields:toDo];
    return cell;
}



#pragma mark - NSFetchedResultsControllerDelegate


- (void) initializeNSFetchedResultsControllerDelegate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:self.moc];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoDueDate" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    NSError *err;
    BOOL fetchSucceeded = [self.fetchedResultsController performFetch:&err];
    if (!fetchSucceeded) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Couldn't fectch" userInfo:nil];
    }
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates]; // I didn't declare it, declared by the navigation controller (implicitly)
}

- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            ToDoEntity *toDo = [controller objectAtIndexPath:indexPath];
            ToDoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setInternalFields:toDo];
            break;
        }
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}



#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // send the moc to destenation segue
    [(id<DPHandlesMOC>) [segue destinationViewController] receiveMOC:self.moc];
    
    // check if its new ToDo or selected cell
    ToDoEntity *toDo;
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        // add new -> set toDo to a new Entity Description (new instance in the table)
        toDo = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:self.moc];
    } else {
        // get the local entity
        toDo = ((ToDoTableViewCell *)sender).localToDoEntity;
    }
    // either this or this, we send the enitity to the next View Controller
    [(id<DPHandlesToDoEntity>) [segue destinationViewController] receiveToDoEntity:toDo];
}


#pragma mark - Protocols

// receive it from the navigation controller
- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC {
    // store the moc locally
    self.moc = incomingMOC;
}


@end
