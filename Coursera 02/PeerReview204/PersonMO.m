//
//  PersonMO.m
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "PersonMO.h"
#import "ChoreLogMO.h"

@implementation PersonMO

// Insert code here to add functionality to your managed object subclass

// override description method
- (NSString *)description {
    return self.person_name;
}

@end
