//
//  User.h
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

+ (User *)sharedInstance;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *accessTokenSecret;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *bannerImageUrl;
@property (strong, nonatomic) NSString *followerCount;
@property (strong, nonatomic) NSString *followingCount;

- (void)loginWithDictionary:(NSDictionary *)dictionary;
- (BOOL)isLoggedIn;
- (void)logout;

@end
