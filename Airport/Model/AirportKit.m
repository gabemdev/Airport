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

+ (void)getNearbyAirportsWithLong:(float)longitude andLat:(float)latitude {
    NSString *urlString = [NSString stringWithFormat:@"https://airport.api.aero/airport/nearest/41.875415/-87.624781?user_key=135135fe04927c7f832adf658d4b4b50"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSLog(@"Response: %@", jsonDict);
    }];




}


@end


/*
callback(
 {
 "processingDurationMillis":53,
 "authorisedAPI":true,
 "success":true,
 "airline":null,
 "errorMessage":null,

 "airports":[
 {"code":"BUS",
 "name":"Batumi",
 "city":"Batumi",
 "country":"Georgia",
 "lat":41.610278,
 "lng":41.599694,
 "terminal":null,
 "gate":null,
 "timezone":
 "Asia/Tbilisi"
 },null]})
*/