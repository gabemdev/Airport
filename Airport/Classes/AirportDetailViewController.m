//
//  AirportDetailViewController.m
//  Airport
//
//  Created by Rockstar. on 4/15/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AirportDetailViewController.h"
#import "SelectedDetailViewController.h"
#import <MapKit/MapKit.h>
#import "CustomTableViewCell.h"
#import "AirportKit.h"
#import "Airport.h"

@interface AirportDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *airportArray;
@property (weak, nonatomic) IBOutlet UITableView *airportTableView;
@property Airport *mainAirport;

@end

@implementation AirportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"arches"]]];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Airport List"]];
    self.airportArray = [NSMutableArray new];
    CLLocation *selected = [[CLLocation alloc] initWithLatitude:self.selected.location.coordinate.latitude longitude:self.selected.location.coordinate.longitude];
    [self findAirportsNear: selected];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.airportTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.airportArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Airport *airport = self.airportArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", airport.mapItem.name];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@", airport.locationAddress];
    cell.millesLabel.text = [NSString stringWithFormat:@"%.2f MI", airport.locationDistance];
    return cell;
}

#pragma mark - Helper Methods

- (void)findAirportsNear:(CLLocation *)location {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Airport";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.09, .09));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];

            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSArray *airports = response.mapItems;
            for (MKMapItem *item in airports) {
                self.mainAirport = [Airport new];
                self.mainAirport.mapItem = item;
                NSString *address = [NSString stringWithFormat:@"%@ %@ %@,%@ %@",item.placemark.subThoroughfare, item.placemark.thoroughfare, item.placemark.locality, item.placemark.administrativeArea, item.placemark.postalCode];
                NSString *name = [NSString stringWithFormat:@"%@", item.placemark.name];
                self.mainAirport.areasOfInterest = item.placemark.areasOfInterest;
                self.mainAirport.locationName = name;
                self.mainAirport.locationAddress = address;
                self.mainAirport.locationCity = item.placemark.locality;
                self.mainAirport.locationState = item.placemark.administrativeArea;
                self.mainAirport.locationZip = item.placemark.postalCode;
                self.mainAirport.locationURL = [NSString stringWithFormat:@"%@", item.url];
                self.mainAirport.locationPhoneNumber = item.phoneNumber;
                self.mainAirport.locationDistance = [self.mainAirport.mapItem.placemark.location distanceFromLocation:location]/1000;
                self.mainAirport.placemark = item.placemark;
                [self.airportArray addObject:self.mainAirport];
            }
        }

        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"locationDistance" ascending:YES];
        NSArray *sorted = [self.airportArray sortedArrayUsingDescriptors:@[sort]];
        self.airportArray = [NSMutableArray arrayWithArray:sorted];
        [self.airportTableView reloadData];
    }];

}


#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    SelectedDetailViewController *vc = segue.destinationViewController;
    vc.airport = self.airportArray[[[self.airportTableView indexPathForCell:sender] row]];
}






@end
