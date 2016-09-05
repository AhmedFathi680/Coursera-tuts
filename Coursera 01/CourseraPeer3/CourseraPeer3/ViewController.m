//
//  ViewController.m
//  CourseraPeer3
//
//  Created by Ahmed Fathi on 6/24/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"

@interface ViewController () <CRCurrencyRequestDelegate>

@property (nonatomic) CRCurrencyRequest *currencyRequest;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *resultLbl;

@end

@implementation ViewController

@synthesize inputTF=_inputTF;
@synthesize convertBtn=_convertBtn;
@synthesize segmentedControl=_segmentedControl;
@synthesize resultLbl=_resultLbl;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _convertBtn.layer.cornerRadius = 9;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)convert:(UIButton *)sender {
    _convertBtn.enabled = NO;
    _currencyRequest = [[CRCurrencyRequest alloc] init];
    _currencyRequest.delegate = self;
    [_currencyRequest start];
    
}

- (void)currencyRequest:(CRCurrencyRequest *)req retrievedCurrencies:(CRCurrencyResults *)currencies {
    double value = [_inputTF.text doubleValue];
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0: //EURO
            value *= currencies.EUR;
            break;
        case 1: //YEN
            value *= currencies.JPY;
            break;
        case 2: //GBP
            value *= currencies.GBP;
        default:
            break;
    }
    _resultLbl.text = [NSString stringWithFormat:@"%.2f", value];
    _convertBtn.enabled = YES;
}

@end
