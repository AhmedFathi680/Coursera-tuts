//
//  ChoreLogMO.m
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ChoreLogMO.h"
#import "ChoreMO.h"
#import "PersonMO.h"

@implementation ChoreLogMO

// Insert code here to add functionality to your managed object subclass
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ will %@ at %@", self.who_did_it, self.chore_done, self.when];
}

@end
