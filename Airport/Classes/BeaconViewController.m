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
@property (strong, nonatomic) CLBeaconRegion *kitchen;
@property (strong, nonatomic) CLBeaconRegion *room1;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self initRegions];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.kitchen];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.room1];
    
}

//- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//}

- (void)initRegions {
    NSUUID *kitchenuuid = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF600"];
    NSUUID *room1uuid = [[NSUUID alloc] initWithUUIDString:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"];
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Kitchen"];
//    [self.locationManager startMonitoringForRegion:self.beaconRegion];

    self.kitchen = [[CLBeaconRegion alloc] initWithProximityUUID:kitchenuuid identifier:@"Kitchen"];
    self.kitchen.notifyOnEntry = YES;
    self.kitchen.notifyOnExit = YES;
    self.kitchen.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:self.kitchen];

//    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
//        [self.locationManager startRangingBeaconsInRegion:self.kitchen];
//        [self.locationManager startMonitoringForRegion:self.kitchen];
//    }

    self.room1 = [[CLBeaconRegion alloc] initWithProximityUUID:room1uuid identifier:@"Room 1"];
    self.room1.notifyOnEntry = YES;
    self.room1.notifyOnExit = YES;
    self.room1.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:self.room1];

//    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
//        [self.locationManager startMonitoringForRegion:self.room1];
//        [self.locationManager startRangingBeaconsInRegion:self.room1];
//    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    self.title = @"Region Entered";

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:@"EBEFD083-70A2-47C8-9837-E7B5634DF600"]) {
            self.title = @"Kitchen";
        } else if ([beaconRegion.proximityUUID isEqual:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"]) {
            self.title = @"Room 1";
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
//    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
//    self.title = @"Region Exited";
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:@"EBEFD083-70A2-47C8-9837-E7B5634DF600"]) {
            NSLog(@"Left Kitchen");
        } else if ([beaconRegion.proximityUUID isEqual:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"]) {
            NSLog(@"Room 1 left");
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
//    CLBeacon *beacon = [[CLBeacon alloc] init];
//    beacon = [beacons lastObject];
//
//    self.uuidLabel.text = beacon.proximityUUID.UUIDString;
//    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
//    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
//    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
//    if (beacon.proximity == CLProximityUnknown) {
//        self.proximityLabel.text = @"Unknown Proximity";
//    } else if (beacon.proximity == CLProximityImmediate) {
//        self.proximityLabel.text = @"Immediate";
//    } else if (beacon.proximity == CLProximityNear) {
//        self.proximityLabel.text = @"Near";
//    } else if (beacon.proximity == CLProximityFar) {
//        self.proximityLabel.text = @"Far";
//    }
//    self.rssiLabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];


    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        for (CLBeacon *beacon in beacons) {
            if ([region.proximityUUID isEqual:@"EBEFD083-70A2-47C8-9837-E7B5634DF600"]) {
                self.locationLabel.text = @"Kitchen";
            } else if ([region.proximityUUID isEqual:@"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"]) {
                self.locationLabel.text = @"Room 1";
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
