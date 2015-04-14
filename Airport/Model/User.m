//
//  User.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "User.h"
#import "AirportAPIClient.h"

NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";

static NSString *const kPersistKey = @"Airport.User";
@interface User ()
@property (strong, nonatomic) NSDictionary *authAttributes;
- (void)setAuthAttributes:(NSDictionary *)authAttributes;

- (NSDictionary *)load;
- (BOOL)persist;
@end

@implementation User

+ (User *)sharedInstance {
    static dispatch_once_t once;
    static User *instance;
    dispatch_once(&once, ^{
        instance = [[User alloc] init];
        [instance load];
    });
    return instance;
}

- (void)setAuthAttributes:(NSDictionary *)authAttributes
{
    if (![_authAttributes isEqualToDictionary:authAttributes]) {
        NSLog(@"User.setAttributes: changed");
        _authAttributes = authAttributes;

        if (authAttributes) {
            NSDictionary *credentials = [authAttributes objectForKey:@"credentials"];
            self.accessToken = [credentials objectForKey:@"token"];
            self.accessTokenSecret = [credentials objectForKey:@"secret"];

            AirportAPIClient *apiClient = [AirportAPIClient sharedInstance];
            [apiClient setAccessToken:self.accessToken
                               secret:self.accessTokenSecret];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *info = [authAttributes objectForKey:@"info"];
                self.bannerImageUrl = [NSString stringWithFormat:@"%@", info[@"banner"]];
                self.profileImageUrl = [NSString stringWithFormat:@"%@", info[@"image"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.status = info[@"description"];
                    self.screenName = [NSString stringWithFormat:@"@%@",info[@"nickname"]];
                    self.name = info[@"name"];
                    self.followerCount = [NSString stringWithFormat:@"%@",info[@"followers"]];
                    self.followingCount = [NSString stringWithFormat:@"%@",info[@"following"]];
                });
            });
        }
    }
}

- (NSDictionary *)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[ud objectForKey:kPersistKey];
    self.authAttributes = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return self.authAttributes;
}

- (BOOL)persist
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.authAttributes];
    [ud setObject:data forKey:kPersistKey];
    BOOL retVal = [ud synchronize];
    if (retVal) {
        NSLog(@"User.persist: success");
    }
    else {
        NSLog(@"User.persist: failure");
    }
    return retVal;
}

#pragma mark - login, logout

- (void)loginWithDictionary:(NSDictionary *)dictionary
{
    self.authAttributes = dictionary;
    [self persist];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
}

- (BOOL)isLoggedIn
{
    return ([self.authAttributes objectForKey:@"credentials"] != nil);
}

- (void)logout
{
    self.authAttributes = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
