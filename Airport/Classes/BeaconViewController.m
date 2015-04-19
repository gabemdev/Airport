//
//  BeaconViewController.m
//  Airport
//
//  Created by Rockstar. on 4/17/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "BeaconViewController.h"
@import CoreLocation;
@import CoreBluetooth;

@interface BeaconViewController ()<CLLocationManagerDelegate>
//@property (strong, nonatomic) CLBeaconRegion *kitchen;
//@property (strong, nonatomic) CLBeaconRegion *room1;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@end

@implementation BeaconViewController
NSUUID *kitchenuuid;
NSUUID *room1uuid;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initRegions];
}

- (void)initRegions {

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    kitchenuuid = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF600"];
    room1uuid = [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"];

    CLBeaconRegion *kitchen = [[CLBeaconRegion alloc] initWithProximityUUID:kitchenuuid identifier:@"Kitchen"];
    kitchen.notifyOnEntry = YES;
    kitchen.notifyOnExit = YES;
    kitchen.notifyEntryStateOnDisplay = YES;

    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        [self.locationManager startRangingBeaconsInRegion:kitchen];
        [self.locationManager startMonitoringForRegion:kitchen];
    }

    CLBeaconRegion *room1 = [[CLBeaconRegion alloc] initWithProximityUUID:room1uuid identifier:@"Room 1"];
    room1.notifyOnEntry = YES;
    room1.notifyOnExit = YES;
    room1.notifyEntryStateOnDisplay = YES;

    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        [self.locationManager startMonitoringForRegion:room1];
        [self.locationManager startRangingBeaconsInRegion:room1];
    }


}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:kitchenuuid]) {
            self.title = @"Kitchen";
        } else if ([beaconRegion.proximityUUID isEqual:room1uuid]) {
            self.title = @"Room 1";
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:kitchenuuid]) {
            NSLog(@"Left Kitchen");
        } else if ([beaconRegion.proximityUUID isEqual:room1uuid]) {
            NSLog(@"Room 1 left");
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        for (CLBeacon *beacon in beacons) {
            NSString *beaconID = [beacons objectAtIndex:0];
            NSLog(@"UUID: %@", beacon.proximityUUID.UUIDString);

            if ([region.proximityUUID isEqual:kitchenuuid]) {
                if (beacon.accuracy >=0.000001 && beacon.accuracy <= 0.500000) {
                    self.locationLabel.text = @"Kitcken";
                }
            } else if ([region.proximityUUID isEqual:room1uuid]) {
                if (beacon.accuracy >=0.000001 && beacon.accuracy <= 0.500000) {
                    self.locationLabel.text = @"Room 1";
                }
            }
            self.uuidLabel.text = beacon.proximityUUID.UUIDString;
            self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
            self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
            self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
            if (beacon.proximity == CLProximityUnknown) {
                self.proximityLabel.text = @"Unknown Proximity";
            } else if (beacon.proximity == CLProximityImmediate) {
                self.proximityLabel.text = @"Immediate";
            } else if (beacon.proximity == CLProximityNear) {
                self.proximityLabel.text = @"Near";
            } else if (beacon.proximity == CLProximityFar) {
                self.proximityLabel.text = @"Far";
            }
            self.rssiLabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
        }
    }
}


@end
