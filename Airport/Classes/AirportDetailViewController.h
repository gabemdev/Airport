//
//  AirportDetailViewController.h
//  Airport
//
//  Created by Rockstar. on 4/15/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airport.h"
#import <MapKit/MapKit.h>

@class Airport;
@interface AirportDetailViewController : UIViewController

@property Airport *selectedAirport;
@property CLPlacemark *selected;

@end
