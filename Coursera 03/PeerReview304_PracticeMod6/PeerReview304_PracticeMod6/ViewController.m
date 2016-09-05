//
//  ViewController.m
//  PeerReview304_PracticeMod6
//
//  Created by Ahmed Fathi on 7/10/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addSegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableContents;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableContents = [NSMutableArray arrayWithArray:@[@"Walter White", @"David Michigan", @"Hawdie", @"Alex Niban"]];
}


#pragma mark - Buttons Tapped

// Primairy Action Triggered on textField
- (IBAction)addTapped:(id)sender {
    // check for validity
    NSString *trimmed = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmed isEqualToString:@""]) return;
    
    // check for repeatness
    NSLog(@"%lu\n", (unsigned long)[self.tableContents indexOfObject:trimmed]);
    if ((int)[self.tableContents indexOfObject:trimmed] >= 0) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Already exists!"
                                            message:[NSString stringWithFormat:@"%@ already exists",trimmed]
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSIndexPath *indexPath;
    
    if (self.addSegmentedControl.selectedSegmentIndex == 1) { // Add at last
        // make indexPath
        indexPath = [NSIndexPath indexPathForRow:self.tableContents.count inSection:0];
        // add the element to the array at last
        [self.tableContents addObject:self.textField.text];
        
    } else { // add at first

        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        NSArray *tmp = self.tableContents;
        self.tableContents = [NSMutableArray arrayWithArray:@[self.textField.text]];
        [self.tableContents addObjectsFromArray:tmp];
    }
    
    // Animations:
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    // update the contents without animations
//    [self.tableContents addObject:self.textField.text];
//    [self.tableView reloadData];
}


// manually sort with animations
- (IBAction)sortTapped:(id)sender {
    
    if (self.sortSegmentedControl.selectedSegmentIndex == 0) {
        // ascending
        for (long i = self.tableContents.count - 2; i >= 0; i--) {
            for (long j = 0; j <= i; j++) {
                if ([self.tableContents[j] compare:self.tableContents[j+1]] > 0) {
                    [self.tableContents exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    NSIndexPath *idxPath1 = [NSIndexPath indexPathForRow:j inSection:0];
                    NSIndexPath *idxPath2 = [NSIndexPath indexPathForRow:j+1 inSection:0];
                    [self.tableView moveRowAtIndexPath:idxPath1 toIndexPath:idxPath2];
                }
            }
        }
    } else {
        // decending
        for (long i = self.tableContents.count - 2; i >= 0; i--) {
            for (long j = 0; j <= i; j++) {
                if ([self.tableContents[j] compare:self.tableContents[j+1]] < 0) {
                    [self.tableContents exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                    NSIndexPath *idxPath1 = [NSIndexPath indexPathForRow:j inSection:0];
                    NSIndexPath *idxPath2 = [NSIndexPath indexPathForRow:j+1 inSection:0];
                    [self.tableView moveRowAtIndexPath:idxPath1 toIndexPath:idxPath2];
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableContents.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create A new Cell
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    
    // Set its label text
    cell.label.text = self.tableContents[(int)indexPath.row];
    
    // return the cell
    return cell;
}


@end
