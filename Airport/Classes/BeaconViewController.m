//
//  BeaconViewController.m
//  Airport
//
//  Created by Rockstar. on 4/17/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "BeaconViewController.h"
#import "Beacons.h"
@import CoreLocation;
@import CoreBluetooth;

@interface BeaconViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *kitchen;
@property (strong, nonatomic) CLBeaconRegion *room1;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indoorMap;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property NSString *location;

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"arches"]]];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }

    [self initRegion];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startRangingBeaconsInRegion:self.kitchen];
    [self.locationManager startRangingBeaconsInRegion:self.room1];
}

#pragma mark - CLLocationManagerDelegate
/**
 *  Load beacon Regions. Set Identifiers per beacon UUID;
 */
- (void)initRegion {
    NSUUID *kitchenuuid = [Beacons sharedBeacons].kitckenUUID;
    NSUUID *room1uuid = [Beacons sharedBeacons].room1UUID;

    self.kitchen = [[CLBeaconRegion alloc] initWithProximityUUID:kitchenuuid identifier:@"Kitchen"];
    self.kitchen.notifyOnEntry = YES;
    self.kitchen.notifyOnExit = YES;
    self.kitchen.notifyEntryStateOnDisplay = YES;
    [self.locationManager startRangingBeaconsInRegion:self.kitchen];
    [self.locationManager startMonitoringForRegion:self.kitchen];

    self.room1 = [[CLBeaconRegion alloc] initWithProximityUUID:room1uuid identifier:@"Room 1"];
    self.room1.notifyOnEntry = YES;
    self.room1.notifyOnExit = YES;
    self.room1.notifyEntryStateOnDisplay = YES;
    [self.locationManager startRangingBeaconsInRegion:self.room1];
    [self.locationManager startMonitoringForRegion:self.room1];

    [self.locationManager startUpdatingLocation];
}

/**
 *  Enter Region. If region matches uuid, display title accordingly.
 *
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];

    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.proximityUUID isEqual:[Beacons sharedBeacons].kitckenUUID]) {
            self.locationLabel.text = @"Kitchen";
        } else if ([beaconRegion.proximityUUID isEqual:[Beacons sharedBeacons].room1UUID]) {
            self.locationLabel.text = @"Room 1";
        }
}


/**
 *  Exit Region. Stop Ranging and Stop updating location
 *
 */
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
}

/**
 *  Beacon Found. Obtain beacon info and display it.
 *
 */
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        if ([region.proximityUUID isEqual:[Beacons sharedBeacons].kitckenUUID]) {
            if (beacon.accuracy >=0.000001 && beacon.accuracy <= 0.500000) {
                self.indoorMap.image = [UIImage imageNamed:@"bottomFloor"];
            }
        } else if ([region.proximityUUID isEqual:[Beacons sharedBeacons].room1UUID]) {
            if (beacon.accuracy >=0.000001 && beacon.accuracy <= 0.500000) {
                self.indoorMap.image = [UIImage imageNamed:@"topFloor"];
            }
        }
        self.uuidLabel.text = beacon.proximityUUID.UUIDString;
        self.locationLabel.text = region.identifier;
        self.accuracyLabel.text = [NSString stringWithFormat:@"Accuracy: %.2f", beacon.accuracy];
        if (beacon.proximity == CLProximityUnknown) {
            self.location = @"are lost.. you are going to";
        } else if (beacon.proximity == CLProximityImmediate) {
            self.location = @"have arrived at";
        } else if (beacon.proximity == CLProximityNear) {
            self.location = @"are a few steps from";
        } else if (beacon.proximity == CLProximityFar) {
            self.location = @"are still far from";
        }
        self.locationLabel.text = [NSString stringWithFormat:@"You %@ %@", self.location, region.identifier];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    /*
     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
     */
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    if(state == CLRegionStateInside)
    {
        notification.alertBody = NSLocalizedString(@"You're inside the region", @"");
    }
    else if(state == CLRegionStateOutside)
    {
        notification.alertBody = NSLocalizedString(@"You're outside the region", @"");
    }
    else
    {
        return;
    }

    /*
     If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
     If it's not, iOS will display the notification to the user.
     */
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - Heading
/**
 *  Get heading.
 *
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;

    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);

    float mHeading = theHeading;
    NSString *heading;

    if ((mHeading >= 339) || (mHeading <= 22)) {

        heading = @"North";
    }
    else if ((mHeading > 23) && (mHeading <= 68)) {
        heading = @"North Eeast";
    }
    else if ((mHeading > 69) && (mHeading <= 113)) {
        heading = @"East";
    }
    else if ((mHeading > 114) && (mHeading <= 158)) {
        heading = @"South East";
    }
    else if ((mHeading > 159) && (mHeading <= 203)) {
        heading = @"South";
    }
    else if ((mHeading > 204) && (mHeading <= 248)) {
        heading = @"South West";
    }
    else if ((mHeading > 249) && (mHeading <= 293)) {
        heading = @"West";
    }
    else if ((mHeading > 294) && (mHeading <= 338)) {
        heading = @"North West";
    }

    self.headingLabel.text = [NSString stringWithFormat:@"%@", heading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

@end
