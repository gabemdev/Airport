//
//  Beacons.h
//  Airport
//
//  Created by Rockstar. on 4/18/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *BeaconIdentifier;

@interface Beacons : NSObject

+ (Beacons *)sharedBeacons;

@property (nonatomic, copy, readonly) NSArray *beaconUUIDs;
@property (nonatomic, copy, readonly) NSUUID *kitckenUUID;
@property (nonatomic, copy, readonly) NSUUID *room1UUID;

@end
