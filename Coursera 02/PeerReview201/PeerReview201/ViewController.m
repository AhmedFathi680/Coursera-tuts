//
//  ViewController.m
//  PeerReview201
//
//  Created by Ahmed Fathi on 6/27/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
// private properties
@property (weak, nonatomic) IBOutlet UITextView *twitterTextView;
@property (weak, nonatomic) IBOutlet UITextView *facebookTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreActivitiesTextView;

// private helper functions
- (void) configureTextView:(UITextView *)textView withRed:(float)red andGreen:(float)green andBlue:(float)blue forAlpha:(float)alpha;
- (void) closeKeyboardResonseFor:(UITextView *) target;
- (void) showAlertMessageOn:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureTextView:self.twitterTextView withRed:1.0 andGreen:0.7 andBlue:0.9 forAlpha:1.0];
    [self configureTextView:self.facebookTextView withRed:0.7 andGreen:0.9 andBlue:1.0 forAlpha:1.0];
    [self configureTextView:self.moreActivitiesTextView withRed:0.9 andGreen:1.0 andBlue:0.7 forAlpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my bottons tapped

- (IBAction)twitterShareTapped:(id)sender {
    [self closeKeyboardResonseFor:self.twitterTextView];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if ([self.twitterTextView.text length] < 140)
            [twitterVC setInitialText:self.twitterTextView.text];
        else
            [twitterVC setInitialText:[self.twitterTextView.text substringToIndex:140]];
        [self presentViewController:twitterVC animated:YES completion:nil];
    } else {
        [self showAlertMessageOn:self withTitle:@"Sorry!" andMessage:@"You're not signed in to Twitter!"];
    }
}

- (IBAction)facebookShareTapped:(id)sender {
    [self closeKeyboardResonseFor:self.facebookTextView];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookVC setInitialText:self.facebookTextView.text];
        
        [self presentViewController:facebookVC animated:YES completion:nil];
    } else {
        [self showAlertMessageOn:self withTitle:@"Sorry" andMessage:@"You're not signed in to Facebook"];
    }
}

- (IBAction)moreActivitiesTapped:(id)sender {
    [self closeKeyboardResonseFor:self.moreActivitiesTextView];
    
    UIActivityViewController *moreActivitiesVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.moreActivitiesTextView.text] applicationActivities:nil];
    
    [self presentViewController:moreActivitiesVC animated:YES completion:nil];
    
}

- (IBAction)dummyTapped:(id)sender {
    [self showAlertMessageOn:self withTitle:@"Dummy" andMessage:@"This has no functionality"];
}

#pragma mark - helper functions

- (void) configureTextView:(UITextView *)textView withRed:(float)red andGreen:(float)green andBlue:(float)blue forAlpha:(float)alpha {
    textView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
    textView.layer.cornerRadius = 10.0;
    textView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
    textView.layer.borderWidth = 2.0;
}

- (void) closeKeyboardResonseFor:(UITextView *)target {
    if ([target isFirstResponder]) [target resignFirstResponder];
}

- (void) showAlertMessageOn:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
