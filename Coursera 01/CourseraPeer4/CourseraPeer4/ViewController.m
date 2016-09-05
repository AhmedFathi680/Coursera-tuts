//
//  ViewController.m
//  CourseraPeer4
//
//  Created by Ahmed Fathi on 6/26/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *request;

@property (weak, nonatomic) IBOutlet UITextField *startTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *destATF;
@property (weak, nonatomic) IBOutlet UILabel *destALbl;

@property (weak, nonatomic) IBOutlet UITextField *destBTF;
@property (weak, nonatomic) IBOutlet UILabel *destBLbl;

@property (weak, nonatomic) IBOutlet UITextField *destCTF;
@property (weak, nonatomic) IBOutlet UILabel *destCLbl;

@property (weak, nonatomic) IBOutlet UITextField *destDTF;
@property (weak, nonatomic) IBOutlet UILabel *destDLbl;

@property (weak, nonatomic) IBOutlet UIButton *calculateBtn;
@end

@implementation ViewController

@synthesize request=_request;

@synthesize startTF=_startTF;
@synthesize unitSegmentedControl=_unitSegmentedControl;

@synthesize destATF=_destATF;
@synthesize destALbl=_destALbl;

@synthesize destBTF=_destBTF;
@synthesize destBLbl=_destBLbl;

@synthesize destCTF=_destCTF;
@synthesize destCLbl=_destCLbl;

@synthesize destDTF=_destDTF;
@synthesize destDLbl=_destDLbl;

@synthesize calculateBtn=_calculateBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    _calculateBtn.layer.cornerRadius = 10;
}

- (IBAction)calculateTapped:(UIButton *)sender {
    _calculateBtn.enabled = NO;
    
    // prepare input to the request
    NSString *start = _startTF.text;
    NSArray *destinations = @[_destATF.text, _destBTF.text, _destCTF.text, _destDTF.text];
    
    // alloc and init the request
    _request = [[DGDistanceRequest alloc] initWithLocationDescriptions:destinations sourceDescription:start];
    
    // request callback
    __weak ViewController *weakSelf = self;
    _request.callback = ^(NSArray *distances) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSString *unit;
        double factor = 1.0;
        switch (strongSelf.unitSegmentedControl.selectedSegmentIndex) {
            case 0:
                unit = @"Miles";
                factor = 0.000621371; // from google
                break;
            case 1:
                unit = @"Meters";
                factor = 1.0;
                break;
            case 2:
                unit = @"Km";
                factor = 0.001;
                break;
        }
        
        NSNull *nilResult = [NSNull null];
        if (distances[0] != nilResult)
            strongSelf.destALbl.text = [NSString stringWithFormat:@"%.2f %@", [distances[0] floatValue] * factor, unit];
        if (distances[1] != nilResult)
            strongSelf.destBLbl.text = [NSString stringWithFormat:@"%.2f %@", [distances[1] floatValue] * factor, unit];
        if (distances[2] != nilResult)
            strongSelf.destCLbl.text = [NSString stringWithFormat:@"%.2f %@", [distances[2] floatValue] * factor, unit];
        if (distances[3] != nilResult)
            strongSelf.destDLbl.text = [NSString stringWithFormat:@"%.2f %@", [distances[3] floatValue] * factor, unit];
    };
    
    [_request start];
    _request = nil;
    _calculateBtn.enabled = YES;
}


@end
