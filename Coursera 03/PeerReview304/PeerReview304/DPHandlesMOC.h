//
//  DPHandlesMOC.h
//  PeerReview304
//
//  Created by Ahmed Fathi on 7/12/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPHandlesMOC <NSObject>

- (void)receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
