//
//  ViewController.m
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PickerViewHelper.h"


@interface ViewController ()

@property (nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *choreTF;
@property (weak, nonatomic) IBOutlet UIPickerView *chorePicker;
@property (nonatomic) PickerViewHelper *chorePickerHelper;

@property (weak, nonatomic) IBOutlet UITextField *personTF;
@property (weak, nonatomic) IBOutlet UIPickerView *personPicker;
@property (nonatomic) PickerViewHelper *personPickerHelper;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (weak, nonatomic) IBOutlet UILabel *resultLbl;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // access to AppDelegate beacuse it contains all the Core Data Stack
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // alloc & init the chorePickerHelper
    self.chorePickerHelper = [[PickerViewHelper alloc] init];
    
    // connect the ChorePickerHelper to the Chore UIPicker
    [self.chorePicker setDelegate:self.chorePickerHelper];
    [self.chorePicker setDataSource:self.chorePickerHelper];
    
    // alloc & init the personPickerHelper
    self.personPickerHelper = [[PickerViewHelper alloc] init];
    
    // connect the PersonPickerHelper to the Person UIPicker
    [self.personPicker setDelegate:self.personPickerHelper];
    [self.personPicker setDataSource:self.personPickerHelper];
    
    // update UIComponents
    [self updateUIComponents];
}


#pragma mark - My Buttons Tapped


- (IBAction)addChore:(id)sender {
    // if the field is empty return
    NSString *tmp = [self.choreTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tmp isEqualToString:@""]) return;
    
    // create chore
    ChoreMO *chore = [self.appDelegate createChoreMO];

    // put data into it
    chore.chore_name = self.choreTF.text;
    
    // save it to the database
    [self.appDelegate saveContext];
    
    // update ChorePicker
    [self updateChorePicker];
}


- (IBAction)addPerson:(id)sender {
    // if the field is empty return
    NSString *tmp = [self.personTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tmp isEqualToString:@""]) return;
    
    // create chore
    PersonMO *person = [self.appDelegate createPersonMO];
    
    // put data into it
    person.person_name = self.personTF.text;
    
    // save it to the database
    [self.appDelegate saveContext];
    
    // update PersonPicker
    [self updatePersonPicker];
}


- (IBAction)connect:(id)sender {
    // Prepare connection (Chore & Person)
    // cast beacuse the method I build returing object
    ChoreMO *chore = (ChoreMO *) [self.chorePickerHelper getItmeByIndex:[self.chorePicker selectedRowInComponent:0]];
    PersonMO *person = (PersonMO *) [self.personPickerHelper getItmeByIndex:[self.personPicker selectedRowInComponent:0]];
    
    // Create the Chore Log entry
    ChoreLogMO *choreLog = [self.appDelegate createChoreLogMO];
    choreLog.chore_done = chore;
    choreLog.who_did_it = person;
    choreLog.when = [self.datePicker date];
    
    [self.appDelegate saveContext];
    
    [self updateResultLabel];
}


- (IBAction)clear:(id)sender {
    // delete all Chores
    NSArray *chores = [self fetchEntity:@"Chore"];
    for (ChoreMO *chore in chores) {
        [self.appDelegate.managedObjectContext deleteObject:chore];
    }
    
    // delete all Persons
    NSArray *persons = [self fetchEntity:@"Person"];
    for (ChoreMO *person in persons) {
        [self.appDelegate.managedObjectContext deleteObject:person];
    }
    
    // delete all choreLogs
    NSArray *choreLogs = [self fetchEntity:@"ChoreLog"];
    for (ChoreLogMO *choreLog in choreLogs) {
        [self.appDelegate.managedObjectContext deleteObject:choreLog];
    }
    
    // save chages (on MOC) to the database
    [self.appDelegate saveContext];
    
    // update UIComponents
    [self updateUIComponents];
}


#pragma mark - Helper Functions


- (NSArray *) fetchEntity: (NSString *)entityName {
    // Prepare the fetch (MOC, Request, Error)
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSError *error = nil;
    
    // Submit the fetch request
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    // Check if it is empty
    if (!results) {
        NSLog(@"Error fetching %@ objects: %@\n%@", entityName, [error localizedDescription], [error userInfo]);
        return @[]; // return empty array
    }
    return results;
}


- (void) updateUIComponents {
    // update Chore UIPicker
    [self updateChorePicker];
    
    // update Person UIPicker
    [self updatePersonPicker];
    
    // update results Label
    [self updateResultLabel];
}


- (void) updateChorePicker {
    // fetching the rows from Chore Entity (table)
    NSArray *chores = [self fetchEntity:@"Chore"];
    
    // put data into the helper
    [self.chorePickerHelper setArray:chores];
    
    // update the UI
    [self.chorePicker reloadAllComponents];
}


- (void) updatePersonPicker {
    // fetching the rows from Chore Entity (table)
    NSArray *persons = [self fetchEntity:@"Person"];
    
    // put data into the helper
    [self.personPickerHelper setArray:persons];
    
    // update the UI
    [self.personPicker reloadAllComponents];
}


- (void) updateResultLabel {
    // fetching the rows from ChoreLog Entity (table)
    NSArray *choreLogs = [self fetchEntity:@"ChoreLog"];
    
    // Make String of results and print it on the Label
    NSMutableString *buffer = [NSMutableString stringWithString:@""];
    for (ChoreLogMO *choreLog in choreLogs) {
        [buffer appendFormat:@"\n%@", choreLog, nil]; // we will override the description method
    }
    self.resultLbl.text = buffer;
}

@end
