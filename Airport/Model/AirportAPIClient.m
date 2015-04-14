//
//  AirportAPIClient.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "AirportAPIClient.h"

@interface AirportAPIClient ()
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *accessTokenSecret;
@end

@implementation AirportAPIClient
+ (AirportAPIClient *)sharedInstance {
    static dispatch_once_t once;
    static AirportAPIClient *instance;
    dispatch_once(&once, ^{
        instance = [[AirportAPIClient alloc] init];
    });
    return instance;
}

- (void)setAccessToken:(NSString *)accessToken secret:(NSString *)secret
{
    self.accessToken = [accessToken copy];
    self.accessTokenSecret = [secret copy];
}

@end
