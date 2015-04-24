//
//  User.m
//  Airport
//
//  Created by Rockstar. on 4/19/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "User.h"
#import <TwitterKit/TwitterKit.h>

@implementation User

- (instancetype)initWithName:(NSString *)fullName withUser:(NSString *)user andImage:(NSString *)image {
    if (self = [super init]) {
        self.name = fullName;
        self.username = user;
        self.imageURL = image;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {

        self.name = [NSString stringWithFormat:@"%@", dictionary[@"name"]];
        self.username = [NSString stringWithFormat:@"%@", dictionary[@"screen_name"]];
        self.bio = [NSString stringWithFormat:@"%@", dictionary[@"description"]];

        self.imageURL = [NSString stringWithFormat:@"%@", dictionary[@"profile_image_url"]];
        self.imageURL = [self.imageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_reasonably_small"];

        //Profile links
        NSDictionary *urls = dictionary[@"entities"][@"url"];
        NSArray *urlArray = urls[@"urls"];
        self.expanded_url = [NSString stringWithFormat:@"%@", urlArray[0][@"expanded_url"]];

        //Follower info
        self.followerCount = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"]];
        self.followingCount = [NSString stringWithFormat:@"%@", dictionary[@"friends_count"]];
    }
    return self;
}

+ (void)getUserInformationWithCompletion:(void (^)(User *))completion {
    [[[Twitter sharedInstance] APIClient] loadUserWithID:[[Twitter sharedInstance] session].userID completion:^(TWTRUser *user, NSError *error) {
        if (user) {
            NSString *userString = @"https://api.twitter.com/1.1/users/show.json";
            NSDictionary *params = @{@"screen_name" : [user screenName]};
            NSError *error;
            NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:userString parameters:params error:&error];
            if (request) {
                [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (data) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                        completion([[User alloc] initWithDictionary:json]);
                    }
                }];
            }
        }
    }];
}

@end
