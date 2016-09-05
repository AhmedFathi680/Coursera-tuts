//
//  ViewController.m
//  PeerReview303
//
//  Created by Ahmed Fathi on 7/8/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"

enum {
    cairo = 0,
    alexandria,
    hurghada
};

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray<MKPointAnnotation *> *annotations;
@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL mapIsUnderUserControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapIsUnderUserControl = NO;

    [self addAnnotations];

    // add location manager to start tracking the device
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}


#pragma mark - UI Actions handlers

- (IBAction)cairoTapped:(id)sender {
    // switch the button off
    [self.switchButton setOn:NO animated:YES];
    
    // stop the location manager for sending the updates
    [self tracking:NO];
    
    // center map on Cairo annotation
    [self centerMap:self.annotations[cairo]];
}

- (IBAction)alexandriaTapped:(id)sender {
    [self.switchButton setOn:NO animated:YES];
    [self tracking:NO];
    [self centerMap:self.annotations[alexandria]];
}

- (IBAction)hurghadaTapped:(id)sender {
    [self.switchButton setOn:NO animated:YES];
    [self tracking:NO];
    [self centerMap:self.annotations[hurghada]];
}

- (IBAction)locateMeSwitched:(id)sender {
    [self tracking:self.switchButton.isOn];
}


#pragma mark - CLLocationManagerDelegate Functions

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    // create the point
    self.currentAnnotation = [self createAnnotation:@"Current" latitude:0.0 longitude:0.0];
    
    // update the coordinate from the location manager
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    
    // center the map on the new location
    if (!self.mapIsUnderUserControl) {
        [self centerMap:self.currentAnnotation];
    }
}

#pragma mark - MKMapViewDelegate Functions

- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsUnderUserControl = YES;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsUnderUserControl = NO;
}

#pragma mark - Helper Functions

// Creates the point with title and latitude and longitude
- (MKPointAnnotation *) createAnnotation:(NSString *)title latitude:(double)latitude longitude:(double)longitude {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = title;
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return annotation;
}

// Center the map on given MKPointAnnotation
- (void) centerMap:(MKPointAnnotation *)centerPoint {
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

- (void) addAnnotations {
    // 30.0595581 31.2234449 Cairo
    // 31.2242387 29.8848460 Alexandria
    // 27.1927403 33.6416263 Hurghada
    
    // Create Array of Three Point Annotations
    self.annotations = @[ [self createAnnotation:@"Cairo" latitude:30.0595581 longitude:31.2234449],
                          [self createAnnotation:@"Alexandria" latitude:31.2242387 longitude:29.8848460],
                          [self createAnnotation:@"Hurghada" latitude:27.1927403 longitude:33.6416263]];
    
    // Add these Annotations to the map view
    [self.mapView addAnnotations:self.annotations];
}

- (void) tracking:(BOOL)on {
    // decide whether the location manager should update the user location
    if (on) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    } else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

@end
