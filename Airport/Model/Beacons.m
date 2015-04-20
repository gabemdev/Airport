//
//  Beacons.m
//  Airport
//
//  Created by Rockstar. on 4/18/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "Beacons.h"

@implementation Beacons

- (instancetype)init {

    if ((self = [super init])) {
        _beaconUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"],
                         [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
    }
    return self;
}

+ (Beacons *)sharedBeacons {
    static id sharedBeacons = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBeacons = [[self alloc] init];
    });

    return sharedBeacons;
}

- (NSUUID *)kitckenUUID {
    return [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"];
}

- (NSUUID *)room1UUID {
    return [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
}

@end
