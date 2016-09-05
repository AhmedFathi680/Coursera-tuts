//
//  ViewController.m
//  CourseraPeer2
//
//  Created by Ahmed Fathi on 6/22/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *uesrInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double) convertToKm_H:(double)value {
    return 1.60934 * value;
}

- (double) convertToM_H:(double)value {
    return 1.60934 * 100 * value;
}

- (double) convertToM_S:(double)value {
    return 1.60934 * 100 / 60 / 60 * value;
}

- (IBAction)update:(UIButton *)sender {
    double value = [self.uesrInput.text doubleValue];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            value = [self convertToKm_H:value];
            break;
        case 1:
            value = [self convertToM_H:value];
            break;
        case 2:
            value = [self convertToM_S:value];
            break;
        default:
            break;
    }
    self.result.text = [NSString stringWithFormat:@"%f", value];
}


@end
