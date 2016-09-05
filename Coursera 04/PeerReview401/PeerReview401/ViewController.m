//
//  ViewController.m
//  PeerReview401_PracticeMod3
//
//  Created by Ahmed Fathi on 7/20/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>



@property (weak, nonatomic) IBOutlet MKMapView *mapView;
// toolbar UI
@property (weak, nonatomic) IBOutlet UISwitch *activateSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refershButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) BOOL mapIsMoving;

@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;

@property (strong, nonatomic) CLCircularRegion *geoRegion;



@end





@implementation ViewController

/*
 there was two edits in info.plist

 NSLacationAlwaysUsageDescription <string> (Location is used for bla bla bla)

 UIBackgroundModes <array>
    > item 0 <string> (location)
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    // set initials for UI
    self.activateSwitch.enabled = NO;
    self.refershButton.enabled = NO;
    self.statusLabel.text = @"";
    self.eventLabel.text = @"";
    self.mapIsMoving = NO;
    
    
    
    
    // setup the location manager
    self.locationManager = [self createLocationManager:self distanceFilter:3];
    
    
    
    
    
    // Zoom the map very close
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
 
    
    
    
    
    // Create the annotation to keep track of the user moving
    self.currentAnnotation = [self createAnnotationWithTitle:@"My Location" andLatitude:0.0 andLongitude:0.0];
 
   
    
    
    // Create the geoRegion
    self.geoRegion = [[CLCircularRegion alloc]
                      initWithCenter:CLLocationCoordinate2DMake(30.040232, 31.219548) radius:3 identifier:@"MyRegionIdentifier"];
    
    
    
    
    // check if the device can do geofence
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES) {
        
        // check if we have permission or not
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            self.activateSwitch.enabled = YES;
        } else {
            // ask for permission
            [self.locationManager requestAlwaysAuthorization];
        }
        
        
        // request user notification permission
        [self requestUserNotificationPermission];
    }
}







#pragma mark - CLLocationManagerDelegate


- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // this is the current status >>> [CLLocationManager authorizationStatus]
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.activateSwitch.enabled = YES;
    }
}



- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    if (self.mapIsMoving == NO) {
        [self.mapView setCenterCoordinate:self.currentAnnotation.coordinate animated:YES];
    }
}



// GeoFence Functions
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"GeoFence Alert!";
    note.alertBody = @"You entered the geofence";
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    
    self.eventLabel.text = @"Entered";
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"GeoFence Alert!";
    note.alertBody = @"You left the geofence";
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    self.eventLabel.text = @"Exited";
}

// GeoFence: ask state for a region
- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(nonnull CLRegion *)region {
    if (state == CLRegionStateUnknown) {
        self.statusLabel.text = @"Unknwon";
    } else if (state == CLRegionStateInside) {
        self.statusLabel.text = @"Inside";
    } else if (state == CLRegionStateOutside) {
        self.statusLabel.text = @"Outside";
    }
}





#pragma mark - MKMapViewDelegate


- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}


- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}





#pragma mark - Actions


- (IBAction)activatedSwitched:(id)sender {
    if (self.activateSwitch.isOn) {
        // start tracking movement
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        
        // start monitoring geoRegion
        [self.locationManager startMonitoringForRegion:self.geoRegion];
        
        self.refershButton.enabled = YES;
    } else {
        // stop tracking movment
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        
        // stop monitoring geoRegion
        [self.locationManager stopMonitoringForRegion:self.geoRegion];
        
        self.refershButton.enabled = NO;
    }
}



- (IBAction)refreshTapped:(id)sender {
    [self.locationManager requestStateForRegion:self.geoRegion];
}







#pragma mark - Helper Funtions



- (CLLocationManager *) createLocationManager:(UIViewController<CLLocationManagerDelegate> *)delegate
                               distanceFilter:(CLLocationDistance)distanceFilter {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = delegate;
    locationManager.allowsBackgroundLocationUpdates = YES;
    locationManager.pausesLocationUpdatesAutomatically = YES; // reduce batter usage
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = distanceFilter; // meters
    return locationManager;
}





// create point annotation in specific latitude & longitude
- (MKPointAnnotation *) createAnnotationWithTitle:(NSString *)title
                                      andLatitude:(CLLocationDegrees) latitude
                                     andLongitude:(CLLocationDegrees)longitude {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = title;
    return annotation;
}



// ask for UserNotificationPermission
- (void) requestUserNotificationPermission {
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}



@end
































