//
//  NavigationViewController.m
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// pass the moc to ToDoTableViewController
- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC {
    // immediatily pass to the first viewController of the navigation (tableView)
    [(id<DPHandlesMOC>)self.viewControllers[0] receiveMOC:incomingMOC];
}

@end
