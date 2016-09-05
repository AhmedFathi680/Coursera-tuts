//
//  PickerViewHelper.h
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PickerViewHelper : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

- (void) setArray:(NSArray *)data;
- (void) addItem:(NSObject *)item;
- (NSObject *) getItmeByIndex:(NSUInteger)index;

@end
