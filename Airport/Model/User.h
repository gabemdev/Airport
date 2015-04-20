//
//  User.h
//  Airport
//
//  Created by Rockstar. on 4/19/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface User : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *imageURL;

- (instancetype)initWithName:(NSString *)fullName withUser:(NSString *)user andImage:(NSString *)image NS_DESIGNATED_INITIALIZER;

@end
