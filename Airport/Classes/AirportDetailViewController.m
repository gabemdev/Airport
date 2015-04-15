//
//  AirportDetailViewController.m
//  Airport
//
//  Created by Rockstar. on 4/15/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AirportDetailViewController.h"
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
    NSLog(@"Placemark: %f", self.selected.location.coordinate.latitude);
    self.airportArray = [NSMutableArray new];
    CLLocation *selected = [[CLLocation alloc] initWithLatitude:self.selected.location.coordinate.latitude longitude:self.selected.location.coordinate.longitude];
    [self findAirportsNear: selected];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.airportArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Airport *airport = self.airportArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", airport.mapItem.name];
    return cell;
}


- (void)findAirportsNear:(CLLocation *)location {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Airport";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *airports = response.mapItems;
        for (MKMapItem *item in airports) {
            self.mainAirport = [Airport new];
            self.mainAirport.mapItem = item;
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@", item.placemark.subThoroughfare, item.placemark.thoroughfare, item.placemark.locality];
            NSString *name = [NSString stringWithFormat:@"%@", item.placemark.name];
            self.mainAirport.locationName = name;
            self.mainAirport.locationAddress = address;
            self.mainAirport.locationDistance = [self.mainAirport.mapItem.placemark.location distanceFromLocation:location]/1000;
            self.mainAirport.placemark = item.placemark;
            [self.airportArray addObject:self.mainAirport];
        }

        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"locationDistance" ascending:YES];
        NSArray *sorted = [self.airportArray sortedArrayUsingDescriptors:@[sort]];
        self.airportArray = [NSMutableArray arrayWithArray:sorted];
        [self.airportTableView reloadData];
    }];
}


@end
