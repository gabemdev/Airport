//
//  AirportKit.m
//  Airport
//
//  Created by Rockstar. on 4/14/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AirportKit.h"
#import "Constants.h"

@implementation AirportKit

+ (void)nearbyAirportsForLongitude:(float)longitude andLatitude:(float)latitude successCallback:(void (^)(id))successCallback errorCallback:(void (^)(NSString *))errorCallback {
    NSString *longitudeString = [NSString stringWithFormat:@"%f", longitude];
    NSString *latitudeString = [NSString stringWithFormat:@"%f", latitude];
    NSString *requestString = [NSString stringWithFormat:@"%@%@/%@?%@=%@&%@=%@", AIRPORT_SERVICE_BASE_URL, latitudeString, longitudeString, USER_KEY_NAME, USER_KEY_VALUE, MAX_AIRPORTS_NAME, MAX_AIRPORTS_VALUE];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

    }];
}

@end
