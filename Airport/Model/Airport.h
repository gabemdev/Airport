//
//  Airport.h
//  Airport
//
//  Created by Rockstar. on 4/15/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Airport : MKPointAnnotation

@property MKPointAnnotation *pointAnnotation;
@property CLLocationDistance locationDistance;
@property MKMapItem *mapItem;
@property NSString *locationAddress;
@property NSString *locationName;
@property MKRoute *routeDetails;
@property MKPlacemark *placemark;
@property NSString *rating;

@end
