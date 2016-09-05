//
//  NavigationViewController.h
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHandlesMOC.h"

@interface NavigationViewController : UINavigationController <DPHandlesMOC>

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
