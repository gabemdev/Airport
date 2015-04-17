//
//  ViewController.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "AirportDetailViewController.h"


@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property CLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Airport"]];
    [self setupUI];
    [self initLocation];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


#pragma mark - Helper Methods
- (void)setupUI {
    self.showButton.hidden = YES;
    self.showButton.layer.cornerRadius = 15;
    self.zipTextField.backgroundColor = [UIColor clearColor];
}

#pragma mark - CLLocationManagerDelegate

- (void)initLocation {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.activityIndicator startAnimating];
    self.mainLabel.text = @"Finding your Zipcode, please wait...";

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 500 && location.verticalAccuracy < 500) {
            self.userLocation = location;
            [self.activityIndicator stopAnimating];
            [self reverseGeocodeLocation:location];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to get your location"
                                                                   message:@"Please make sure you have enabled location in your device settings"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reverseGeocodeLocation:(CLLocation *)location {
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.placemark = placemarks.firstObject;
            self.mainLabel.text = [NSString stringWithFormat:@"Hooray!, Your zipcode is:"];
            self.zipTextField.text = [NSString stringWithFormat:@"%@", self.placemark.postalCode];
            self.showButton.hidden = NO;
//            NSLog(@"User lat: %f & user long: %f", location.coordinate.latitude, location.coordinate.longitude);
        }
    }];
}


- (void)loadNearbyAirports {
    
}

#pragma mark - Actions

- (void)searchZip:(id)sender {
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:self.zipTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error!");
        } else {
            CLPlacemark *placemark = placemarks.firstObject;
            self.userLocation = placemark.location;
            CLLocationCoordinate2D coordinate = self.userLocation.coordinate;
            NSLog(@"%f %f", coordinate.latitude, coordinate.longitude);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowList"]) {
        AirportDetailViewController *vc = segue.destinationViewController;
        vc.selected = self.placemark;
    }
}

@end
