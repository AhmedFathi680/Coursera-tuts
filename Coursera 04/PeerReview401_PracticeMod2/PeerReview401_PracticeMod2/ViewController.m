//
//  ViewController.m
//  PeerReview401_PracticeMod2
//
//  Created by Ahmed Fathi on 7/20/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (weak, nonatomic) IBOutlet UILabel *reverseGeocodeLabel;

@property (strong, nonatomic) CLGeocoder *geocoder;

// flag if we already making online request (looking up for new CLPLacemark)
@property (assign, nonatomic) BOOL lookingUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initial the geocoder
    self.geocoder = [[CLGeocoder alloc] init];
    
    // initial the UI elements
    self.reverseGeocodeLabel.text = nil;
    self.reverseGeocodeLabel.alpha = 0.5;
    
    self.lookingUp = NO;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self executeTheLookUp];
}


#pragma mark - Private methods

- (void)executeTheLookUp {
    if (self.lookingUp == NO) {
        self.lookingUp = YES;
        CLLocationCoordinate2D coordinate = [self locationAtCenterOfMapView];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self startReverseGeocodeLocation:location];
    }
}

// return coordinate of the center of the map (anchor of the pin)
- (CLLocationCoordinate2D) locationAtCenterOfMapView {
    
    CGPoint anchorOfPin = CGPointMake(CGRectGetMidX(self.pinIcon.bounds), CGRectGetMidY(self.pinIcon.bounds));
    
    // convert the x and y of the mapView to a latitude and longitude
    return [self.mapView convertPoint:anchorOfPin toCoordinateFromView:self.pinIcon];
}

- (void)startReverseGeocodeLocation:(CLLocation *)location {
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         // check for errors
         if (error) {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"There was a problem reverse geocodeing." message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:alert animated:YES completion:nil];
             return;
         }
         
         // Grab CLPlacemarks and show it
         // but with no duplicates
         NSMutableSet *mappedPlaceDescs = [NSMutableSet new];
         
         // for each placemark add description -> (name, area and country)
         // there are a lot of properties like zipcode etc.. choose what you want to grab.
         for (CLPlacemark *placemark in placemarks) {
             if (placemark.name != nil)
                 [mappedPlaceDescs addObject:placemark.name];
             if (placemark.administrativeArea != nil)
                 [mappedPlaceDescs addObject:placemark.administrativeArea];
             if (placemark.country != nil)
                 [mappedPlaceDescs addObject:placemark.country];
         }
         
         // make string and display on the label
         self.reverseGeocodeLabel.text = [[mappedPlaceDescs allObjects] componentsJoinedByString:@"\n"];
         self.reverseGeocodeLabel.alpha = 1.0;
         self.lookingUp = NO;
     }];
    
}

@end













