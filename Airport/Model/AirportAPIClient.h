//
//  AirportAPIClient.h
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirportAPIClient : NSObject

+ (AirportAPIClient *)sharedInstance;

- (void)setAccessToken:(NSString *)accessToken secret:(NSString *)secret;

@end
