//
//  AirportKit.h
//  Airport
//
//  Created by Rockstar. on 4/14/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirportKit : NSObject

+ (void)nearbyAirportsForLongitude:(float)longitude andLatitude:(float)latitude successCallback:(void (^)(id responseObject))successCallback errorCallback:(void (^)(NSString *error))errorCallback;


@end
