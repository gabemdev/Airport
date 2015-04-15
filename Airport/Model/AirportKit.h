//
//  AirportKit.h
//  Airport
//
//  Created by Rockstar. on 4/14/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirportKit : NSObject


+ (void)getNearbyAirportsWithLong:(float)longitude andLat:(float)latitude;
@end
