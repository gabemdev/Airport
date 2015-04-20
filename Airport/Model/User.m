//
//  User.m
//  Airport
//
//  Created by Rockstar. on 4/19/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)fullName withUser:(NSString *)user andImage:(NSString *)image {
    if (self = [super init]) {
        self.name = fullName;
        self.username = user;
        self.imageURL = image;
    }
    return self;
}

@end
