//
//  ViewController.m
//  PeerReview301
//
//  Created by Ahmed Fathi on 7/5/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load URL on webView
    NSString *webURL = @"https://www.apple.com";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:webURL]];
    [self.webView loadRequest:request];
    
    
    MKPointAnnotation *appleAnno = [[MKPointAnnotation alloc] init];
    appleAnno.coordinate = CLLocationCoordinate2DMake(37.3314229, -122.0325976);
    appleAnno.title = @"Apple";
    [self.mapView addAnnotation:appleAnno];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(appleAnno.coordinate, 10000, 10000);
    MKCoordinateRegion adjusted = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjusted animated:YES];
}

@end
