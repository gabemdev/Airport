//
//  SelectedDetailViewController.m
//  Airport
//
//  Created by Rockstar. on 4/15/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "SelectedDetailViewController.h"
#import <MapKit/MapKit.h>

@interface SelectedDetailViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMapButton;
@property CLLocationManager *locationManager;
@property MKRoute *destinationRoute;
@property MKPointAnnotation *airportAnnotation;

@end

@implementation SelectedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAirportInfo];

    self.mapView.delegate = self;
    self.airportAnnotation = [MKPointAnnotation new];

    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = self.airport.mapItem.placemark.location.coordinate;
    annotation.title = self.airport.mapItem.name;

    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.airport.mapItem.placemark.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];

    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotation:annotation];
    // Do any additional setup after loading the view.
}

#pragma mark - MapKitDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CLLocationCoordinate2D pin = view.annotation.coordinate;
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pin addressDictionary:nil];
    MKMapItem *destItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    request.destination = destItem;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.destinationRoute = response.routes.lastObject;
            [self.mapView addOverlay:self.destinationRoute.polyline level:MKOverlayLevelAboveRoads];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    Airport *newAnnotation = annotation;
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.image = [UIImage imageNamed:@"FindARide_MapUI_Pin_EndPin"];
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView.tintColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.76 alpha:1.0];
    newAnnotation.title = annotation.title;
    return pin;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *rendered = [[MKPolylineRenderer alloc] initWithPolyline:route];
        rendered.strokeColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.76 alpha:1.00];
        rendered.lineWidth = 5.0;
        return rendered;
    }
    else {
        return nil;
    }
}

#pragma mark - Accessor Methods

- (void)loadAirportInfo {
    self.nameLabel.text = self.airport.locationName;
    self.addressLabel.text = self.airport.locationAddress;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f MI", self.airport.locationDistance];
    self.showMapButton.layer.cornerRadius = 15;
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end