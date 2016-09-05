//
//  PickerViewHelper.m
//  PeerReview204
//
//  Created by Ahmed Fathi on 7/2/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "PickerViewHelper.h"

@interface PickerViewHelper ()

@property (nonatomic) NSMutableArray *data;

@end

@implementation PickerViewHelper

@synthesize data=_data;

- (void) viewDidLoad {
    [super viewDidLoad];
}

// override the init functions
- (id) init {
    if (self = [super init]) {
        self.data = [NSMutableArray arrayWithArray:@[]];
    }
    return self;
}


- (void) setArray:(NSArray *)data {
    _data = [NSMutableArray arrayWithArray:data];
}


- (void) addItem:(NSObject *)item {
    [_data addObject:item];
}


- (NSObject *) getItmeByIndex:(NSUInteger)index {
    return [_data objectAtIndex:index];
}


#pragma mark - Implement Inheritance


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_data count];
}


- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // look on ChoreMO.m and PersonMO.m, description method overriden to bring back the names
    return [[_data objectAtIndex:row] description];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


@end
