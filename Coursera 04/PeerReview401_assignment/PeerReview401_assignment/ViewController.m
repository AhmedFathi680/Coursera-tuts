//
//  ViewController.m
//  PeerReview401_assignment
//
//  Created by Ahmed Fathi on 7/21/16.
//  Copyright © 2016 company.com. All rights reserved.
//


#import "ViewController.h"
#import "MapKit/MapKit.h"


@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *turnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) MKPointAnnotation *currentAnnotation;
@property (strong, nonatomic) MKPointAnnotation *maxStoreAnnotation;

@property (assign, nonatomic) BOOL mapIsMoving;

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
    
    // set UI initial values
    self.turnSwitch.enabled = NO;
    self.statusLabel.text = @"";
    
    
    self.mapIsMoving = NO;

    
    
    // create the locationManager
    self.locationManager = [self createLocationManager:self distanceFilter:7];
    
    
    
    // zoom map very close
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.maxStoreAnnotation.coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    
    
    // add annotation for target (MAX store)
    self.maxStoreAnnotation = [[MKPointAnnotation alloc] init];
    self.maxStoreAnnotation.coordinate = CLLocationCoordinate2DMake(30.039415, 31.217749);
    self.maxStoreAnnotation.title = @"MAX Store";
    [self.mapView addAnnotation:self.maxStoreAnnotation];
    
    
    
    // center the map on target (MAX store)
    [self.mapView setCenterCoordinate:self.maxStoreAnnotation.coordinate animated:YES];
    
    
    
    // setup the geoRegion
    self.geoRegion = [[CLCircularRegion alloc]
                      initWithCenter:self.maxStoreAnnotation.coordinate radius:10 identifier:@"MAXStoreRegion"];

    
    
    // create current annotation to keep track of the user movement
    self.currentAnnotation = [self createAnnotationWithTitle:@"My Location" andLatitude:0.0 andLongitude:0.0];
    
    
    
    
    // check if device can do geofence
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        
        // check if the app have permission
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
            self.turnSwitch.enabled = YES;
        
        } else {
            // ask for permission
            [self.locationManager requestAlwaysAuthorization];
        }
        
        // request User Notification Permission
        [self requestUserNotificationPermission];
        
    }
    
}








#pragma mark - CLLocationManagerDelegate



// in case the user turned on/off the authorization status from the settings
- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        self.turnSwitch.enabled = YES;
    }
}



-  (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    if (self.mapIsMoving == NO) {
        [self.mapView setCenterCoordinate:self.currentAnnotation.coordinate];
    }
}



// detect geoRegion changes
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {

    
    self.statusLabel.text = @"Inside";
    
    // send notification with coupon code
    UILocalNotification *couponCode = [[UILocalNotification alloc] init];
    couponCode.fireDate = nil;
    couponCode.timeZone = nil;
    couponCode.repeatInterval = 0;
    
    couponCode.alertTitle = @"Congratulation! 30 off";
    couponCode.alertBody = @"MAX just give you 30 off on 3 items for next 30 minutes!\nMAX store is 10 meters away!\nCoupon code: 3FH25ASF";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:couponCode];

    
    // send notification with epiration of the coupon code
    UILocalNotification *couponCodeExpired = [[UILocalNotification alloc] init];
    couponCodeExpired.fireDate = [[NSDate date] dateByAddingTimeInterval:1800]; // 30 Minutes
    couponCodeExpired.timeZone = nil;
    couponCodeExpired.repeatInterval = 0;
    
    couponCodeExpired.alertTitle = @"You just missed 30 off";
    couponCodeExpired.alertBody = @"You are not away from MAX!\nGood luck next time.";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:couponCodeExpired];
    
}


- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    self.statusLabel.text = @"Outside";
    
}








#pragma mark - MKMapViewDelegate


- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}



- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}



// Customizing PinView
// Change its color to blue instead of red (not required for this assignment)
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // generic ID (static so it cannot be changed once ceated in this method
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (!pinView) {
        
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

        pinView.pinTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.9];
        
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;

}
*/





#pragma mark - UI Actions


- (IBAction)turnSwitched:(id)sender {
    if (self.turnSwitch.isOn) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringForRegion:self.geoRegion];
    } else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopMonitoringForRegion:self.geoRegion];
    }
}








#pragma mark - Helper Functions

- (CLLocationManager *) createLocationManager:(UIViewController<CLLocationManagerDelegate> *)delegate
                               distanceFilter:(CLLocationDistance)distanceFilter {
 
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = delegate;
    locationManager.allowsBackgroundLocationUpdates = YES;
    locationManager.pausesLocationUpdatesAutomatically = YES;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = distanceFilter;
    return locationManager;
}


// ask for UserNotificationPermission
- (void) requestUserNotificationPermission {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}


// create annotation
- (MKPointAnnotation *) createAnnotationWithTitle:(NSString *)title
                                      andLatitude:(CLLocationDegrees)latitude
                                     andLongitude:(CLLocationDegrees)longitude {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = title;
    return annotation;
}


@end























